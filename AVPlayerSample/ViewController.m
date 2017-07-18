//
//  ViewController.m
//  AVPlayerSample
//
//  Created by y.naito on 2017/07/05.
//  Copyright © 2017年 y.naito. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic,strong) AVPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic,strong) AVAudioSession *audioSession;

@property (nonatomic) BOOL isFullScreen;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"NaitoAVPlayerSample : viewWillAppear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"NaitoAVPlayerSample : viewDidLoad");
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    //AppDelegateからのnotificateを受信する
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(viewDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [nc addObserver:self selector:@selector(viewWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];
    
    
    [self createPlayerInstance];
}

- (void)viewDidEnterBackground
{
    [(AVPlayerLayer*)_playerView.layer setPlayer:nil];
//    [[playerView playerLayer] setPlayer:nil]; // remove the player
    NSLog(@"NaitoAVPlayerSample : viewDidEnterBackground");
}

// フォアグラウンド移行直前にコールされるメソッド
- (void)viewWillEnterForeground
{
    [(AVPlayerLayer*)_playerView.layer setPlayer:_player];
//    [[playerView playerLayer] setPlayer:_player]; // restore the player
    NSLog(@"NaitoAVPlayerSample : viewWillEnterForeground");
    
}
- (BOOL)createAudioSessionInstance
{
    //バックグラウンドでも再生できるようにCategoryを変更.
    _audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    BOOL success = [_audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
//        BOOL success = [_audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    if (!success) {
        NSLog(@"NaitoAVPlayerSample : can not create audioSession");
        /* handle the error condition */
//        return NO;
    }
    
    NSError *activationError = nil;
    success = [_audioSession setActive:YES error:&activationError];
    if (!success) {
        NSLog(@"NaitoAVPlayerSample : can not active audioSession");
        /* handle the error condition */
        return NO;
    }
    return YES;
}

- (void)createPlayerInstance
{
    [self createAudioSessionInstance];
    NSURL *url = [NSURL URLWithString:@"http://domain/path/contents.mp4"];
    [self attachRemoteCommandCenter];
    _player = [[AVPlayer alloc]initWithURL:url];
    _playerView = [[AVPlayerView alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width,300)];
    [(AVPlayerLayer*)_playerView.layer setPlayer:_player];
    [self.view addSubview:_playerView];
    [self.view bringSubviewToFront:_playerView];
    
    [self play];
    [self setUpRemoteControllers];
    
}
- (void) attachRemoteCommandCenter {
    //addTargetを行うことで有効化された
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.pauseCommand setEnabled:YES];
    [commandCenter.pauseCommand addTarget:self action:@selector(onPushedPauseCommand)];
//    [commandCenter.togglePlayPauseCommand setEnabled:YES];
//    [commandCenter.togglePlayPauseCommand addTarget:self action:@selector(onPushedtoggleCommand)];
    [commandCenter.skipBackwardCommand setEnabled:YES];
    [commandCenter.skipBackwardCommand addTarget:self action:@selector(onSkipBackwardCommand)];
    [commandCenter.skipForwardCommand setEnabled:YES];
    [commandCenter.skipForwardCommand addTarget:self action:@selector(onSkipForwardCommand)];
    
    NSNumber *shouldScrub = [NSNumber numberWithBool:YES];
    [[[MPRemoteCommandCenter sharedCommandCenter] changePlaybackPositionCommand]
     performSelector:@selector(setCanBeControlledByScrubbing:) withObject:shouldScrub];
    
    [commandCenter.changePlaybackPositionCommand setEnabled:YES];
    [commandCenter.changePlaybackPositionCommand addTarget:self action:@selector(onChangePositionCommand:)];
    
//    [commandCenter.seekForwardCommand setEnabled:YES];
//    [commandCenter.seekForwardCommand addTarget:self action:@selector(onSeekForwardCommand:)];
//
//    [commandCenter.seekBackwardCommand setEnabled:YES];
//    [commandCenter.seekBackwardCommand addTarget:self action:@selector(onSeekBackwardCommand:)];
    
}

-(BOOL) onPushedPlayCommand
{
    NSLog(@"NaitoAVPlayerSample : onPushedplayCommand");
    [self play];
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.pauseCommand setEnabled:YES];
    [commandCenter.playCommand setEnabled:NO];
    [commandCenter.pauseCommand addTarget:self action:@selector(onPushedPauseCommand)];
    
    return YES;
}

-(BOOL) onPushedPauseCommand
{
    NSLog(@"NaitoAVPlayerSample : onPushedPauseCommand");
    [self pause];
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand setEnabled:YES];
    [commandCenter.pauseCommand setEnabled:NO];
    [commandCenter.playCommand addTarget:self action:@selector(onPushedPlayCommand)];
    
    return YES;
}

-(BOOL) onPushedtoggleCommand
{
    NSLog(@"NaitoAVPlayerSample : onPushedtoggleCommand");
    [self playOrPause];
    return YES;
}

-(BOOL) onPushedPreCommand
{
    NSLog(@"NaitoAVPlayerSample : onPushedPreCommand");
    [self playOrPause];
    
    return YES;
}

-(BOOL) onSkipBackwardCommand
{
    NSLog(@"NaitoAVPlayerSample : onSkipBackwardCommand");
    [self skipBackward];
    
    return YES;
}

-(BOOL) onSkipForwardCommand
{
    NSLog(@"NaitoAVPlayerSample : onSkipForwardCommand");
    [self skipForward];
    
    return YES;
}

-(BOOL) onSeekBackwardCommand:(MPSkipIntervalCommandEvent *)skipEvent
{
    NSLog(@"NaitoAVPlayerSample : onSkipBackwardCommand");
    NSLog(@"NaitoAVPlayerSample : skip by %f",skipEvent.interval);
    
    [self seekBackward:skipEvent.interval];
    
    return YES;
}

-(BOOL) onChangePositionCommand:(MPChangePlaybackPositionCommandEvent *)event
{
    NSLog(@"NaitoAVPlayerSample : onChangePositionCommand");
    NSLog(@"NaitoAVPlayerSample : skip by %f",event.positionTime);
    
    [self seekBackward:event.positionTime];
    
    return YES;
}

-(BOOL) onSeekForwardCommand:(MPSkipIntervalCommandEvent *)skipEvent
{
    NSLog(@"NaitoAVPlayerSample : onSeekForwardCommand");
    NSLog(@"NaitoAVPlayerSample : skip by %f",skipEvent.interval);
    [self seekForward:skipEvent.interval];
    
    return YES;
}

-(BOOL) pause
{
    NSLog(@"NaitoAVPlayerSample : pause");
    [_player pause];
    
    return YES;
}
-(BOOL) play
{
    NSLog(@"NaitoAVPlayerSample : play!");
    [_player play];
    
    return YES;
}

- (void)playOrPause
{
    if (_player.rate == 1.0) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)skipForward
{
    NSLog(@"NaitoAVPlayerSample : skipForward");
    double currentPosition = CMTimeGetSeconds(_player.currentTime);
    double duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    NSLog(@"NaitoAVPlayerSample : currentPosition:%f", currentPosition);
    NSLog(@"NaitoAVPlayerSample : duration:%f", duration);
    CMTime time = CMTimeMakeWithSeconds(duration - 10 , NSEC_PER_SEC);
    if (currentPosition + 15 < duration) {
        time = CMTimeMakeWithSeconds(currentPosition + 15, NSEC_PER_SEC);
    }
    [_player seekToTime:time];
}

- (void)skipBackward
{
    NSLog(@"NaitoAVPlayerSample : skipBackward");
    double currentPosition = CMTimeGetSeconds([_player currentTime]);
    double duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    NSLog(@"NaitoAVPlayerSample : currentPosition:%f", currentPosition);
    NSLog(@"NaitoAVPlayerSample : duration:%f", duration);
    CMTime time = CMTimeMakeWithSeconds(0, NSEC_PER_SEC);
    if (currentPosition - 15 > 0) {
        time = CMTimeMakeWithSeconds(currentPosition - 15, NSEC_PER_SEC);
    }
    [_player seekToTime:time];
}

- (void)seekForward : (long)seekPosition
{
    NSLog(@"NaitoAVPlayerSample : seekForward");
    double currentPosition = CMTimeGetSeconds(_player.currentTime);
    double duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    NSLog(@"NaitoAVPlayerSample : currentPosition:%f", currentPosition);
    NSLog(@"NaitoAVPlayerSample : duration:%f", duration);
    CMTime time = CMTimeMakeWithSeconds(seekPosition, NSEC_PER_SEC);
    [_player seekToTime:time];
}

- (void)seekBackward : (long)seekPosition
{
    NSLog(@"NaitoAVPlayerSample : seekBackward");
    double currentPosition = CMTimeGetSeconds([_player currentTime]);
    double duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    NSLog(@"NaitoAVPlayerSample : currentPosition:%f", currentPosition);
    NSLog(@"NaitoAVPlayerSample : duration:%f", duration);
    CMTime time = CMTimeMakeWithSeconds(seekPosition, NSEC_PER_SEC);
    [_player seekToTime:time];
}

-(void) setUpRemoteControllers
{
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
//    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionaryWithDictionary:center.nowPlayingInfo];
    double duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    float playbackState = 1;
    NSDictionary *contentInfo = @{
                                  MPMediaItemPropertyTitle:@"title",
                                  MPMediaItemPropertyArtist:@"artist",
                                  MPMediaItemPropertyPlaybackDuration:[NSNumber numberWithDouble:duration],
                                  MPNowPlayingInfoPropertyPlaybackRate:[NSNumber numberWithFloat:playbackState]
                                  };
//    [playingInfo setObject:[NSNumber numberWithFloat:0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [center setNowPlayingInfo:contentInfo];
    
}

-(void) updateRemoteControllers
{
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    //    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionaryWithDictionary:center.nowPlayingInfo];
    double duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    float playbackState = 1;
    if (_player.rate == 0.0) {
        playbackState = 0;
    }
    NSDictionary *contentInfo = @{
                                  MPMediaItemPropertyTitle:@"title",
                                  MPMediaItemPropertyArtist:@"artist",
                                  MPMediaItemPropertyPlaybackDuration:[NSNumber numberWithDouble:duration],
                                  MPNowPlayingInfoPropertyPlaybackRate:[NSNumber numberWithFloat:playbackState]
                                  };
    //    [playingInfo setObject:[NSNumber numberWithFloat:0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [center setNowPlayingInfo:contentInfo];
}


@end

//実装はここを参照http://dev.classmethod.jp/smartphone/ios-video/
//background再生に関するrefhttps://developer.apple.com/library/content/qa/qa1668/_index.html#
//controlCenterのrefはhttp://qiita.com/yimajo/items/c30c4d5f5eab06172028
//https://forums.developer.apple.com/thread/44619

