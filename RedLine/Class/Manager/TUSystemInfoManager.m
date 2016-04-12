//
//  TUSystemInfoManager.m
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUSystemInfoManager.h"
#import "ELLIOKitNodeInfo.h"
#import "ELLIOKitDumper.h"
#import "TUHardwareInfo.h"
#import "TUConstDeviceInfo.h"

@interface TUSystemInfoManager ()

//@property (nonatomic, strong) ELLIOKitNodeInfo *root;
@property (nonatomic, strong) ELLIOKitDumper *dumper;

@property (nonatomic, strong) NSMutableArray *InfoArray;

@end

@implementation TUSystemInfoManager

+ (TUSystemInfoManager *)manager {
    static TUSystemInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];

        manager.InfoArray = [NSMutableArray array];
        manager.batteryInfo = [TUBatteryInfo battery];

        manager.dumper = [ELLIOKitDumper new];

        BOOL isOldDevice = [[TUConstDeviceInfo sharedDevice] isOldDevice];
        
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(chargeRefreshBatteryInfoNotification:) name:kELLIOKitDumperDidReadBatteryNotification object:nil];
        
        [manager refreshBatteryInfo];
        if (!isOldDevice) {
            [manager performSelector:@selector(refreshBatteryInfo) withObject:nil afterDelay:1];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:manager selector:@selector(refreshBatteryInfo) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }

    });
    return manager;
}

- (void)refreshBatteryInfo {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dumper dumpIOKitTree];
    });
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self getChargeRefreshBattery:[self.dumper dumpIOKitTree]];
//    });
}

#pragma mark - private

- (void)chargeRefreshBatteryInfoNotification:(NSNotification *)note {
    
    
    ELLIOKitNodeInfo *node = note.object;
    
    if ([node isKindOfClass:[ELLIOKitNodeInfo class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //  NSLog(@"电池相关信息：%@", _batteryInfoArray);
                [kTUNotificationCenter postNotificationName:kSystemBatteryInfoDidReadFinishedNotification object:node.properties];
                if ([[TUConstDeviceInfo sharedDevice] isOldDevice]) {
                    [self refreshBatteryInfo];
                }
            });
    }
    
}


//- (void)loadIOKit {
//    [self.InfoArray removeAllObjects];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self getCharge:[self.dumper dumpIOKitTree]];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [kTUNotificationCenter postNotificationName:kSystemInfoDidReadFinishedNotification object:self.InfoArray];
//        });
//    });
//}

//// AppleARMPMUCharger-charger
//- (void)getChargeRefreshBattery:(ELLIOKitNodeInfo *)node {
//    
//    // iPhone4 - AppleD1815PMUPowerSource
//    if ([node.name isEqualToString:@"AppleD1815PMUPowerSource"] || [node.name isEqualToString:@"AppleARMPMUCharger"]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //  NSLog(@"电池相关信息：%@", _batteryInfoArray);
//            [kTUNotificationCenter postNotificationName:kSystemBatteryInfoDidReadFinishedNotification object:node.properties];
//            if ([[TUConstDeviceInfo sharedDevice] isOldDevice]) {
//                [self refreshBatteryInfo];
//            }
//        });
//        return;
//    }
//
//    for (int i = 0; i < node.children.count; i ++) {
//        ELLIOKitNodeInfo *info = node.children[i];
//        [self getChargeRefreshBattery:info];
//    }
//}

- (void)getCharge:(ELLIOKitNodeInfo *)node {
    if (node.properties.count) {
        [_InfoArray addObjectsFromArray:node.properties];
    }
    
    for (int i = 0; i < node.children.count; i ++) {
        ELLIOKitNodeInfo *info = node.children[i];
        [self getCharge:info];
    }
}

@end


@implementation TUSystemInfoManager (Help)

/** 获取电池剩余寿命 （剩余多少个月） */
+ (NSInteger)getBatteryLifeWithCycleCount:(NSInteger)cycleCount {
    CGFloat months = cycleCount / 1500.0 * 60;
    // 四舍五入 至少剩余寿命1个月
    NSInteger life = 60 - ceilf(months);
    NSLog(@"life:%lu", (long)life);
    return MAX(1, life);
}

+ (CGFloat)timeToFullWithAverageAmperage:(CGFloat)amperage maxCapacity:(CGFloat)maxCapacity currentCapacity:(CGFloat)currentCapacity {
    UIDeviceBatteryState state = [TUSystemInfoManager manager].batteryInfo.batteryState;
    if (state == UIDeviceBatteryStateFull || amperage == 0) {
        return 0;
    }
    //    CGFloat time = (maxCapacity - currentCapacity) / fabs(amperage) * 1.5;

//    CGFloat factor = 4.5;
//    CGFloat radio = currentCapacity / maxCapacity;
//    if (radio > 90) {
//        factor = 10;
//    }
    // 1mAh 需要5s
    CGFloat time = (maxCapacity - currentCapacity) * 4.5;

    return time;
}

+ (CGFloat)timeToEmptyWithAverageAmperage:(CGFloat)amperage currentCapacity:(CGFloat)currentCapacity temperature:(CGFloat)temperature {
    CGFloat factor = 1.0;
    if (temperature > 35) {
        factor = 1.2;
    } else if (temperature < 20) {
        factor = 1.2;
    }
//    CGFloat time = currentCapacity / amperage / factor;
    CGFloat time = currentCapacity * 18 / factor;

    return time;
}

@end
