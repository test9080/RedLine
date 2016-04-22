//
//  AppDelegate.m
//  RedLine
//
//  Created by cn on 16/3/25.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "AppDelegate.h"

#import "TUTabBarController.h"
#import "TUNavigationController.h"

#import "TUBatteryController.h"
#import "TUFindViewController.h"
#import "TUMessageController.h"
#import "TUMineController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self setupViewControllers];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (TUTabBarController *)setupViewControllers {
    
    TUTabBarController *tabBarController = [[TUTabBarController alloc] init];
    
    // 充电
    TUBatteryController *batteryVC = [[TUBatteryController alloc] initWithNibName:@"TUBatteryController" bundle:nil];
    batteryVC.title = @"充电";
    TUNavigationController *batteryNav = [[TUNavigationController alloc] initWithRootViewController:batteryVC];
    
    // 发现
    TUFindViewController *findVC = [[TUFindViewController alloc] init];
    TUNavigationController *findNav = [[TUNavigationController alloc] initWithRootViewController:findVC];
    
    // 消息
    TUMessageController *megVC = [[TUMessageController alloc]init];
    TUNavigationController *megNav = [[TUNavigationController alloc] initWithRootViewController:megVC];
    
    // 我的
    TUMineController *mineVC = [[TUMineController alloc] initWithNibName:@"TUMineController" bundle:nil];
    mineVC.title = @"我的";
    TUNavigationController *mineNav = [[TUNavigationController alloc] initWithRootViewController:mineVC];
    
    [tabBarController setViewControllers:@[batteryNav, findNav, megNav, mineNav]];
    
    return tabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
