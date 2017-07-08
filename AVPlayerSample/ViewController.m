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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //AppDelegateからのnotificateを受信する
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [nc addObserver:self selector:@selector(applicationWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];
    
    [self playAudio];
//    [self pick];
}

- (void)applicationDidEnterBackground
{
    [(AVPlayerLayer*)_playerView.layer setPlayer:nil];
//    [[playerView playerLayer] setPlayer:nil]; // remove the player
    NSLog(@"ViewController : applicationDidEnterBackground");
}

// フォアグラウンド移行直前にコールされるメソッド
- (void)applicationWillEnterForeground
{
    [(AVPlayerLayer*)_playerView.layer setPlayer:_player];
//    [[playerView playerLayer] setPlayer:_player]; // restore the player
    NSLog(@"ViewController : applicationWillEnterForeground");
    
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
    
    //ビデオの長さ(Sec)を取得
//    Float64 duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    
    //再生.
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"file_name"
//                                         withExtension:@"mp4"];
//    avPlayer = [[AVPlayer alloc] initWithURL:url];
    [_player play];
    
    return YES;
}

@end
