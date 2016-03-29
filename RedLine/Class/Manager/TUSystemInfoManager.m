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

@implementation BatteryInfo
@end

@interface TUSystemInfoManager ()

@property(nonatomic, strong) ELLIOKitNodeInfo *root;
@property(nonatomic, strong) ELLIOKitNodeInfo *locationInTree;
@property(nonatomic, strong) NSMutableArray *batteryInfoArray;
@property(nonatomic, strong) NSMutableArray *properitys;
@property(nonatomic, strong) ELLIOKitDumper *dumper;

@end

@implementation TUSystemInfoManager

+ (TUSystemInfoManager *)manager {
    static TUSystemInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.batteryInfoArray = [NSMutableArray new];
        //        manager.properitys = [NSMutableArray new];
        manager.dumper = [ELLIOKitDumper new];
        
        [manager configNotification];
        
        //        [manager refreshBatteryInfo];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:manager selector:@selector(refreshBatteryInfo) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    });
    return manager;
}

+ (void)refreshInfo {
    [[self manager] loadIOKit];
}

- (void)refreshBatteryInfo {
    
    [self.batteryInfoArray removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.locationInTree = [_dumper dumpIOKitTree];
        
        [self getCharge:self.locationInTree];
    });
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



- (void)startBatteryMonitoring {
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

- (void)loadIOKit {
    [self.properitys removeAllObjects];
    [self.batteryInfoArray removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.locationInTree = [_dumper dumpIOKitTree];
        
        [self getCharge:self.locationInTree];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [kTUNotificationCenter postNotificationName:kSystemInfoDidChangeNotification object:self.properitys];
        });
    });
}

// AppleARMPMUCharger
- (void)getCharge:(ELLIOKitNodeInfo *)node {
    
    if ([node.name isEqualToString:@"AppleARMPMUCharger"]) {
        [_batteryInfoArray addObjectsFromArray:node.properties];
        dispatch_async(dispatch_get_main_queue(), ^{
            //            NSLog(@"电池相关信息：%@", _batteryInfoArray);
            [self updateBatteryInfo];
        });
    }
    
    if (node.properties.count) {
        [self.properitys addObjectsFromArray:node.properties];
    }
    
    for (int i = 0; i < node.children.count; i ++) {
        ELLIOKitNodeInfo *info = node.children[i];
        [self getCharge:info];
    }
}

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


#pragma mark - private

- (void)updateBatteryInfo {
    
    //    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [_batteryInfoArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj rangeOfString:@"Temperature = "].length) {
            NSRange range = [obj rangeOfString:@"Temperature = "];
            _batteryInfo.temperature = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"Voltage = "].location == 0) {
            NSRange range = [obj rangeOfString:@"Voltage = "];
            _batteryInfo.voltage = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"CycleCount = "].length) {
            NSRange range = [obj rangeOfString:@"CycleCount = "];
            _batteryInfo.cycleCount = [obj substringFromIndex:range.length].floatValue;
            _batteryInfo.remainLifeMonths = [self.class getBatteryLifeWithCycleCount:_batteryInfo.cycleCount];
        } else if ([obj rangeOfString:@"UpdateTime = "].location == 0) {
            NSRange range = [obj rangeOfString:@"UpdateTime = "];
            _batteryInfo.updateTime = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"InstantAmperage = "].location == 0) {
            NSRange range = [obj rangeOfString:@"InstantAmperage = "];
            _batteryInfo.amperage = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"DesignCapacity = "].location == 0) {
            NSRange range = [obj rangeOfString:@"DesignCapacity = "];
            _batteryInfo.designCapacity = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"AppleRawMaxCapacity = "].location == 0) {
            NSRange range = [obj rangeOfString:@"AppleRawMaxCapacity = "];
            _batteryInfo.rawMaxCapacity = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"AppleRawCurrentCapacity ="].location == 0) {
            NSRange range = [obj rangeOfString:@"AppleRawCurrentCapacity ="];
            _batteryInfo.rawCurrentCapacity = [obj substringFromIndex:range.length].floatValue;
        }
        
    }];
    
    [kTUNotificationCenter postNotificationName:kBatteryInfoDidChangeNotification object:_batteryInfoArray];
    //    [self refreshBatteryInfo];
}

- (void)batteryLevelUpdatedCB:(NSNotification*)notification {
    [self doUpdateBatteryStatus];
    [kTUNotificationCenter postNotificationName:kBatteryLevelDidChangeNotification object:self.batteryInfo];
}

- (void)batteryStatusUpdatedCB:(NSNotification*)notification {
    [self doUpdateBatteryStatus];
}

- (void)doUpdateBatteryStatus {
    float batteryMultiplier = [[UIDevice currentDevice] batteryLevel];
    self.batteryInfo.levelPercent = batteryMultiplier * 100;
    self.batteryInfo.levelMAH =  self.batteryInfo.rawMaxCapacity * batteryMultiplier;
    
    switch ([[UIDevice currentDevice] batteryState]) {
        case UIDeviceBatteryStateCharging:
            // UIDeviceBatteryStateFull seems to be overwritten by UIDeviceBatteryStateCharging
            // when charging therefore it's more reliable if we check the battery level here
            // explicitly.

            if (self.batteryInfo.levelPercent == 100) {
                self.batteryInfo.status = kTULocalString(@"fullyCharged");
            } else {
                self.batteryInfo.status = kTULocalString(@"charging");
            }
            break;
        case UIDeviceBatteryStateFull:
            self.batteryInfo.status = kTULocalString(@"fullyCharged");
            break;
        case UIDeviceBatteryStateUnplugged:
            self.batteryInfo.status = kTULocalString(@"unPlugged");
            break;
        case UIDeviceBatteryStateUnknown:
            self.batteryInfo.status = kTULocalString(@"unKnown");
            break;
    }
}

/** 获取电池剩余寿命 （剩余多少个月） */
+ (NSInteger)getBatteryLifeWithCycleCount:(NSInteger)cycleCount {
    CGFloat months = cycleCount / 1500.0 * 60;
    // 四舍五入 至少剩余寿命1个月
    NSInteger life = 60 - ceilf(months);
    NSLog(@"life:%lu", life);
    return MAX(1, life);
}


@end
