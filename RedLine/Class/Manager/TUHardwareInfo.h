//
//  TUHardwareInfo.h
//  RedLine
//
//  Created by chengxianghe on 16/3/31.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUHardwareInfo : NSObject

// System Hardware Information

// System Uptime (dd hh mm)
+ (NSString *)systemUptime;

// Model of Device （iPhone）
+ (NSString *)deviceModel;

// Device Name (xxx的 iPhone)
+ (NSString *)deviceName;

// System Name (iPhone OS)
+ (NSString *)systemName;

// System Version (9.3)
+ (NSString *)systemVersion;

// System Device Type (iPhone1,0)
+ (NSString *)systemDeviceType;

// Get the Screen Brightness
+ (float)screenBrightness;

// Multitasking enabled?
+ (BOOL)multitaskingEnabled;

// Proximity sensor enabled?
+ (BOOL)proximitySensorEnabled;

// Plugged In?
+ (BOOL)pluggedIn;

@end
