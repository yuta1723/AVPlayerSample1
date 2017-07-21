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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *firstLabel = [[UILabel alloc] init];
    int screenWidth = self.view.frame.size.width;
    
    firstLabel.frame = CGRectMake((screenWidth/2 - 150/2), 100, 150, 20);
    firstLabel.text = @"First Screen";
    firstLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:firstLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((screenWidth/2 - 100/2), 200, 100, 30);
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Move Scene" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(moveButton:)forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
}

-(void)moveButton:(UIButton*)button{
    AVPlayerViewController *secondVC = [[AVPlayerViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
//    [self presentViewController: secondVC animated:YES completion: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

