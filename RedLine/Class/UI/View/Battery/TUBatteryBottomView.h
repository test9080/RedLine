//
//  TUBatteryBottomView.h
//  RedLine
//
//  Created by LXJ on 16/3/28.
//  Copyright © 2016年 cn. All rights reserved.
//

/*
 *
 *  温度和剩余电池寿命的View
 *
 */

#import <UIKit/UIKit.h>

@interface TUBatteryBottomView : UIView


- (void)updateTemperatureUI:(CGFloat)temperature; //更新电池温度UI
- (void)updateBatteryLifeUI:(NSInteger)remainLifeMonths; //更新电池剩余寿命UI

@end
