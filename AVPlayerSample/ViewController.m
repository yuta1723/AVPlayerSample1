//
//  ViewController.m
//  ScreenTransitionSample
//
//  Created by y.naito on 2017/07/14.
//  Copyright © 2017年 y.naito. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayerViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) int screenWidth;
@property (nonatomic) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    _screenWidth = self.view.frame.size.width;
    
     _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // "cell"というkeyでcellデータを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    // cellデータが無い場合、UITableViewCellを生成して、"cell"というkeyでキャッシュする
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    switch (row) {
        case 0:
            cell.textLabel.text = @"MP4 10min";
            break;
        case 1:
            cell.textLabel.text = @"MP4 60min";
            break;
        case 2:
            cell.textLabel.text = @"HLS 10min";
            break;
        case 3:
            cell.textLabel.text = @"HLS 60min";
            break;
        case 4:
            cell.textLabel.text = @"MP4 HLS";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    switch (row) {
        case 0:
            [self playbackMp4ShortContent];
            break;
        case 1:
            [self playbackMp4LongContent];
            break;
        case 2:
            [self playbackHLSShortContent];
            break;
        case 3:
            [self playbackHLSLongContent];
            break;
        case 4:
            [self playbackHLSLiveContent];
            break;
        default:
            break;
    }
    // cellがタップされた際の処理
}

//1つのセクションに含まれるrowの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

//TableViewのセクションの数を返す
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//TableViewのセクション名を返す
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"section%ld", (long)section];
}

-(void)playbackMp4ShortContent {
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"http://54.248.249.96/hama3/content/sintel_720p.mp4"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
//    [self presentViewController: secondVC animated:YES completion: nil];
}

-(void)playbackMp4LongContent {
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"http://54.248.249.96/hama3/content/subtitle/MED_Education_67min.mp4"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
    //    [self presentViewController: secondVC animated:YES completion: nil];
}

-(void)playbackHLSShortContent {
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"https://tsg01.uliza.jp/ulizahtml5/content/bbb_100sec_hls/playlist.m3u8"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
    //    [self presentViewController: secondVC animated:YES completion: nil];
}

-(void)playbackHLSLongContent {
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    NSURL *url =[NSURL URLWithString:@"https://www2.uliza.jp/IF/iphone/iPhonePlaylist.m3u8?v=MED_Education_67min_up_739_20170606115100521&p=6230&d=1560&n=4777&cpv=1&previewflag=1&if=1&logging=1"];
    [secondVC setPlayUrl:url];
    [self.navigationController pushViewController:secondVC animated:YES];
    //    [self presentViewController: secondVC animated:YES completion: nil];
}

-(void)playbackHLSLiveContent {
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

