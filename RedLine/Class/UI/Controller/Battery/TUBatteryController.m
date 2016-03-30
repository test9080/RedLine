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
#import "UIImage+YYWebImage.h"

@interface TUBatteryController ()
{
    int _viCount;
}

@property (strong, nonatomic) UIScrollView *bgScrollView;  //背景scroll

@property (strong, nonatomic) TUBatteryCapacityView *capacityView; //电量圆圈的View
@property (strong, nonatomic) TUBatteryBottomView *bottomView;     //电池温度、电池剩余寿命View
@property (strong, nonatomic) TUBatteryVIView *viView;     //电压电流折线图

@property (assign, nonatomic) CGFloat temperature;         //电池温度
@property (assign, nonatomic) float voltage; // 电压
@property (assign, nonatomic) float current; // 电流
@property (assign, nonatomic) NSInteger remainLifeMonths; // 电池剩余月份

@property (strong, nonatomic) NSMutableArray *voltageArray;
@property (strong, nonatomic) NSMutableArray *currentArray;

@end

@implementation TUBatteryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UIConfig];
    
    [kTUNotificationCenter addObserver:self
                              selector:@selector(updateBatteryInfo:)
                                  name:kBatteryInfoDidChangeNotification
                                object:nil];
    
    CGFloat level = [TUSystemInfoManager manager].batteryInfo.levelPercent;
    NSString *status = [TUSystemInfoManager manager].batteryInfo.status;

    NSLog(@"level:%f, status:%@", level, status);
}

- (void)dealloc {
    [self.voltageArray removeAllObjects];
    self.voltageArray = nil;
    
    [self.currentArray removeAllObjects];
    self.currentArray = nil;
}

#pragma mark - UIConfig
- (void)UIConfig {
    [self configNavigationBar];
    [self setNeedsStatusBarAppearanceUpdate];

    [self.view addSubview:self.bgScrollView];
    
    self.voltageArray = [NSMutableArray array];
    self.currentArray = [NSMutableArray array];
    
    _viCount = 0;
    
    int displayY = 15;
    
    //已开启全面保护模式
    TUBatteryHeaderView *headerView = [[TUBatteryHeaderView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, 30)];
    [self.bgScrollView addSubview:headerView];
    displayY += headerView.bounds.size.height;
    
    //7个按钮的View
    displayY += 15;
    TUBatteryTipsView *tipsBtnView = [[TUBatteryTipsView alloc] initWithFrame:CGRectMake(0, displayY, kScreenWidth, 30) count:7];
    [self.bgScrollView addSubview:tipsBtnView];
    displayY += tipsBtnView.bounds.size.height;
    
    //电量圆圈的View
    displayY += 33;
    [self updateBatteryCapacity];
    self.capacityView = [[TUBatteryCapacityView alloc] initWithFrame:CGRectMake(0, displayY, kScreenWidth, 255) style:[self styleWithBatteryLevelPercent:[TUSystemInfoManager manager].batteryInfo.levelPercent]];
    [self.bgScrollView addSubview:self.capacityView];
    displayY += self.capacityView.bounds.size.height;
    
    //三个充电状态View
    displayY += 55;
    TUBatteryProgressView *progressView = [TUBatteryProgressView showProgressView];
    [progressView setFrame:CGRectMake(0, displayY, kScreenWidth, 53)];
    [self.bgScrollView addSubview:progressView];
    displayY += progressView.bounds.size.height;
    
    //电压电流折线View
    displayY += 50;
    self.viView = [TUBatteryVIView showGraphView];
    [self.viView setFrame:CGRectMake(0, displayY, kScreenWidth, 203)];
    [self.bgScrollView addSubview:self.viView];
    displayY += self.viView.bounds.size.height;
    
    //电池温度以及剩余寿命的View
    displayY += 60;
    self.bottomView = [[TUBatteryBottomView alloc] initWithFrame:CGRectMake(0, displayY, kScreenWidth, 120)];
    [self.bgScrollView addSubview:self.bottomView];
    displayY += self.bottomView.bounds.size.height;
    
    displayY += 5;
    self.bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, displayY);
}

- (void)updateBatteryInfo:(NSNotification *)note {
    self.temperature = [TUSystemInfoManager manager].batteryInfo.temperature/100.0;
    self.remainLifeMonths = [TUSystemInfoManager manager].batteryInfo.remainLifeMonths;
    
    
    self.voltage = [TUSystemInfoManager manager].batteryInfo.voltage/1000.0;
    self.current = [TUSystemInfoManager manager].batteryInfo.amperage/1000.0;
    CGFloat count = [TUSystemInfoManager manager].batteryInfo.cycleCount;

    NSString *date = [[NSDate dateFromStringOrNumber:@([TUSystemInfoManager manager].batteryInfo.updateTime)] standardTimeIntervalDescription];
    
    NSString *string = [NSString stringWithFormat:@"voltage:%f,\n amperage:%f,\n count:%f,\n temperature:%f,\n date:%@", self.voltage, self.current, count, self.temperature, date];
    NSLog(@"%@", string);
    
    [self updateUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - updateUI

// 配置导航栏
- (void)configNavigationBar
{
    // bg color
    UIImage *temp = [UIImage yy_imageWithColor:[UIColor colorWithARGB:0xff1c2137]];
    [self.navigationController.navigationBar setBackgroundImage:temp forBarMetrics:UIBarMetricsDefault];
    
    // shadow color
    temp = [UIImage yy_imageWithColor:[UIColor colorWithARGB:0xff2a2f4b]];
    [self.navigationController.navigationBar setShadowImage:temp];
    
    // title
    NSDictionary *titleDic = @{NSForegroundColorAttributeName: [UIColor colorWithARGB:0xffffffff]};
    [self.navigationController.navigationBar setTitleTextAttributes:titleDic];
}

- (void)updateUI {
    [self updateBatteryStatus];
    [self updateBatteryCapacity];
    [self updateBatteryChargeTimeStatus];
    [self updateTemperature];
    [self updateBatteryLife];
    [self updateVI];
}

- (void)updateBatteryStatus {
    self.title = [TUSystemInfoManager manager].batteryInfo.status;
}

- (TUBatteryCapacityViewStyle)styleWithBatteryLevelPercent:(CGFloat)levelPercent {
    if (levelPercent <= 20) {
        return TUBatteryCapacityViewStyleRed;
    } else if (levelPercent >= 80) {
        return TUBatteryCapacityViewStyleGreen;
    } else {
        return TUBatteryCapacityViewStyleYellow;
    }
}

- (void)updateBatteryCapacity {
   
    self.capacityView.batteryCapacityViewStyle = [self styleWithBatteryLevelPercent:[TUSystemInfoManager manager].batteryInfo.levelPercent];
    
    NSString *temp = [NSString stringWithFormat:@"%d%@",(int)[TUSystemInfoManager manager].batteryInfo.levelPercent,@"%"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:temp];
    
    //设置字体
    UIFont *font = [UIFont systemFontOfSize:25];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [temp length] - 1)];
    
    font = [UIFont boldSystemFontOfSize:12];
    [attrString addAttribute:NSFontAttributeName value:font range:[temp rangeOfString:@"%"]];
    
    self.capacityView.batteryCapacityLabel.attributedText = attrString;
}

- (void)updateBatteryChargeTimeStatus
{
    NSString *temp = @"充满所需1小时22分钟";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:temp];
    
    //设置字体
    UIFont *font = [UIFont systemFontOfSize:15];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [temp length])];
    
    font = [UIFont systemFontOfSize:20];
    NSRange temp1 = [temp rangeOfString:@"充满所需"];
    NSRange temp2 = [temp rangeOfString:@"小时"];
    NSRange temp3 = [temp rangeOfString:@"分钟"];
    unsigned long tempLoc = temp1.location + temp1.length;
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(temp1.location + temp1.length, temp2.location - tempLoc)];
    tempLoc = temp2.location + temp2.length;
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(temp2.location + temp2.length, temp3.location - tempLoc)];
    
    self.capacityView.batteryTimeLabel.attributedText = attrString;
}

- (void)updateTemperature {
    [self.bottomView updateTemperatureUI:self.temperature];
    
//    self.bottomView.temperatureValueLabel.text = [NSString stringWithFormat:@"%.1f℃",self.temperature];
}

- (void)updateBatteryLife {
    self.bottomView.batteryValueLabel.text = [NSString stringWithFormat:@"%ld年%ld个月",self.remainLifeMonths/12,self.remainLifeMonths%12];
}

- (void)updateVI {
    self.viView.voltageLabel.text = [NSString stringWithFormat:@"当前电压:%.3fV",self.voltage];
    self.viView.currentLabel.text = [NSString stringWithFormat:@"当前电流:%.3fA",self.current];
    
    _viCount++;
    if (_viCount >= 20) {
        [self.voltageArray removeObjectAtIndex:0];
        [self.currentArray removeObjectAtIndex:0];
        
        [self.voltageArray addObject:[NSNumber numberWithFloat:self.voltage]];
        [self.currentArray addObject:[NSNumber numberWithFloat:self.current]];
    } else {
        [self.voltageArray addObject:[NSNumber numberWithFloat:self.voltage]];
        [self.currentArray addObject:[NSNumber numberWithFloat:self.current]];
    }
    
    [self.viView updeteDataWithVoltageArray:self.voltageArray currentArray:self.currentArray];
}

#pragma mark - setter & getter 

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.bounds.size.height)];
        _bgScrollView.backgroundColor = [UIColor colorWithARGB:0xff1c2137];
    }
    return _bgScrollView;
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
