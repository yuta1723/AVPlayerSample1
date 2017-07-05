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
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(applicationDidEnterBackground)
               name:@"applicationDidEnterBackground" object:nil];
    [nc addObserver:self selector:@selector(applicationWillEnterForeground)
               name:@"applicationWillEnterForeground" object:nil];
    [self playAudio];
}
    
    // 再生時間とシークバー位置を連動させるためのタイマー
//    const double interval = ( 0.5f * _slider.maximumValue ) / _slider.bounds.size.width;
//    const CMTime time     = CMTimeMakeWithSeconds( interval, NSEC_PER_SEC );
//    [_player addPeriodicTimeObserverForInterval:time
//                                          queue:NULL
//                                     usingBlock:^( CMTime time ) { [self syncSeekBar]; }];


- (void)syncSeekBar
{
    // スライダーの位置合わせ
    Float64 duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    Float64 time     = CMTimeGetSeconds([_player currentTime]);
    Float64 value    = ( _slider.maximumValue - _slider.minimumValue ) * time / duration + _slider.minimumValue;
    [_slider setValue:value];
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
    Float64 duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    
    // スライダーの最大値を設定
    _slider.maximumValue = duration;
    
    //再生.
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"file_name"
//                                         withExtension:@"mp4"];
//    avPlayer = [[AVPlayer alloc] initWithURL:url];
    [_player play];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"ViewController : applicationDidEnterBackground");
}

// フォアグラウンド移行直前にコールされるメソッド
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"ViewController : applicationWillEnterForeground");
    
}

@end
