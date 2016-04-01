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
    BOOL _isShowBatteryLife;//电池剩余时间，就显示一次就行了
}

@property (strong, nonatomic) UIScrollView *bgScrollView;  //背景scroll

@property (strong, nonatomic) TUBatteryCapacityView *capacityView; //电量圆圈的View
@property (strong, nonatomic) TUBatteryBottomView *bottomView;     //电池温度、电池剩余寿命View
@property (strong, nonatomic) TUBatteryVIView *viView;     //电压电流折线图
@property (strong, nonatomic) TUBatteryProgressView *progressView;  //充电进度条View

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
    [kTUNotificationCenter addObserver:self
                              selector:@selector(updateTimeToFull:)
                                  name:kBatteryTimeToFullDidChangeNotification
                                object:nil];
    [kTUNotificationCenter addObserver:self
                              selector:@selector(updateTimeToEmpty:)
                                  name:kBatteryTimeToEmptyDidChangeNotification
                                object:nil];
    [kTUNotificationCenter addObserver:self
                              selector:@selector(updateBatteryStatus)
                                  name:kBatteryStatusDidChangeNotification
                                object:nil];
    [kTUNotificationCenter addObserver:self
                              selector:@selector(updateBatteryCapacity)
                                  name:kBatteryLevelDidChangeNotification
                                object:nil];
    CGFloat level = [TUSystemInfoManager manager].batteryInfo.levelPercent;
    NSString *status = [TUSystemInfoManager manager].batteryInfo.status;

    NSLog(@"level:%f, status:%@", level, status);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.capacityView resume];
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
    _isShowBatteryLife = YES;
    
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
    self.capacityView = [[TUBatteryCapacityView alloc] initWithFrame:CGRectMake(0, displayY, kScreenWidth, 255) style:[self styleWithBatteryLevelPercent:[TUSystemInfoManager manager].batteryInfo.levelPercent]];
    [self.bgScrollView addSubview:self.capacityView];
    [self updateBatteryCapacity];
    displayY += self.capacityView.bounds.size.height;

    //三个充电状态View
    displayY += 55;
    self.progressView = [TUBatteryProgressView showProgressView];
    [self.progressView  setFrame:CGRectMake(45, displayY, kScreenWidth - 45 * 2, 60)];
    [self.bgScrollView addSubview:self.progressView ];
    displayY += self.progressView .bounds.size.height;
    
    //电压电流折线View
    displayY += 50;
    self.viView = [TUBatteryVIView showGraphView];
    [self.viView setFrame:CGRectMake(0, displayY, kScreenWidth, 203)];
    [self.bgScrollView addSubview:self.viView];
    displayY += self.viView.bounds.size.height;
    
    //电池温度以及剩余寿命的View
    displayY += 60;
    self.bottomView = [[TUBatteryBottomView alloc] initWithFrame:CGRectMake(0, displayY, kScreenWidth, 150)];
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

    NSInteger current = [TUSystemInfoManager manager].batteryInfo.rawCurrentCapacity;
    
    NSString *date = [[NSDate dateFromStringOrNumber:@([TUSystemInfoManager manager].batteryInfo.updateTime)] standardTimeIntervalDescription];
    
    NSString *string = [NSString stringWithFormat:@"voltage:%f,\n amperage:%f,\n count:%f,\n temperature:%f,\n date:%@,\n current:%ld", self.voltage, self.current, count, self.temperature, date, (long)current];
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
//    [self updateBatteryChargeTimeStatus];
    [self updateTemperature];
    if (_isShowBatteryLife) {
        [self updateBatteryLife];
        _isShowBatteryLife = NO;
    }
    [self updateVI];
    [self updateProgress];
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

- (void)updateTimeToFull:(NSNotification *)note {
    int info = abs([note.object intValue]);
    if (info == 0) {
        self.capacityView.batteryTimeLabel.text = @"正在获取充电状态";
        return;
    }

    int hour = info / 3600;
    int min = (info % 3600) / 60;

    NSString *string = [NSString stringWithFormat:@"%d小时%d分钟", hour, min];
    [self updateBatteryChargeTimeStatus:@"充满所需" time:string];
}

- (void)updateTimeToEmpty:(NSNotification *)note {
    int info = abs([note.object intValue]);
    
    if (info == 0) {
        self.capacityView.batteryTimeLabel.text = @"正在获取电池状态";
        return;
    }
    int hour = info / 3600;
    int min = (info % 3600) / 60;
    NSString *string = [NSString stringWithFormat:@"%d小时%d分钟", hour, min];
    [self updateBatteryChargeTimeStatus:@"剩余可用" time:string];
}

- (void)updateBatteryChargeTimeStatus:(NSString *)status time:(NSString *)time
{
//    NSString *temp = @"充满所需1小时22分钟";
    NSString *temp = [NSString stringWithFormat:@"%@%@", status, time];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:temp];
    
    //设置字体
    UIFont *font = [UIFont systemFontOfSize:15];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [temp length])];
    
    font = [UIFont systemFontOfSize:20];
    NSRange temp1 = [temp rangeOfString:status];
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
}

- (void)updateBatteryLife {
    [self.bottomView updateBatteryLifeUI:self.remainLifeMonths];
//    self.bottomView.batteryValueLabel.text = [NSString stringWithFormat:@"%ld年%ld个月",self.remainLifeMonths/12,self.remainLifeMonths%12];
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
    
    NSLog(@"aaaaaaa%f",self.viView.averageCurrent);
    
    NSLog(@"fdasfasdfas:%f", [TUSystemInfoManager timeToFullWithAverageAmperage:self.viView.averageCurrent maxCapacity:[TUSystemInfoManager manager].batteryInfo.rawMaxCapacity currentCapacity:[TUSystemInfoManager manager].batteryInfo.rawCurrentCapacity]);
}

- (void)updateProgress {
    [self.progressView updateProgress:[TUSystemInfoManager manager].batteryInfo.levelPercent / 100.f];
}

#pragma mark - setter & getter 

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 64)];
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
