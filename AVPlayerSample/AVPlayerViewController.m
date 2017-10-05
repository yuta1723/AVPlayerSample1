//
//  ViewController.m
//  AVPlayerSample
//
//  Created by y.naito on 2017/07/05.
//  Copyright © 2017年 y.naito. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayerViewController.h"
#import "AVPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>


@interface AVPlayerViewController ()

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic,strong) AVPlayerView *playerView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic,strong) AVAudioSession *audioSession;

@property (nonatomic,strong) UIButton *playpausebutton;
@property (nonatomic,strong) UIButton *playbackratebutton;
@property MPRemoteCommandCenter *commandCenter;
@property NSMutableDictionary *contentInfo;


@property (nonatomic) BOOL isFullScreen;
@property (nonatomic) BOOL isSetControlCenter;

@end

@implementation AVPlayerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"NaitoAVPlayerSample : viewWillAppear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor yellowColor];  // バーアイテムカラー
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];  // バー背景色
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.font = [UIFont boldSystemFontOfSize:16.0];
    title.textColor = [UIColor greenColor];
    title.text = @"再生画面";
    [title sizeToFit];
    self.navigationItem.titleView = title;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSLog(@"NaitoAVPlayerSample : viewDidLoad");
    
    //AppDelegateからのnotificateを受信する
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(viewDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [nc addObserver:self selector:@selector(viewWillEnterForeground) name:@"applicationWillEnterForeground" object:nil];
    [nc addObserver:self selector:@selector(applicationWillTerminate) name:@"applicationWillTerminate" object:nil];
    [nc addObserver:self selector:@selector(applicationWillResignActive) name:@"applicationWillResignActive" object:nil];
    [nc addObserver:self selector:@selector(applicationDidBecomeActive) name:@"applicationDidBecomeActive" object:nil];

    //再生完了のイベントを登録する。
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onVideoEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];

    
    [self createPlayerInstance];
//    [self createInlineWebview];
//    [self createPlayPauseButton];
//    [self createChangePlaybackrateButton];
    [self attachRemoteCommandCenter];
    [self setUpRemoteControllers];
    
}

//アプリバックグラウンド時に呼ぶメソッド。以下の処理を行う。
//Eventを取得するための処理を行う。
//コントロールセンターを有効化。
//コントロールセンターに情報を詰め込む。
//_playerView.layerにnilを設定(バックグラウンド再生用)
- (void)viewDidEnterBackground
{
//    NSLog(@"NaitoAVPlayerSample : viewDidEnterBackground");
//    [self attachRemoteCommandCenter];
//    [self setUpRemoteControllers];
    [(AVPlayerLayer*)_playerView.layer setPlayer:nil];
}

// フォアグラウンド移行直前にコールされるメソッド
- (void)viewWillEnterForeground
{
    [self clearRemoteControllers];
    [(AVPlayerLayer*)_playerView.layer setPlayer:_player];
//    NSLog(@"NaitoAVPlayerSample : viewWillEnterForeground");
    
}

// フォアグラウンド終了直前にコールされるメソッド
- (void)applicationWillTerminate
{
//    NSLog(@"NaitoAVPlayerSample : applicationWillTerminate");
    [self clearRemoteControllers];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
}

- (void)applicationWillResignActive
{
//    NSLog(@"applicationWillResignActive");
//    [self pause];
    
    // Handle notification
}

- (void)applicationDidBecomeActive
{
//    NSLog(@"applicationDidBecomeActive");
//    [self play];
    
    // Handle notification
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInterruptionAudioSession:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeAudioSessionRoute:) name:AVAudioSessionRouteChangeNotification object:nil];
//    _audioSession.delegate = self;
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
//    NSURL *url = [NSURL URLWithString:@"http://domain/path/contents.mp4"];
    NSURL *url = _PlayUrl;
    NSLog([url absoluteString]);
    _player = [[AVPlayer alloc]initWithURL:url];
    _playerView = [[AVPlayerView alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width,300)];
    [(AVPlayerLayer*)_playerView.layer setPlayer:_player];
    [self.view addSubview:_playerView];
    [self.view bringSubviewToFront:_playerView];
    
    
    float value = 2.0f;
    [_player setRate:value];

    [self play];
    
    CMTime time = CMTimeMake(1000, 200);
    [self.player addPeriodicTimeObserverForInterval:time queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"Time: %f", CMTimeGetSeconds(time));
    }];
    
    
}

- (void)createPlayPauseButton
{
    _playpausebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    int screenWidth = self.view.frame.size.width;
    _playpausebutton.frame = CGRectMake((screenWidth/2 - 100/2), 400, 100, 30);
    _playpausebutton.backgroundColor = [UIColor grayColor];
    [_playpausebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playpausebutton setTitle:@"pause" forState:UIControlStateNormal];
    [_playpausebutton addTarget:self action:@selector(playPauseButton:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_playpausebutton];
}

- (void)createChangePlaybackrateButton
{
    _playbackratebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    int screenWidth = self.view.frame.size.width;
    _playbackratebutton.frame = CGRectMake((screenWidth/2 - 100/2), 600, 200, 30);
    _playbackratebutton.backgroundColor = [UIColor grayColor];
    [_playbackratebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_playbackratebutton setTitle:@"change rate" forState:UIControlStateNormal];
    [_playbackratebutton addTarget:self action:@selector(changePlaybackrateButton:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_playbackratebutton];
}

-(void)moveButton:(UIButton*)button{
    ViewController *rootVC = [[ViewController alloc] init];
    [self presentViewController: rootVC animated:YES completion: nil];
}

-(void)playPauseButton:(UIButton*)button{
    if (_player.rate == 1.0) {
        [self pause];
        [button setTitle:@"play" forState:UIControlStateNormal];
    } else {
        [self play];
        [button setTitle:@"pause" forState:UIControlStateNormal];
        
    }
}

-(void)changePlaybackrateButton:(UIButton*)button{
    if (_player.rate == 1.0) {
        _player.rate = 1.5;
    }
}

- (void) attachRemoteCommandCenter {
    
    //以下の2行で、コントロールセンターにアプリの情報が記載された。
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //addTargetを行うことで有効化された
    _commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [_commandCenter.togglePlayPauseCommand setEnabled:YES];
    [_commandCenter.togglePlayPauseCommand addTarget:self action:@selector(onPushedtoggleCommand)];
    [_commandCenter.playCommand setEnabled:YES];
    [_commandCenter.playCommand addTarget:self action:@selector(onPushedPlayCommand)];
    [_commandCenter.pauseCommand setEnabled:YES];
    [_commandCenter.pauseCommand addTarget:self action:@selector(onPushedPauseCommand)];
    
    [_commandCenter.changePlaybackPositionCommand setEnabled:YES];
    [_commandCenter.changePlaybackPositionCommand addTarget:self action:@selector(onChangePositionCommand:)];
    
}

-(BOOL) onPushedPlayCommand
{
    NSLog(@"NaitoAVPlayerSample : onPushedplayCommand");
    [self play];
    
    [_commandCenter.pauseCommand setEnabled:YES];
    [_commandCenter.playCommand setEnabled:NO];
    [_commandCenter.pauseCommand addTarget:self action:@selector(onPushedPauseCommand)];
    
    [self updateCurrentTimeInControlCenter];
    
    return YES;
}

-(BOOL) onPushedPauseCommand
{
    NSLog(@"NaitoAVPlayerSample : onPushedPauseCommand");
    [self pause];
    
    [_commandCenter.playCommand setEnabled:YES];
    [_commandCenter.pauseCommand setEnabled:NO];
    [_commandCenter.playCommand addTarget:self action:@selector(onPushedPlayCommand)];
    
    [self updateCurrentTimeInControlCenter];
    
    return YES;
}

-(BOOL) onPushedtoggleCommand
{
    NSLog(@"NaitoAVPlayerSample : onPushedtoggleCommand");
    [self playOrPause];
    [self updateCurrentTimeInControlCenter];
    return YES;
}

-(BOOL) onChangePositionCommand:(MPChangePlaybackPositionCommandEvent *)event
{
    NSLog(@"NaitoAVPlayerSample : onChangePositionCommand");
    NSLog(@"NaitoAVPlayerSample : skip by %f",event.positionTime);
    
    [self seekTo:event.positionTime];
    if (_isSetControlCenter) {
        [self updateCurrentTimeInControlCenterBySeek:event.positionTime];
    }
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

- (void)seekTo : (long)seekPosition
{
    NSLog(@"NaitoAVPlayerSample : seekTo");
    double currentPosition = CMTimeGetSeconds([_player currentTime]);
    double duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    NSLog(@"NaitoAVPlayerSample : currentPosition:%f", currentPosition);
    NSLog(@"NaitoAVPlayerSample : seekPosition:%ld", seekPosition);
    CMTime time = CMTimeMakeWithSeconds(seekPosition, NSEC_PER_SEC);
    [_player seekToTime:time];
}

-(void) setUpRemoteControllers
{
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    UIImage *img_mae = [UIImage imageNamed:@"AppIcon60x60"];
    UIGraphicsEndImageContext();
    double currentPosition = CMTimeGetSeconds([_player currentTime]);
    double duration = CMTimeGetSeconds(_player.currentItem.asset.duration);
    float playbackState = 1;
    NSString *aplName = [[[NSBundle mainBundle] infoDictionary]
                         objectForKey:@"CFBundleDisplayName"];

    NSString *s2 = @"で再生しています。";
    NSString *str = [NSString stringWithFormat:@"%@ %@",aplName,s2];
    _contentInfo = [@{
                                  MPMediaItemPropertyTitle:@"BigBuckBunny",
                                  MPMediaItemPropertyArtist:str,
                                  MPMediaItemPropertyPlaybackDuration:[NSNumber numberWithDouble:duration],
                                  MPNowPlayingInfoPropertyElapsedPlaybackTime:[NSNumber numberWithDouble:currentPosition],
                                  MPNowPlayingInfoPropertyPlaybackRate:[NSNumber numberWithFloat:playbackState]
                                  }mutableCopy];
    //    [playingInfo setObject:[NSNumber numberWithFloat:0] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    if(img_mae) {
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: img_mae];
        [_contentInfo setValue:albumArt forKey:MPMediaItemPropertyArtwork];
    }
    [center setNowPlayingInfo:_contentInfo];
    _isSetControlCenter = TRUE;
}

-(void) updateCurrentTimeInControlCenter
{
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    double currentPosition = CMTimeGetSeconds([_player currentTime]);
    [_contentInfo setValue:[NSNumber numberWithDouble:currentPosition] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [center setNowPlayingInfo:_contentInfo];
}

-(void) updateCurrentTimeInControlCenterBySeek :(long)seekPosition
{
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    [_contentInfo setValue:[NSNumber numberWithLong:seekPosition] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [center setNowPlayingInfo:_contentInfo];
}

-(void)clearRemoteControllers
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    [_commandCenter.togglePlayPauseCommand setEnabled:NO];
    [_commandCenter.togglePlayPauseCommand removeTarget:self action:@selector(onPushedtoggleCommand)];
    [_commandCenter.playCommand setEnabled:NO];
    [_commandCenter.playCommand removeTarget:self action:@selector(onPushedPlayCommand)];
    [_commandCenter.pauseCommand setEnabled:NO];
    [_commandCenter.pauseCommand removeTarget:self action:@selector(onPushedPauseCommand)];
    _commandCenter = nil;
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
    _isSetControlCenter = FALSE;

}

- (void)beginInterruption
{
    //自動で再生中止するのでそのときの処理
    NSLog(@"stop playing audio");
}

- (void)endInterruptionWithFlags:(NSUInteger)flags
{
    //再生再開させるようにする
    NSLog(@"start playing audio");
    [self playOrPause];
    
}

- (void)didInterruptionAudioSession:(NSNotification *)notification
{
    // NSNotificationのUserInfoを取得
    NSDictionary* userInfo = notification.userInfo;
    // 割り込みタイプを取得
    AVAudioSessionInterruptionType audioSessionInterruptionType = [userInfo[@"AVAudioSessionInterruptionTypeKey"] longValue];
    switch (audioSessionInterruptionType) {
        case AVAudioSessionInterruptionTypeBegan:
            NSLog(@"割り込みの開始！");
            NSLog(@"割り込みが入ったので音声が停止された、UIを停z止状態のものに変更する。");
            break;
        case AVAudioSessionInterruptionTypeEnded:
            NSLog(@"割り込みの終了！");
            break;
        default:
            break;
    }
}

- (void)didChangeAudioSessionRoute:(NSNotification *)notification
{
    NSLog(@"didChangeAudioSessionRoute");
    // ヘッドホンが刺さっていたか取得
    BOOL (^isJointHeadphone)(NSArray *) = ^(NSArray *outputs){
        for (AVAudioSessionPortDescription *desc in outputs) {
            if ([desc.portType isEqual:AVAudioSessionPortHeadphones]) {
                return YES;
            }
        }
        return NO;
    };
    
    // 直前の状態を取得
    AVAudioSessionRouteDescription *prevDesc = notification.userInfo[AVAudioSessionRouteChangePreviousRouteKey];
    
    if (isJointHeadphone([[[AVAudioSession sharedInstance] currentRoute] outputs])) {
        if (!isJointHeadphone(prevDesc.outputs)) {
            NSLog(@"put in headphone");
            //ヘッドフォンが刺さった
        }
    } else {
        if(isJointHeadphone(prevDesc.outputs)) {
            //ヘッドフォンが抜かれた
            NSLog(@"put out headphone");
            [_player pause];
//            [_playpausebutton setTitle:@"play" forState:UIControlStateNormal];
        }
    }
}

-(void) createInlineWebview {
    UIWebView *wv = [[UIWebView alloc] init];
    wv.delegate = self;
    wv.frame = CGRectMake(0,320,self.view.frame.size.width,300);
    wv.scalesPageToFit = YES;
    [self.view addSubview:wv];
    
    NSURL *url = [NSURL URLWithString:@"http://54.248.249.96/hama3/overlay_webview/demo/mori4_demo.html"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [wv loadRequest:req];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = request.URL;
//    NSLog(@"URL=%@", URL.absoluteString);
    
    return true;
}

-(void)onVideoEnd {
    NSLog(@"enter onVideoEnd");
    [self clearRemoteControllers];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
}
@end

//実装はここを参照http://dev.classmethod.jp/smartphone/ios-video/
//background再生に関するrefhttps://developer.apple.com/library/content/qa/qa1668/_index.html#
//controlCenterのrefはhttp://qiita.com/yimajo/items/c30c4d5f5eab06172028
//https://forums.developer.apple.com/thread/44619
//https://stackoverflow.com/questions/20591156/is-there-a-public-way-to-force-mpnowplayinginfocenter-to-show-podcast-controls
//https://stackoverflow.com/questions/31463932/mpremotecommandcenter-pause-play-button-not-toggling/35081113


