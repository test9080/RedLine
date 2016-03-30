//
//  TUBatteryVIView.h
//  RedLine
//
//  Created by LXJ on 16/3/28.
//  Copyright © 2016年 cn. All rights reserved.
//

/*
 *
 *  电池页面电压电流折线图View
 *
 */

#import <UIKit/UIKit.h>

@interface TUBatteryVIView : UIView

+ (TUBatteryVIView *)showGraphView;

@property (weak, nonatomic) IBOutlet UILabel *voltageLabel;//电压显示
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;//电流显示

@property (assign, nonatomic) CGFloat averageCurrent;//平均电流

- (void)updeteDataWithVoltageArray:(NSMutableArray *)voltageArray currentArray:(NSMutableArray *)currentArray;

@end
