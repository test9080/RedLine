//
//  TUTabBar.h
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TUTabBarDelegate <NSObject>


@end

@interface TUTabBar : UIView

@property (nonatomic, weak) id<TUTabBarDelegate> delegate;

@end
