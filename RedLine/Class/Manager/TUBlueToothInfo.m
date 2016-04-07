//
//  TUBlueToothInfo.m
//  RedLine
//
//  Created by chengxianghe on 16/4/5.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBlueToothInfo.h"

#define kTUBlueToothDidUpdateStateNotification @"TUBlueToothDidUpdateStateNotification"

@interface TUBlueToothInfo () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *manager;

@end

@implementation TUBlueToothInfo

+ (TUBlueToothInfo *)sharedInstance {
    static TUBlueToothInfo *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.manager = [[CBCentralManager alloc] initWithDelegate:sharedInstance queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@NO}];
    });
    return sharedInstance;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    /*
     CBCentralManagerStateUnknown = 0,
     CBCentralManagerStateResetting,
     CBCentralManagerStateUnsupported,
     CBCentralManagerStateUnauthorized,
     CBCentralManagerStatePoweredOff,
     CBCentralManagerStatePoweredOn,
     */
    NSLog(@"%ld", (long)central.state);
    
    if (_manager.state == CBCentralManagerStateUnsupported) {//设备不支持蓝牙
        NSLog(@"设备不支持蓝牙");
    }else {//设备支持蓝牙连接
        if (_manager.state == CBCentralManagerStatePoweredOn) {//蓝牙开启状态
            NSLog(@"蓝牙已经开启");
        } else if (_manager.state == CBCentralManagerStatePoweredOff) {
            NSLog(@"蓝牙已经关闭");
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTUBlueToothDidUpdateStateNotification object:_manager];
}

+ (void)addNotificationWithTarget:(id)target selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:kTUBlueToothDidUpdateStateNotification object:nil];
}

+ (void)removeNotificationWithTarget:(id)target {
    [[NSNotificationCenter defaultCenter] removeObserver:target name:kTUBlueToothDidUpdateStateNotification object:nil];
}

@end
