//
//  TUBatteryInfo.h
//  RedLine
//
//  Created by chengxianghe on 16/3/31.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

// 电池信息变化 通知
#define kBatteryStatusDidChangeNotification             @"batteryStatusDidChange"
#define kBatteryLevelDidChangeNotification              @"batteryLevelDidChange"
#define kBatteryInfoDidChangeNotification               @"batteryInfoDidChange"

// 实时耗电更新
#define kBatteryTimeToEmptyDidChangeNotification        @"batteryTimeToEmpty"
#define kBatteryTimeToFullDidChangeNotification         @"batteryTimeToFull"

// 电池信息
@interface TUBatteryInfo : NSObject

//@property (nonatomic, assign) NSInteger capacity; // 电池容量 标称 6p 1915
@property (nonatomic, assign) NSInteger voltage; // 电压mV "Voltage = 4320"
@property (nonatomic, assign) NSInteger amperage; // 电流mA "InstantAmperage = 137", 负数代表输出
@property (nonatomic, assign) NSInteger levelPercent; // 电量百分数
@property (nonatomic, assign) NSInteger temperature; // 电池温度 "Temperature = 2750"
@property (nonatomic, assign) NSInteger cycleCount; // 电池循环次数 "CycleCount = 175"
@property (nonatomic, assign) NSInteger rawMaxCapacity; // 电池实际最大容量 "AppleRawMaxCapacity = 2569"
@property (nonatomic, assign) NSInteger designCapacity; // 电池设计最大容量 "DesignCapacity = 2855"
@property (nonatomic, assign) NSInteger rawCurrentCapacity; // 电池当前容量 "AppleRawCurrentCapacity = 1576"
@property (nonatomic, assign) NSInteger updateTime; // 更新时间 "UpdateTime = 1458934114"

// 计算数值
@property (nonatomic, assign) NSInteger remainLifeMonths; // 剩余寿命（月）
@property (nonatomic, assign) UIDeviceBatteryState  batteryState; // 充电状态
@property (nonatomic,   copy) NSString  *status; // 充电状态描述

// 需要监听 kBatteryTimeToEmptyOrFullDidChangeNotification 取值
@property (nonatomic, assign) NSInteger timeToEmpty; // 用完所需时间（需要电池百分比变化 才有值）
@property (nonatomic, assign) NSInteger timeToFull; // 充满所需时间（需要电池百分比变化 才有值）

+ (instancetype)battery;

@end
