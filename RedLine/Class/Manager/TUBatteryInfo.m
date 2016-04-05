//
//  TUBatteryInfo.m
//  RedLine
//
//  Created by chengxianghe on 16/3/31.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryInfo.h"
#import "TUSystemInfoManager.h"

@interface BatteryLevel : NSObject

@property (nonatomic, assign) NSInteger        levelPercent;
@property (nonatomic, assign) NSInteger        updateTime;
@property (nonatomic, assign) NSInteger        capacity;

@end

@implementation BatteryLevel

- (NSString *)description {
    return [NSString stringWithFormat:@"levelPercent: %ld, updateTime:%ld, capacity:%ld", (long)self.levelPercent, (long)self.updateTime, (long)self.capacity];
}

@end


@interface TUBatteryInfo ()

@property (nonatomic, strong) NSMutableArray <__kindof BatteryLevel *> *nearBatteryCapacity;

@end

@implementation TUBatteryInfo

+ (instancetype)battery {
    static TUBatteryInfo *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.nearBatteryCapacity = [NSMutableArray new];
        [sharedInstance configNotification];
        [sharedInstance startBatteryMonitoring];
    });
    return sharedInstance;
}

- (void)configNotification {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBatteryInfo:)
                                                 name:kSystemBatteryInfoDidReadFinishedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryLevelUpdatedCB:)
                                                 name:UIDeviceBatteryLevelDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryStatusUpdatedCB:)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:nil];
}

- (void)startBatteryMonitoring {
    UIDevice *device = [UIDevice currentDevice];
    
    if (!device.batteryMonitoringEnabled) {
        [device setBatteryMonitoringEnabled:YES];
        
        // If by any chance battery value is available - update it immediately
        if ([device batteryState] != UIDeviceBatteryStateUnknown) {
            [self updateBatteryStatus];
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

- (void)updateBatteryInfo:(NSNotification *)note {
    
    if (![note.object isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSArray *batteryInfoArray = note.object;
    
    [batteryInfoArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj rangeOfString:@"Temperature = "].length) {
            NSRange range = [obj rangeOfString:@"Temperature = "];
            self.temperature = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"Voltage = "].location == 0) {
            NSRange range = [obj rangeOfString:@"Voltage = "];
            self.voltage = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"CycleCount = "].length) {
            NSRange range = [obj rangeOfString:@"CycleCount = "];
            self.cycleCount = [obj substringFromIndex:range.length].floatValue;
            self.remainLifeMonths = [TUSystemInfoManager getBatteryLifeWithCycleCount:self.cycleCount];
        } else if ([obj rangeOfString:@"UpdateTime = "].location == 0) {
            NSRange range = [obj rangeOfString:@"UpdateTime = "];
            self.updateTime = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"InstantAmperage = "].location == 0) {
            NSRange range = [obj rangeOfString:@"InstantAmperage = "];
            self.amperage = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"DesignCapacity = "].location == 0) {
            NSRange range = [obj rangeOfString:@"DesignCapacity = "];
            self.designCapacity = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"AppleRawMaxCapacity = "].location == 0) {
            NSRange range = [obj rangeOfString:@"AppleRawMaxCapacity = "];
            self.rawMaxCapacity = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"AppleRawCurrentCapacity ="].location == 0) {
            NSRange range = [obj rangeOfString:@"AppleRawCurrentCapacity ="];
            self.rawCurrentCapacity = [obj substringFromIndex:range.length].floatValue;
        }
        [self updateBatteryNearCapacity];

    }];
    
    [kTUNotificationCenter postNotificationName:kBatteryInfoDidChangeNotification object:batteryInfoArray];
    //    [self refreshBatteryInfo];
}

- (void)batteryLevelUpdatedCB:(NSNotification*)notification {
    [self updateBatteryStatus];
    [kTUNotificationCenter postNotificationName:kBatteryLevelDidChangeNotification object:self];
}

- (void)batteryStatusUpdatedCB:(NSNotification*)notification {
    [self updateBatteryStatus];
    [self.nearBatteryCapacity removeAllObjects];
    
    CGFloat fullTime = 0;
    CGFloat emptyTime = 0;
    if (_amperage) {
        fullTime = [TUSystemInfoManager timeToFullWithAverageAmperage:self.amperage maxCapacity:self.rawMaxCapacity currentCapacity:self.rawCurrentCapacity];
        emptyTime = [TUSystemInfoManager timeToEmptyWithAverageAmperage:self.amperage currentCapacity:self.rawCurrentCapacity temperature:self.temperature];
    }
        
    if (self.batteryState == UIDeviceBatteryStateFull) {
        [kTUNotificationCenter postNotificationName:kBatteryTimeToFullDidChangeNotification object:@(0)];
    } else if (self.batteryState == UIDeviceBatteryStateCharging) {
        [kTUNotificationCenter postNotificationName:kBatteryTimeToFullDidChangeNotification object:@(fullTime)];
    } else if (self.batteryState == UIDeviceBatteryStateUnplugged) {
        [kTUNotificationCenter postNotificationName:kBatteryTimeToEmptyDidChangeNotification object:@(emptyTime)];
    }
    
    [kTUNotificationCenter postNotificationName:kBatteryStatusDidChangeNotification object:self];
    [kTUNotificationCenter postNotificationName:kBatteryLevelDidChangeNotification object:self];
}

- (void)updateBatteryNearCapacity {
    
    self.timeToFull = [TUSystemInfoManager timeToFullWithAverageAmperage:self.amperage maxCapacity:self.rawMaxCapacity currentCapacity:self.rawCurrentCapacity];
    self.timeToEmpty = [TUSystemInfoManager timeToEmptyWithAverageAmperage:self.amperage currentCapacity:self.rawCurrentCapacity temperature:self.temperature];
    
    if (self.batteryState == UIDeviceBatteryStateFull) {
        self.timeToFull = 0;
        [kTUNotificationCenter postNotificationName:kBatteryTimeToFullDidChangeNotification object:@(self.timeToFull)];
    } else if (self.batteryState == UIDeviceBatteryStateCharging) {
        [kTUNotificationCenter postNotificationName:kBatteryTimeToFullDidChangeNotification object:@(self.timeToFull)];
    } else if (self.batteryState == UIDeviceBatteryStateUnplugged) {
        [kTUNotificationCenter postNotificationName:kBatteryTimeToEmptyDidChangeNotification object:@(self.timeToEmpty)];
    }

    return;
    
//    BatteryLevel *level = [[BatteryLevel alloc] init];
//    level.levelPercent = self.levelPercent;
//    level.capacity = self.rawCurrentCapacity;
//    level.updateTime = [[NSDate date] timeIntervalSince1970];
//    
//    if (self.batteryState == UIDeviceBatteryStateFull) {
//        self.timeToFull = 0;
//        if (level.capacity != [self.nearBatteryCapacity.lastObject capacity]) {
//            [self.nearBatteryCapacity addObject:level];
//        }
//        return;
//    }
//    
//    
//    if (level.capacity != [self.nearBatteryCapacity.lastObject capacity]) {
//        [self.nearBatteryCapacity addObject:level];
//    }
//    
//    if (self.nearBatteryCapacity.count > 3) {
//        [self.nearBatteryCapacity removeObjectsInRange:NSMakeRange(0, self.nearBatteryCapacity.count - 3)];
//    }
//    
//    if (self.nearBatteryCapacity.count >= 2) {
//        
//        BatteryLevel *preLevel = self.nearBatteryCapacity[0];
//        BatteryLevel *lastLevel = self.nearBatteryCapacity.lastObject;
//        
//        
//        CGFloat timeChange = lastLevel.updateTime - preLevel.updateTime;
//        CGFloat capacityChange = lastLevel.capacity - preLevel.capacity;
//        
//        if (capacityChange != 0) {
//            
//            CGFloat speed = capacityChange/timeChange;
//            
//            self.timeToFull = MAX(60, (self.rawMaxCapacity * 0.99 - self.rawCurrentCapacity)/ speed);
//            self.timeToEmpty = self.rawCurrentCapacity / speed;
//            
//            if (self.batteryState == UIDeviceBatteryStateCharging) {
//                [kTUNotificationCenter postNotificationName:kBatteryTimeToFullDidChangeNotification object:@(self.timeToFull)];
//            } else if (self.batteryState == UIDeviceBatteryStateUnplugged) {
//                [kTUNotificationCenter postNotificationName:kBatteryTimeToEmptyDidChangeNotification object:@(self.timeToEmpty)];
//            }
//            
//            NSString *string = [NSString stringWithFormat:@"speed:%f, timeChange:%f, capacityChange:%f ,self.timeToFull: %ld, empty: %ld \n%@", speed,timeChange,capacityChange,(long)self.timeToFull, (long)self.timeToEmpty, self.nearBatteryCapacity];
//            NSLog(@"%@", string);
//            
//        }
//    }
}

- (void)updateBatteryStatus {
    float batteryMultiplier = [[UIDevice currentDevice] batteryLevel];
    self.levelPercent = batteryMultiplier * 100;
    self.batteryState = [[UIDevice currentDevice] batteryState];
    
//    [self getTimeForBatteryToFullOrEmpty:self];
    
    
    switch ([[UIDevice currentDevice] batteryState]) {
        case UIDeviceBatteryStateCharging:
            // UIDeviceBatteryStateFull seems to be overwritten by UIDeviceBatteryStateCharging
            // when charging therefore it's more reliable if we check the battery level here
            // explicitly.
            
            if (self.levelPercent == 100) {
                self.status = kTULocalString(@"fullyCharged");
                self.batteryState = UIDeviceBatteryStateFull;
            } else {
                self.status = kTULocalString(@"charging");
            }
            break;
        case UIDeviceBatteryStateFull:
            self.status = kTULocalString(@"fullyCharged");
            break;
        case UIDeviceBatteryStateUnplugged:
            self.status = kTULocalString(@"unPlugged");
            break;
        case UIDeviceBatteryStateUnknown:
            self.status = kTULocalString(@"unKnown");
            break;
    }
}

@end

/*
 "IOFunctionParent8C000000 = <>",
 "TimeRemaining = 0",
 "AppleRawBrickIDVoltages = ((39,39))",
 "AppleRawCurrentCapacity = 2496",
 "NominalChargeCapacity = 2571",
 "AppleRawMaxCapacity = 2538",
 "ExternalChargeCapable = Yes",
 "BootVoltage = 4110",
 "IONameMatched = charger",
 "AppleRawExternalConnected = Yes",
 "Voltage = 4320",
 "AtWarnLevel = No",
 "AdapterInfo = 16384",
 "Model = 0003-F",
 "MaxCapacity = 2600",
 "UpdateTime = 1458934114",
 "Manufacturer = F",
 "built-in = Yes",
 "Location = 0",
 "CurrentCapacity = 2600",
 "IOPowerManagement = {DevicePowerState = 2,CapabilityFlags = 32832,CurrentPowerState = 2,MaxPowerState = 2}",
 "AppleRawAdapterDetails = ({Amperage = 2100,Description = usb host,FamilyCode = -536854528,AdapterVoltage = 5000,Watts = 10,PMUConfiguration = 2000})",
 "BatteryInstalled = Yes",
 "BootBBCapacity = 2100",
 "CycleCount = 175",
 "ChargerConfiguration = 0",
 "DesignCapacity = 2855",
 "AbsoluteCapacity = 2646",
 "ChargerData = {ChargingCurrent = 0,NotChargingReason = 8,ChargerAlert = 0,ChargerStatus = 162,ChargingVoltage = 132,UpdateTime = 1458934114}",
 "AtCriticalLevel = No",
 "BestAdapterIndex = 0",
 "CFBundleIdentifier = com.apple.driver.AppleARMPlatform",
 "Temperature = 2750",
 "BootCapacityEstimate = 88",
 "IOProviderClass = IOService",
 "BatteryKey = 0003-default",
 "AppleChargeRateLimitIndex = 0",
 "IONameMatch = charger",
 "InstantAmperage = 0",
 "IOClass = AppleARMPMUCharger",
 "FullyCharged = Yes",
 "IOGeneralInterest = IOCommand is not serializable",
 "PresentDOD = 288",
 "IOMatchCategory = IODefaultMatchCategory",
 "Amperage = 2100",
 "IOProbeScore = 1000",
 "IsCharging = No",
 "ExternalConnected = Yes",
 "AdapterDetails = {Amperage = 2100,Description = usb host,FamilyCode = -536854528,AdapterVoltage = 5000,Watts = 10,PMUConfiguration = 2000}"
 */


