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
#define kBatteryStatusDidChangeNotification             @"batteryStatusChange"
#define kBatteryLevelDidChangeNotification              @"batteryLevelChange"
#define kBatteryInfoDidChangeNotification               @"batteryInfoChange"
#define kBatteryTimeToEmptyOrFullDidChangeNotification  @"batteryInfoChange"

#define kSystemInfoDidChangeNotification                @"systemInfoChange"



// 电池信息
@interface BatteryInfo : NSObject

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
@property (nonatomic,   copy) NSString  *status; // 充电状态
@property (nonatomic, assign) UIDeviceBatteryState  batteryState; // 充电状态

// 需要监听 kBatteryTimeToEmptyOrFullDidChangeNotification 取值
@property (nonatomic, assign) NSInteger timeToEmpty; // 用完所需时间（需要电池百分比变化 才有值）
@property (nonatomic, assign) NSInteger timeToFull; // 充满所需时间（需要电池百分比变化 才有值）

@end


@interface TUSystemInfoManager : NSObject

@property (nonatomic, strong) BatteryInfo   *batteryInfo; // 电池信息
@property (nonatomic, strong) NSDictionary   *systemInfo; // 包含所有IOKit获取的信息(暂时无数据)

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
 *  @param currentCapacity  电池最大容量(mAh)
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


