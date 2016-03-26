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
        manager.properitys = [NSMutableArray new];
        manager.dumper = [ELLIOKitDumper new];

        [manager configNotification];
        [manager loadIOKit];
    });
    return manager;
}

+ (void)refreshInfo {
    [[self manager] loadIOKit];
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
        self.root = [_dumper dumpIOKitTree];
        self.locationInTree = _root;
        
        [self getCharge:_root];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [kTUNotificationCenter postNotificationName:kSystemInfoChange object:self.properitys];
        });

//        NSLog(@"%@-----/n%@", _properitys, _batteryInfoArray);
    });
}

// AppleARMPMUCharger
- (void)getCharge:(ELLIOKitNodeInfo *)node {
    
    if ([node.name isEqualToString:@"AppleARMPMUCharger"]) {
        [_batteryInfoArray addObjectsFromArray:node.properties];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"电池相关信息：%@", _batteryInfoArray);
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
        } else if ([obj rangeOfString:@"UpdateTime = "].location == 0) {
            NSRange range = [obj rangeOfString:@"UpdateTime = "];
            _batteryInfo.updateTime = [obj substringFromIndex:range.length].floatValue;
        } else if ([obj rangeOfString:@"InstantAmperage = "].location == 0) {
            NSRange range = [obj rangeOfString:@"InstantAmperage = "];
            _batteryInfo.amperage = [obj substringFromIndex:range.length].floatValue;
        }

    }];
    
    [kTUNotificationCenter postNotificationName:kBatteryInfoChange object:_batteryInfoArray];
}

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
