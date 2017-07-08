//
//  ViewController.m
//  AVPlayerSample
//
//  Created by y.naito on 2017/07/05.
//  Copyright © 2017年 y.naito. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic,strong) AVPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL isFullScreen;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"ViewController : viewWillAppear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ViewController : viewDidLoad");
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
    NSLog(@"ViewController : viewDidEnterBackground");
}

// フォアグラウンド移行直前にコールされるメソッド
- (void)viewWillEnterForeground
{
    [(AVPlayerLayer*)_playerView.layer setPlayer:_player];
//    [[playerView playerLayer] setPlayer:_player]; // restore the player
    NSLog(@"ViewController : viewWillEnterForeground");
    
}
- (BOOL)createAudioSessionInstance
{
    //バックグラウンドでも再生できるようにCategoryを変更.
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    //    BOOL success = [audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    if (!success) {
        NSLog(@"naito : can not create audioSession");
        /* handle the error condition */
        return NO;
    }
    
    NSError *activationError = nil;
    success = [audioSession setActive:YES error:&activationError];
    if (!success) {
        NSLog(@"naito : can not active audioSession");
        /* handle the error condition */
        return NO;
    }
    return YES;
}

- (void)createPlayerInstance
{
    [self createAudioSessionInstance];
    NSURL *url = [NSURL URLWithString:@"http://domain/path/contents.mp4"];
    _player = [[AVPlayer alloc]initWithURL:url];
    _playerView = [[AVPlayerView alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width,300)];
    [(AVPlayerLayer*)_playerView.layer setPlayer:_player];
    [self.view addSubview:_playerView];
    [self.view bringSubviewToFront:_playerView];
    
    [self setUpRemoteControllers];
    
    [self play];
    
}
-(BOOL) pause
{
    NSLog(@"naito : pause");
    [_player pause];
    
    return YES;
}
-(BOOL) play
{
    NSLog(@"naito : play!");
    [_player play];
    
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"pressed : UIEventSubtypeRemoteControlPlay");
                [self updateRemoteControllers];
                [self pause];
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"pressed : UIEventSubtypeRemoteControlPause");
                [self updateRemoteControllers];
                [self play];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"pressed : UIEventSubtypeRemoteControlTogglePlayPause");
                [self updateRemoteControllers];
                [self playOrPause];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"pressed : UIEventSubtypeRemoteControlNextTrack");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"pressed : UIEventSubtypeRemoteControlPreviousTrack");
                break;
            default:
                break;
        }
    }
}

- (void)playOrPause
{
    if (_player.rate == 1.0) {
        [self pause];
    } else {
        [self play];
    }
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

