//
//  TUSystemInfoManager.m
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUSystemInfoManager.h"

@implementation BatteryInfo
@end


@interface TUSystemInfoManager ()

@end

@implementation TUSystemInfoManager

+ (TUSystemInfoManager *)manager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager configNotification];
    });
    return manager;
}

- (void)configNotification {
    [self startBatteryMonitoring];
    
}

- (BatteryInfo *)batteryInfo {
    if (_batteryInfo == nil) {
        _batteryInfo = [[BatteryInfo alloc] init];
        // 此处可写默认参数
    }
    return _batteryInfo;
}



- (void)startBatteryMonitoring
{
    UIDevice *device = [UIDevice currentDevice];

    if (!device.batteryMonitoringEnabled) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(batteryLevelUpdatedCB:)
                                                     name:UIDeviceBatteryLevelDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(batteryStatusUpdatedCB:)
                                                     name:UIDeviceBatteryStateDidChangeNotification
                                                   object:nil];
        
        [device setBatteryMonitoringEnabled:YES];
        
        // If by any chance battery value is available - update it immediately
        if ([device batteryState] != UIDeviceBatteryStateUnknown) {
            [self doUpdateBatteryStatus];
        }
    }
}

- (void)stopBatteryMonitoring {
    if ([UIDevice currentDevice].batteryMonitoringEnabled) {
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - private

//- (NSUInteger)getBatteryCapacity
//{
//    HardcodedDeviceData *hardcode = [HardcodedDeviceData sharedDeviceData];
//    return [hardcode getBatteryCapacity];
//}
//
//- (CGFloat)getBatteryVoltage
//{
//    HardcodedDeviceData *hardcode = [HardcodedDeviceData sharedDeviceData];
//    return [hardcode getBatteryVoltage];
//}

- (void)batteryLevelUpdatedCB:(NSNotification*)notification {
    [self doUpdateBatteryStatus];
    [kTUNotificationCenter postNotificationName:kBatteryLevelChange object:self.batteryInfo];
}

- (void)batteryStatusUpdatedCB:(NSNotification*)notification {
    [self doUpdateBatteryStatus];
}

- (void)doUpdateBatteryStatus {
    float batteryMultiplier = [[UIDevice currentDevice] batteryLevel];
    self.batteryInfo.levelPercent = batteryMultiplier * 100;
    self.batteryInfo.levelMAH =  self.batteryInfo.capacity * batteryMultiplier;
    
    switch ([[UIDevice currentDevice] batteryState]) {
        case UIDeviceBatteryStateCharging:
            // UIDeviceBatteryStateFull seems to be overwritten by UIDeviceBatteryStateCharging
            // when charging therefore it's more reliable if we check the battery level here
            // explicitly.
            if (self.batteryInfo.levelPercent == 100)
            {
                self.batteryInfo.status = @"Fully charged";
            }
            else
            {
                self.batteryInfo.status = @"Charging";
            }
            break;
        case UIDeviceBatteryStateFull:
            self.batteryInfo.status = @"Fully charged";
            break;
        case UIDeviceBatteryStateUnplugged:
            self.batteryInfo.status = @"Unplugged";
            break;
        case UIDeviceBatteryStateUnknown:
            self.batteryInfo.status = @"Unknown";
            break;
    }
}


@end
