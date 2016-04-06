//
//  TUBlueToothInfo.h
//  RedLine
//
//  Created by chengxianghe on 16/4/5.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface TUBlueToothInfo : NSObject

/**
 *  监听蓝牙状态
 *  object 是 CBCentralManager
 */
+ (void)addNotificationWithTarget:(nonnull id)target selector:(nonnull SEL)selector;

/**
 *  取消监听蓝牙状态
 */
+ (void)removeNotificationWithTarget:(nonnull id)target;

@end
