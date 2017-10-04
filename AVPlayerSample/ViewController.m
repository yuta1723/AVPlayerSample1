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
    [self createMp4Button];
    [self createHLSButton];


//    [self initImageView];
}

-(void)createMp4Button {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((_screenWidth/2 - 100/2), 200, 100, 30);
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"MP4 button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playbackMp4Content:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

-(void)createHLSButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((_screenWidth/2 - 100/2), 400, 100, 30);
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"HLS button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playbackHLSContent:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

-(void)playbackMp4Content:(UIButton*)button{
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"http://210.148.141.57/hls/video/dvr/livestream01_2/playlist.m3u8"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
//    [self presentViewController: secondVC animated:YES completion: nil];
}

-(void)playbackHLSContent:(UIButton*)button{
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

