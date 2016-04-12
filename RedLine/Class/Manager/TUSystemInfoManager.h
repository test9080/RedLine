//
//  TUSystemInfoManager.h
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

/**
 *  获取系统信息
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TUBatteryInfo.h"

#define kSystemInfoDidReadFinishedNotification          @"systemInfoDidReadFinished"
#define kSystemBatteryInfoDidReadFinishedNotification   @"systemBatteryInfoDidReadFinished"

@interface TUSystemInfoManager : NSObject

@property (nonatomic, weak) TUBatteryInfo   *batteryInfo; // 电池信息
//@property (nonatomic, strong) NSDictionary   *systemInfo; // 包含所有IOKit获取的信息(暂时无数据)

+ (TUSystemInfoManager *)manager;

@end

@interface TUSystemInfoManager (Help)

/**
 *  计算电池充满所需时间
 *
 *  @param amperage        平均电流(mA)
 *  @param maxCapacity     电池最大容量(mAh)
 *  @param currentCapacity 电池当前容量(mAh)
 *
 *  @return 充满所需时间(h)
 */
+ (CGFloat)timeToFullWithAverageAmperage:(CGFloat)amperage maxCapacity:(CGFloat)maxCapacity currentCapacity:(CGFloat)currentCapacity;

/**
 *  计算电池剩余可用时间
 *
 *  @param amperage         平均电流(mA)
 *  @param currentCapacity  电池当前容量(mAh)
 *  @param temperature      电池温度(℃)
 *
 *  @return 电池可用时间(h)
 */
+ (CGFloat)timeToEmptyWithAverageAmperage:(CGFloat)amperage currentCapacity:(CGFloat)currentCapacity temperature:(CGFloat)temperature;

/**
 *  计算电池剩余寿命
 *
 *  @param cycleCount 电池已用循环次数
 *
 *  @return 剩余寿命（单位：月）
 */
+ (NSInteger)getBatteryLifeWithCycleCount:(NSInteger)cycleCount;

@end


