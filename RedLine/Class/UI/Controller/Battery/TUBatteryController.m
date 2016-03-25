//
//  TUBatteryController.m
//  RedLine
//
//  Created by chengxianghe on 16/3/25.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryController.h"
#import "TUSystemInfoManager.h"
#import "NSDate+Category.h"

@interface TUBatteryController ()

@end

@implementation TUBatteryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [kTUNotificationCenter addObserver:self
                              selector:@selector(updateBatteryInfo)
                                  name:kBatteryInfoChange object:nil];
    
    CGFloat level = [TUSystemInfoManager manager].batteryInfo.levelPercent;
    NSUInteger levelMAH = [TUSystemInfoManager manager].batteryInfo.levelMAH;
    NSString *status = [TUSystemInfoManager manager].batteryInfo.status;

    NSLog(@"level:%f, status:%@, levelMAH:%lu", level, status, (unsigned long)levelMAH);
}

- (void)updateBatteryInfo {
    CGFloat voltage = [TUSystemInfoManager manager].batteryInfo.voltage/1000.0;
    NSUInteger count = [TUSystemInfoManager manager].batteryInfo.cycleCount;
    CGFloat temperature = [TUSystemInfoManager manager].batteryInfo.temperature/100.0;

    NSString *date = [[NSDate dateFromStringOrNumber:@([TUSystemInfoManager manager].batteryInfo.updateTime)] standardTimeIntervalDescription];
    
    NSLog(@"voltage:%f, count:%lu, temperature:%f, date:%@", voltage, count, temperature, date);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
