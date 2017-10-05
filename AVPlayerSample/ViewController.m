//
//  ViewController.m
//  ScreenTransitionSample
//
//  Created by y.naito on 2017/07/14.
//  Copyright © 2017年 y.naito. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayerViewController.h"

@interface ViewController ()
@property (nonatomic) int screenWidth;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    UILabel *firstLabel = [[UILabel alloc] init];
    _screenWidth = self.view.frame.size.width;
    
//    self.navigationController.navigationBar.tintColor = [UIColor blueColor];  // バーアイテムカラー
//    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];  // バー背景色
    
    firstLabel.frame = CGRectMake((_screenWidth/2 - 150/2), 100, 150, 20);
    firstLabel.text = @"First Screen";
    firstLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:firstLabel];
    [self initView];

//    [self initImageView];
}

-(void)initView {
    [self createMp4ShortButton];
    [self createMp4LongButton];
    [self createHLSShortButton];
    [self createHLSLongButton];
    [self createHLSLiveButton];
}

-(void)createMp4ShortButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((_screenWidth/2 - 200/2), 200, 200, 30);
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"MP4 Short button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playbackMp4ShortContent:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

-(void)createMp4LongButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((_screenWidth/2 - 200/2), 250, 200, 30);
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"MP4 Long button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playbackMp4LongContent:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

-(void)createHLSShortButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((_screenWidth/2 - 200/2), 300, 200, 30);
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"HLS Short button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playbackHLSShortContent:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

-(void)createHLSLongButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((_screenWidth/2 - 200/2), 350, 200, 30);
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"HLS Long button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playbackHLSLongContent:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

-(void)createHLSLiveButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((_screenWidth/2 - 200/2), 400, 200, 30);
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"HLS Live button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playbackHLSLiveContent:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

-(void)playbackMp4ShortContent:(UIButton*)button{
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"http://54.248.249.96/hama3/content/sintel_720p.mp4"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
//    [self presentViewController: secondVC animated:YES completion: nil];
}

-(void)playbackMp4LongContent:(UIButton*)button{
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"http://54.248.249.96/hama3/content/subtitle/MED_Education_67min.mp4"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
    //    [self presentViewController: secondVC animated:YES completion: nil];
}

-(void)playbackHLSShortContent:(UIButton*)button{
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"https://tsg01.uliza.jp/ulizahtml5/content/bbb_100sec_hls/playlist.m3u8"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
    //    [self presentViewController: secondVC animated:YES completion: nil];
}

-(void)playbackHLSLongContent:(UIButton*)button{
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"https://www2.uliza.jp/IF/iphone/iPhonePlaylist.m3u8?v=MED_Education_67min_up_739_20170606115100521&p=6230&d=1560&n=4777&cpv=1&previewflag=1&if=1&logging=1"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
    //    [self presentViewController: secondVC animated:YES completion: nil];
}

-(void)playbackHLSLiveContent:(UIButton*)button{
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"http://210.148.141.57/hls/video/dvr/livestream01_2/playlist.m3u8"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
    //    [self presentViewController: secondVC animated:YES completion: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initImageView {
    UIImage *image1 = [UIImage imageNamed:@"AppIcon60x60"];
    UIImageView *imageView;
    
    // UIImageView 初期化
    imageView = [[UIImageView alloc] initWithImage:image1];
    [imageView setCenter:CGPointMake(160.0f, 200.0f)];
//    imageView.frame = CGRectMake((screenWidth/2 - 100/2), 400,image1.size.width,image1.size.height);
    
    // UIImageViewのインスタンスをビューに追加
    [self.view addSubview:imageView];
}

@end

