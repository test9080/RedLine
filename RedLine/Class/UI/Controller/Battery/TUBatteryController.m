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

@property (strong, nonatomic) UIScrollView *bgScrollView;

@end

@implementation TUBatteryController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self UIConfig];
    
//    self.navigationController.navigationBarHidden = YES;
    
    [kTUNotificationCenter addObserver:self
                              selector:@selector(updateBatteryInfo:)
                                  name:kBatteryInfoDidChangeNotification
                                object:nil];
    
    CGFloat level = [TUSystemInfoManager manager].batteryInfo.levelPercent;
    NSString *status = [TUSystemInfoManager manager].batteryInfo.status;

    NSLog(@"level:%f, status:%@", level, status);
}

#pragma mark - UIConfig
- (void)UIConfig {
    [self.view addSubview:self.bgScrollView];

    
    //已开启全面保护模式
    TUBatteryHeaderView *headerView = [[TUBatteryHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [self.bgScrollView addSubview:headerView];
    
    //7个按钮的View
    TUBatteryTipsView *tipsBtnView = [[TUBatteryTipsView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 50) count:7];
    [self.bgScrollView addSubview:tipsBtnView];
    
    //电量圆圈的View
    TUBatteryCapacityView *cycleView = [[TUBatteryCapacityView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 200)];
    [self.bgScrollView addSubview:cycleView];
    
    //三个充电状态View
    TUBatteryProgressView *progressView = [TUBatteryProgressView showProgressView];
    [progressView setFrame:CGRectMake(0, 320, kScreenWidth, 60)];
    [self.bgScrollView addSubview:progressView];
    
    //电压电流折线View
    TUBatteryVIView *viView = [TUBatteryVIView showGraphView];
    [viView setFrame:CGRectMake(0, 410, kScreenWidth, 90)];
    [self.bgScrollView addSubview:viView];
    
    TUBatteryBottomView *bottomView = [[TUBatteryBottomView alloc] initWithFrame:CGRectMake(0, 670, kScreenWidth, 160)];
    [self.bgScrollView addSubview:bottomView];


}

- (void)updateBatteryInfo:(NSNotification *)note {
    CGFloat voltage = [TUSystemInfoManager manager].batteryInfo.voltage/1000.0;
    CGFloat amperage = [TUSystemInfoManager manager].batteryInfo.amperage;
    CGFloat count = [TUSystemInfoManager manager].batteryInfo.cycleCount;
    CGFloat temperature = [TUSystemInfoManager manager].batteryInfo.temperature/100.0;

    NSString *date = [[NSDate dateFromStringOrNumber:@([TUSystemInfoManager manager].batteryInfo.updateTime)] standardTimeIntervalDescription];
    
    NSString *string = [NSString stringWithFormat:@"voltage:%f,\n amperage:%f,\n count:%f,\n temperature:%f,\n date:%@", voltage, amperage, count, temperature, date];
    NSLog(@"%@", string);
}


#pragma mark - setter & getter 
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
