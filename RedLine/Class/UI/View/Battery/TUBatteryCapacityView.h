//
//  TUBatteryCapacityView.h
//  CycleAnimationDemo
//
//  Created by LXJ on 16/3/25.
//  Copyright © 2016年 LianLuo. All rights reserved.
//

/*
 *
 *  电量圆圈动画View
 *
 */


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TUBatteryCapacityViewStyle) {
    TUBatteryCapacityViewStyleRed,
    TUBatteryCapacityViewStyleYellow,
    TUBatteryCapacityViewStyleGreen,
};

@interface TUBatteryCapacityView : UIView

@property (strong, nonatomic) UILabel *batteryCapacityLabel;
@property (strong, nonatomic) UILabel *batteryTimeLabel;

@property (assign, nonatomic) TUBatteryCapacityViewStyle batteryCapacityViewStyle;

@end
