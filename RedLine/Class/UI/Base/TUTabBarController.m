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

    self.tabBar.hidden = YES;

    NSArray *titles = @[@"充电", @"红线", @"排行", @"我的"];
    NSArray *selectImages = @[@"tab_chongdianbig", @"tab_hongxianbig", @"tab_paihangbig", @"tab_wodebig"];
    NSArray *unSelectImages = @[@"tab_chongdian", @"tab_hongxian", @"tab_paihang", @"tab_wode"];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i ++) {
        TUTabBarItem *item = [[TUTabBarItem alloc] init];
        item.title = titles[i];
        item.selectImage = [UIImage imageNamed:selectImages[i]];
        item.unSelectImage = [UIImage imageNamed:unSelectImages[i]];
        [items addObject:item];
    }

    
    TUTabBar *tabBar = [[TUTabBar alloc] initWithItems:items frame:CGRectZero];
    tabBar.delegate = self;
    [tabBar setSelectIndex:0];
    [self.view addSubview:tabBar];
}

- (void)tabBar:(TUTabBar *)tabBar didSelectFrom:(NSInteger)from to:(NSInteger)to {
    [self setSelectedIndex:to];
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
