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

// 电池信息变化 通知
#define kBatteryStatusChange @"batteryStatusChange"
#define kBatteryLevelChange @"batteryLevelChange"
#define kBatteryInfoChange @"batteryInfoChange"

#define kSystemInfoChange @"systemInfoChange"


// 电池信息
@interface BatteryInfo : NSObject

@property (nonatomic, assign) CGFloat    capacity; // 电池容量
@property (nonatomic, assign) CGFloat    voltage; // 电压mV "Voltage = 4320"
@property (nonatomic, assign) CGFloat    amperage; // 电流mA "InstantAmperage = 137", 负数代表输出
@property (nonatomic, assign) CGFloat    levelPercent; // 电量百分数
@property (nonatomic, assign) CGFloat    levelMAH;
@property (nonatomic, copy)   NSString   *status; // 充电状态
@property (nonatomic, assign) CGFloat    temperature; // 电池温度 "Temperature = 2750"
@property (nonatomic, assign) CGFloat    cycleCount; // 电池循环次数 "CycleCount = 175"
@property (nonatomic, assign) NSTimeInterval updateTime; // "UpdateTime = 1458934114"

@end


@interface TUSystemInfoManager : NSObject

// 电池
@property (nonatomic, strong) BatteryInfo   *batteryInfo;

// 包含所有IOKit获取的信息(暂时无数据)
@property (nonatomic, strong) NSDictionary   *systemInfo;

/** 单例 */
+ (TUSystemInfoManager *)manager;

+ (void)refreshInfo;

@end


