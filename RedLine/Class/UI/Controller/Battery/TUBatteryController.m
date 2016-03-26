//
//  TUBatteryController.m
//  RedLine
//
//  Created by chengxianghe on 16/3/25.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryController.h"

#import "TUBatteryHeaderView.h"

#import "TUSystemInfoManager.h"

#import "NSDate+Category.h"
#import "UIColor+GGColor.h"

@interface TUBatteryController ()
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@end

@implementation TUBatteryController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self UIConfig];
    
    [kTUNotificationCenter addObserver:self
                              selector:@selector(updateBatteryInfo:)
                                  name:kBatteryInfoChange object:nil];
    [kTUNotificationCenter addObserver:self
                              selector:@selector(updateSystemInfo:)
                                  name:kSystemInfoChange object:nil];

    
    CGFloat level = [TUSystemInfoManager manager].batteryInfo.levelPercent;
    NSUInteger levelMAH = [TUSystemInfoManager manager].batteryInfo.levelMAH;
    NSString *status = [TUSystemInfoManager manager].batteryInfo.status;

    NSLog(@"level:%f, status:%@, levelMAH:%lu", level, status, (unsigned long)levelMAH);
}

- (void)UIConfig {
    self.bgScrollView.backgroundColor = [UIColor colorWithARGB:0xff1c2135];
    
    TUBatteryHeaderView *headerView = [[TUBatteryHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    [self.bgScrollView addSubview:headerView];
}

- (void)updateBatteryInfo:(NSNotification *)note {
    CGFloat voltage = [TUSystemInfoManager manager].batteryInfo.voltage/1000.0;
    CGFloat amperage = [TUSystemInfoManager manager].batteryInfo.amperage;
    CGFloat count = [TUSystemInfoManager manager].batteryInfo.cycleCount;
    CGFloat temperature = [TUSystemInfoManager manager].batteryInfo.temperature/100.0;

    NSString *date = [[NSDate dateFromStringOrNumber:@([TUSystemInfoManager manager].batteryInfo.updateTime)] standardTimeIntervalDescription];
    
    NSString *string = [NSString stringWithFormat:@"voltage:%f,\n amperage:%f,\n count:%f,\n temperature:%f,\n date:%@", voltage, amperage, count, temperature, date];
    NSLog(@"%@", string);
//    [[[UIAlertView alloc] initWithTitle:@"SystemInfo" message:[note.object componentsJoinedByString:@"\n"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
    [[[UIAlertView alloc] initWithTitle:@"BatteryInfo" message:string delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];

}

- (void)updateSystemInfo:(NSNotification *)note {
    
    NSArray *array = note.object;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [TUSystemInfoManager refreshInfo];
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
