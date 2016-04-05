//
//  TUConstDeviceData.h
//  RedLine
//
//  Created by chengxianghe on 16/3/31.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUConstDeviceInfo : NSObject
+ (TUConstDeviceInfo *)sharedDevice;

- (NSString *)getiDeviceName;
- (const NSString *)getCPUName;
- (NSUInteger)getCPUFrequency;
- (const NSString *)getCoprocessorName;
- (const NSString *)getGraphicCardName;
- (const NSString *)getRAMType;
- (NSUInteger)getBatteryCapacity;
- (CGFloat)getBatteryVoltage;
- (CGFloat)getScreenSize;
- (NSUInteger)getPPI;
- (NSString *)getAspectRatio;
- (BOOL)isOldDevice;
@end
