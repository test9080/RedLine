//
//  TUTabBarController.m
//  RedLine
//
//  Created by chengxianghe on 16/3/25.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUTabBarController.h"
#import "TUTabBar.h"

@interface TUTabBarController () <TUTabBarDelegate>

@end

@implementation TUTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //tabbar是readonly的,所以只能通过KVC赋值,不能直接更改
    //为什么在这里更改系统的tabBar,在这里系统的tabBar还没有值
    
//    TUTabBar *tabBar = [[TUTabBar alloc] init];
//    tabBar.delegate = self;
//    [self setValue:tabBar forKeyPath:@"tabBar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
