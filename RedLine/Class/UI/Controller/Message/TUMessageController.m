//
//  TUMessageController.m
//  RedLine
//
//  Created by LXJ on 16/4/21.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUMessageController.h"
#import "TUFriendListTableController.h"

@interface TUMessageController ()

@end

@implementation TUMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = self.titleScrollView;
    // 添加所有子控制器
    [self setUpAllViewController];
    // 设置标题字体
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight) {
        
        *titleFont = [UIFont systemFontOfSize:15];
        
    }];
    // 推荐方式（设置下标）
    [self setUpUnderLineEffect:^(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor) {
        
        // 是否显示标签
        *isShowUnderLine = YES;
        
        // 标题填充模式
        *underLineColor = [UIColor redColor];
        
    }];
    
    // 设置全屏显示
    // 如果有导航控制器或者tabBarController,需要设置tableView额外滚动区域,详情请看FullChildViewController
    self.isfullScreen = YES;
}

// 添加所有子控制器
- (void)setUpAllViewController {
    
    UIViewController *nearbyVC = [[UIViewController alloc] init];
    nearbyVC.title = @"消息";
    [self addChildViewController:nearbyVC];
    
    TUFriendListTableController *rankingVc = [[TUFriendListTableController alloc] init];
    rankingVc.title = @"好友";
    [self addChildViewController:rankingVc];
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
