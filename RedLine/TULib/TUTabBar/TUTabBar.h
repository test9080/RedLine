//
//  TUTabBar.h
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUTabBarItem.h"


//// This is mainly for the top/bottom margin of the imageView
//static NSString const * keyTabBarItemContentVerticalMargin = @"VerticalMargin";

// The background color when the item is under selected/unselected
static NSString const * keyTabBarItemSelectionBackColor = @"SelectionBackgroundColor";
static NSString const * keyTabBarItemUnSelectionBackColor = @"UnSelectionBackgroundColor";

// The colour of the text in the item for the tabbar is under selected/unselected
static NSString const * keyTabBarItemSelectionTextColor = @"SelectionTextColor";
static NSString const * keyTabBarItemUnSelectionTextColor = @"UnSelectionTextColor";

// The font of the text
static NSString const * keyTabBarItemSelectionTitleFont = @"SelectionTitleFont";
static NSString const * keyTabBarItemUnSelectionTitleFont = @"UnSelectionTitleFont";

@class TUTabBar;
@protocol TUTabBarDelegate <NSObject>

@optional

///** 将要选中 */
//- (BOOL)tabBarCanSelectFrom:(NSInteger)from to:(NSInteger)to;

/** 选中 初次选中的时候 from = NSNotFound */
- (void)tabBar:(TUTabBar *)tabBar didSelectFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface TUTabBar : UIView

@property (nonatomic,   weak) id<TUTabBarDelegate> delegate;


///
- (instancetype)initWithItems:(NSArray<__kindof TUTabBarItem *> *)items frame:(CGRect)frame;

/**
 *  设置tab的选中
 *
 *  @param index        位置
 */
- (void)setSelectIndex:(NSUInteger)index;

/**
 *  设置tab的badge value
 *
 *  @param badgeValue 字符串类型的数值
 *  @param index      位置
 */
- (void)setBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index;

/**
 *  设置tab的属性
 *
 *  @param tabConfig 配置 参照 key
 */
- (void)setTabBarConfig:(NSDictionary *)config;

- (NSUInteger)currentIndex;

@end
