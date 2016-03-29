//
//  TUBatteryController.m
//  RedLine
//
//  Created by chengxianghe on 16/3/25.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryController.h"

#import "TUBatteryHeaderView.h"
#import "TUBatteryTipsView.h"
#import "TUBatteryCapacityView.h"
#import "TUBatteryProgressView.h"
#import "TUBatteryVIView.h"
#import "TUBatteryBottomView.h"

#import "TUSystemInfoManager.h"

#import "NSDate+Category.h"
#import "UIColor+GGColor.h"

@interface TUBatteryController ()

@property (strong, nonatomic) UIScrollView *bgScrollView;  //背景scroll
@property (strong, nonatomic) UILabel *headerLabel;        //充电与否状态的Label

@property (strong, nonatomic) TUBatteryCapacityView *capacityView; //电量圆圈的View
@property (strong, nonatomic) TUBatteryBottomView *bottomView;     //电池温度、电池剩余寿命View


@property (strong, nonatomic) NSString *batteryStatus;     //电池状态
@property (assign, nonatomic) CGFloat levelPercent;        //电量百分比
@property (assign, nonatomic) CGFloat temperature;         //电池温度


@end

@implementation TUBatteryController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self UIConfig];
    
    self.navigationController.navigationBarHidden = YES;
    
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

#pragma mark - UIConfig
- (void)UIConfig {
    
    [self preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];

    [self.view addSubview:self.bgScrollView];

    //headerStateLabel
    [self.bgScrollView addSubview:self.headerLabel];

    //已开启全面保护模式
    TUBatteryHeaderView *headerView = [[TUBatteryHeaderView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 50)];
    [self.bgScrollView addSubview:headerView];
    
    //7个按钮的View
    TUBatteryTipsView *tipsBtnView = [[TUBatteryTipsView alloc] initWithFrame:CGRectMake(0, 94, kScreenWidth, 50) count:7];
    [self.bgScrollView addSubview:tipsBtnView];
    
    //电量圆圈的View
    self.capacityView = [[TUBatteryCapacityView alloc] initWithFrame:CGRectMake(0, 144, kScreenWidth, 200)];
    [self.bgScrollView addSubview:self.capacityView];
    
    //三个充电状态View
    TUBatteryProgressView *progressView = [TUBatteryProgressView showProgressView];
    [progressView setFrame:CGRectMake(0, 364, kScreenWidth, 60)];
    [self.bgScrollView addSubview:progressView];
    
    //电压电流折线View
    TUBatteryVIView *viView = [TUBatteryVIView showGraphView];
    [viView setFrame:CGRectMake(0, 454, kScreenWidth, 90)];
    [self.bgScrollView addSubview:viView];
    
    //电池温度以及剩余寿命的View
    self.bottomView = [[TUBatteryBottomView alloc] initWithFrame:CGRectMake(0, 714, kScreenWidth, 160)];
    [self.bgScrollView addSubview:self.bottomView];


}

- (void)updateBatteryInfo:(NSNotification *)note {
    self.batteryStatus = [TUSystemInfoManager manager].batteryInfo.status;
    
    self.levelPercent = [TUSystemInfoManager manager].batteryInfo.levelPercent;

    self.temperature = [TUSystemInfoManager manager].batteryInfo.temperature/100.0;
    
    CGFloat voltage = [TUSystemInfoManager manager].batteryInfo.voltage/1000.0;
    CGFloat amperage = [TUSystemInfoManager manager].batteryInfo.amperage;
    CGFloat count = [TUSystemInfoManager manager].batteryInfo.cycleCount;

    NSString *date = [[NSDate dateFromStringOrNumber:@([TUSystemInfoManager manager].batteryInfo.updateTime)] standardTimeIntervalDescription];
    
    NSString *string = [NSString stringWithFormat:@"voltage:%f,\n amperage:%f,\n count:%f,\n temperature:%f,\n date:%@", voltage, amperage, count, self.temperature, date];
    NSLog(@"%@", string);
    [[[UIAlertView alloc] initWithTitle:@"SystemInfo" message:[note.object componentsJoinedByString:@"\n"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
    [[[UIAlertView alloc] initWithTitle:@"BatteryInfo" message:string delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
    
    
    [self updateUI];
}

- (void)updateSystemInfo:(NSNotification *)note {
    
    NSArray *array = note.object;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - updateUI
- (void)updateUI {
    [self updateBatteryStatus];
    [self updateBatteryCapacity];
    [self updateTemperature];
}

- (void)updateBatteryStatus {
    if (self.batteryStatus.length > 0) {
        NSString *status = self.batteryStatus;
        
        if ([status isEqualToString:@"Fully charged"]) {
            self.headerLabel.text = @"已充满";
        } else if ([status isEqualToString:@"Charging"]) {
            self.headerLabel.text = @"正在充电";
        } else if ([status isEqualToString:@"Unplugged"]) {
            self.headerLabel.text = @"未充电";
        } else if ([status isEqualToString:@"Unknown"]) {
            self.headerLabel.text = @"未知状态";
        }
    }
}

- (void)updateBatteryCapacity {
    self.capacityView.batteryCapacityLabel.text = [NSString stringWithFormat:@"%d%@",(int)self.levelPercent,@"%"];
}

- (void)updateTemperature {
    self.bottomView.temperatureValueLabel.text = [NSString stringWithFormat:@"%.1f℃",self.temperature];
}

#pragma mark - setter & getter 
- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _headerLabel.textColor = [UIColor whiteColor];
        _headerLabel.text = @"正在充电";
        _headerLabel.backgroundColor = [UIColor colorWithRGB:0xff1c2135];
        _headerLabel.font = [UIFont systemFontOfSize:19.f];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headerLabel;
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgScrollView.backgroundColor = [UIColor colorWithARGB:0xff1c2135];
        [_bgScrollView setContentSize:CGSizeMake(kScreenWidth, 850)];
    }
    return _bgScrollView;
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
