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

- (TUTabBarController *)setupViewControllers
{
    TUTabBarController *tabBarController = [[TUTabBarController alloc] init];
    
    // 电池
    TUBatteryController *batteryVC = [[TUBatteryController alloc]init];
    batteryVC.title = @"电池";
    TUNavigationController *batteryNav = [[TUNavigationController alloc] initWithRootViewController:batteryVC];
    
    // 我的
    TUMineController *mineVC = [[TUMineController alloc] init];
    mineVC.title = @"我的";
    TUNavigationController *mineNav = [[TUNavigationController alloc] initWithRootViewController:mineVC];
    
    
//    tabBarController.delegate = self;
//    tabBarController.tabBar.delegate = self;
    
    [tabBarController setViewControllers:@[batteryNav, mineNav]];
    
//    [self customizeTabBarForController:tabBarController];
    
    return tabBarController;
}

- (void)customizeTabBarForController:(TUTabBarController *)tabBarController {
    
//    NSArray *tabBarItemImages = @[@"tab1", @"tab2"];
//    NSArray *tabBarItemSelectImages = @[@"tab1", @"tab2"];
//    NSArray *titles = @[@"电池", @"我的"];
//    
//    NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
//    for (int i = 0; i < titles.count; i++) {
//        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titles[i] image:[UIImage imageNamed:tabBarItemImages[i]] selectedImage:[UIImage imageNamed:tabBarItemSelectImages[i]]];
//
//        [tabBarItems addObject:item];
//    }
////    [tabBarController.tabBar addi]

//    [tabBarController.tabBar setItems:tabBarItems];
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
