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
    
    [self playAudio];
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

-(BOOL) playAudio
{
    NSLog(@"naito : playAudio!");
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
    
    NSURL *url = [NSURL URLWithString:@"http://domain/path/contents.mp4"];
    _player = [[AVPlayer alloc]initWithURL:url];
    _playerView = [[AVPlayerView alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width,300)];
    [(AVPlayerLayer*)_playerView.layer setPlayer:_player];
    [self.view addSubview:_playerView];
    [self.view bringSubviewToFront:_playerView];
    
    [_player play];
    
    return YES;
    
    //ビデオの長さ(Sec)を取得
//    Float64 duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    
    //再生.
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"file_name"
//                                         withExtension:@"mp4"];
//    avPlayer = [[AVPlayer alloc] initWithURL:url];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playOrPause];
                break;
                
            default:
                break;
        }
    }
}

- (void)playOrPause
{
    [_player pause];
}
@end

//実装はここを参照http://dev.classmethod.jp/smartphone/ios-video/
//background再生に関するrefhttps://developer.apple.com/library/content/qa/qa1668/_index.html#
