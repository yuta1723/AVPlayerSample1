//
//  AppDelegate.m
//  AVPlayerSample
//
//  Created by y.naito on 2017/07/05.
//  Copyright © 2017年 y.naito. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //最初に表示されるviewControllerを作る
    //make view controller which will be displayed first
    ViewController* baseViewCtrl = [[ViewController alloc]init];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    baseViewCtrl.view.frame = CGRectMake(0,0,bounds.size.width, bounds.size.height);
    
    //make navigation controller and make it as root
    //UINavigationControllerを作り、rootViewControlelrにする。
    UINavigationController* navCtrl=[[UINavigationController alloc] initWithRootViewController:baseViewCtrl ];
    self.window.rootViewController = navCtrl;

    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
    NSNotification* n = [NSNotification notificationWithName:@"applicationWillResignActive" object:self];
    // 通知実行
    [[NSNotificationCenter defaultCenter] postNotification:n];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    NSNotification* n = [NSNotification notificationWithName:@"applicationDidBecomeActive" object:self];
    // 通知実行
    [[NSNotificationCenter defaultCenter] postNotification:n];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationDidEnterBackground");
    NSNotification* n = [NSNotification notificationWithName:@"applicationWillTerminate" object:self];
    // 通知実行
    [[NSNotificationCenter defaultCenter] postNotification:n];
}


// バックグラウンド移行後にコールされるメソッド
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    NSNotification* n = [NSNotification notificationWithName:@"applicationDidEnterBackground" object:self];
    // 通知実行
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

// フォアグラウンド移行直前にコールされるメソッド
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    NSNotification* n = [NSNotification notificationWithName:@"applicationWillEnterForeground" object:self];
    // 通知実行
    [[NSNotificationCenter defaultCenter] postNotification:n];
}


@end
