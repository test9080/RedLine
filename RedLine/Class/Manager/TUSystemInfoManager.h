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


// 电池信息
@interface BatteryInfo : NSObject

@property (nonatomic, assign) NSUInteger    capacity;
@property (nonatomic, assign) CGFloat       voltage;
@property (nonatomic, assign) NSUInteger    levelPercent;
@property (nonatomic, assign) NSUInteger    levelMAH;
@property (nonatomic, copy)   NSString      *status;

@end


@interface TUSystemInfoManager : NSObject

// 电池
@property (nonatomic, strong) BatteryInfo   *batteryInfo;

/** 单例 */
+ (TUSystemInfoManager *)manager;

@end


