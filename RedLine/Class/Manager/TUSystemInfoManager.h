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
#define kBatteryStatusDidChangeNotification    @"batteryStatusChange"
#define kBatteryLevelDidChangeNotification     @"batteryLevelChange"
#define kBatteryInfoDidChangeNotification      @"batteryInfoChange"
#define kSystemInfoDidChangeNotification       @"systemInfoChange"


// 电池信息
@interface BatteryInfo : NSObject

//@property (nonatomic, assign) NSInteger     capacity; // 电池容量 标称 6p 1915
@property (nonatomic, assign) NSInteger     voltage; // 电压mV "Voltage = 4320"
@property (nonatomic, assign) NSInteger     amperage; // 电流mA "InstantAmperage = 137", 负数代表输出
@property (nonatomic, assign) CGFloat       levelPercent; // 电量百分数
@property (nonatomic, assign) CGFloat       levelMAH; // 剩余
@property (nonatomic, assign) NSInteger     temperature; // 电池温度 "Temperature = 2750"
@property (nonatomic, assign) NSInteger     cycleCount; // 电池循环次数 "CycleCount = 175"
@property (nonatomic, assign) NSInteger     rawMaxCapacity; // 电池实际最大容量 "AppleRawMaxCapacity = 2569"
@property (nonatomic, assign) NSInteger     designCapacity; // 电池设计最大容量 "DesignCapacity = 2855"
@property (nonatomic, assign) NSInteger     rawCurrentCapacity; // 电池当前容量 "AppleRawCurrentCapacity = 1576"
@property (nonatomic,   copy) NSString      *status; // 充电状态
@property (nonatomic, assign) NSTimeInterval updateTime; // "UpdateTime = 1458934114"

@end


@interface TUSystemInfoManager : NSObject

// 电池
@property (nonatomic, strong) BatteryInfo   *batteryInfo;

// 包含所有IOKit获取的信息(暂时无数据)
@property (nonatomic, strong) NSDictionary   *systemInfo;

/** 单例 */
+ (TUSystemInfoManager *)manager;

/** 刷新数据 */
+ (void)refreshInfo;

@end


