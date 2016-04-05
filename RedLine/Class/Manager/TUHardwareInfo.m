//
//  TUHardwareInfo.m
//  RedLine
//
//  Created by chengxianghe on 16/3/31.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUHardwareInfo.h"
#import <sys/utsname.h>

@implementation TUHardwareInfo

// System Uptime (dd hh mm)
+ (NSString *)systemUptime {
    // Set up the days/hours/minutes
    NSNumber *Days, *Hours, *Minutes;
    
    // Get the info about a process
    NSProcessInfo * processInfo = [NSProcessInfo processInfo];
    // Get the uptime of the system
    NSTimeInterval UptimeInterval = [processInfo systemUptime];
    // Get the calendar
    NSCalendar *Calendar = [NSCalendar currentCalendar];
    // Create the Dates
    NSDate *Date = [[NSDate alloc] initWithTimeIntervalSinceNow:(0-UptimeInterval)];
    unsigned int unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *Components = [Calendar components:unitFlags fromDate:Date toDate:[NSDate date]  options:0];
    
    // Get the day, hour and minutes
    Days = [NSNumber numberWithInteger:[Components day]];
    Hours = [NSNumber numberWithInteger:[Components hour]];
    Minutes = [NSNumber numberWithInteger:[Components minute]];
    
    // Format the dates
    NSString *Uptime = [NSString stringWithFormat:@"%@ %@ %@",
                        [Days stringValue],
                        [Hours stringValue],
                        [Minutes stringValue]];
    
    // Error checking
    if (!Uptime) {
        // No uptime found
        // Return nil
        return nil;
    }
    
    // Return the uptime
    return Uptime;
}

// Model of Device
+ (NSString *)deviceModel {
    // Get the device model
    if ([[UIDevice currentDevice] respondsToSelector:@selector(model)]) {
        // Make a string for the device model
        NSString *deviceModel = [[UIDevice currentDevice] model];
        // Set the output to the device model
        return deviceModel;
    } else {
        // Device model not found
        return nil;
    }
}

// Device Name
+ (NSString *)deviceName {
    // Get the current device name
    if ([[UIDevice currentDevice] respondsToSelector:@selector(name)]) {
        // Make a string for the device name
        NSString *deviceName = [[UIDevice currentDevice] name];
        // Set the output to the device name
        return deviceName;
    } else {
        // Device name not found
        return nil;
    }
}

// System Name
+ (NSString *)systemName {
    // Get the current system name
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemName)]) {
        // Make a string for the system name
        NSString *systemName = [[UIDevice currentDevice] systemName];
        // Set the output to the system name
        return systemName;
    } else {
        // System name not found
        return nil;
    }
}

// System Version
+ (NSString *)systemVersion {
    // Get the current system version
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemVersion)]) {
        // Make a string for the system version
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        // Set the output to the system version
        return systemVersion;
    } else {
        // System version not found
        return nil;
    }
}

// System Device Type (iPhone1,0)
+ (NSString *)systemDeviceType {
    // Set up a Device Type String
    NSString *DeviceType;
    // Unformatted
    @try {
        // Set up a struct
        struct utsname DT;
        // Get the system information
        uname(&DT);
        // Set the device type to the machine type
        DeviceType = [NSString stringWithFormat:@"%s", DT.machine];
        
        // Return the device type
        return DeviceType;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

// Get the Screen Brightness
+ (float)screenBrightness {
    // Get the screen brightness
    @try {
        // Brightness
        float brightness = [UIScreen mainScreen].brightness;
        // Verify validity
        if (brightness < 0.0 || brightness > 1.0) {
            // Invalid brightness
            return -1;
        }
        
        // Successful
        return (brightness * 100);
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

// Multitasking enabled?
+ (BOOL)multitaskingEnabled {
    // Is multitasking enabled?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) {
        // Create a bool
        BOOL MultitaskingSupported = [UIDevice currentDevice].multitaskingSupported;
        // Return the value
        return MultitaskingSupported;
    } else {
        // Doesn't respond to selector
        return false;
    }
}

// Proximity sensor enabled?
+ (BOOL)proximitySensorEnabled {
    // Is the proximity sensor enabled?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setProximityMonitoringEnabled:)]) {
        // Create a UIDevice variable
        UIDevice *device = [UIDevice currentDevice];
        
        // Make a Bool for the proximity Sensor
        BOOL ProximitySensor;
        
        // Turn the sensor on, if not already on, and see if it works
        if (device.proximityMonitoringEnabled != YES) {
            // Sensor is off
            // Turn it on
            [device setProximityMonitoringEnabled:YES];
            // See if it turned on
            if (device.proximityMonitoringEnabled == YES) {
                // It turned on!  Turn it off
                [device setProximityMonitoringEnabled:NO];
                // It works
                ProximitySensor = true;
            } else {
                // Didn't turn on, no good
                ProximitySensor = false;
            }
        } else {
            // Sensor is already on
            ProximitySensor = true;
        }
        
        // Return on or off
        return ProximitySensor;
    } else {
        // Doesn't respond to selector
        return false;
    }
}

// Plugged In?
+ (BOOL)pluggedIn {
    // Is the device plugged in?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(batteryState)]) {
        // Create a bool
        BOOL PluggedIn;
        // Set the battery monitoring enabled
        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
        // Get the battery state
        UIDeviceBatteryState batteryState = [UIDevice currentDevice].batteryState;
        // Check if it's plugged in or finished charging
        if (batteryState == UIDeviceBatteryStateCharging || batteryState == UIDeviceBatteryStateFull) {
            // We're plugged in
            PluggedIn = true;
        } else {
            PluggedIn = false;
        }
        // Return the value
        return PluggedIn;
    } else {
        // Doesn't respond to selector
        return false;
    }
}


@end
