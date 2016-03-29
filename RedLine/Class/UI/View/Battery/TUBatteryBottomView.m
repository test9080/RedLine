//
//  TUBatteryBottomView.m
//  RedLine
//
//  Created by LXJ on 16/3/28.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryBottomView.h"
#import "UIView+Category.h"
#import "UIColor+GGColor.h"

#define DegreesToRadians(_degrees) ((M_PI * (_degrees))/180)

@interface TUBatteryBottomView ()

@property (strong, nonatomic) UIView *temperatureView;
@property (strong, nonatomic) UIView *batteryLifeView;

@property (strong, nonatomic) CAShapeLayer *temperatureDotLayer;
@property (strong, nonatomic) CAShapeLayer *batteryDotLayer;

@property (strong, nonatomic) UILabel *temperatureLabel;
@property (strong, nonatomic) UILabel *temperatureValueLabel;

@property (strong, nonatomic) UILabel *batteryLabel;
@property (strong, nonatomic) UILabel *batteryValueLabel;


@end

@implementation TUBatteryBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

- (void)setup {
    [self addSubview:self.temperatureView];
    [self addSubview:self.batteryLifeView];
    
    [self.temperatureView addSubview:self.temperatureLabel];
    [self.temperatureView addSubview:self.temperatureValueLabel];
    
    [self.batteryLifeView addSubview:self.batteryLabel];
    [self.batteryLifeView addSubview:self.batteryValueLabel];
    
    [self temperatureUI];
    [self batteryUI];
}

- (void)temperatureUI {
    self.temperatureDotLayer = [CAShapeLayer layer];
    self.temperatureDotLayer.position = CGPointMake(55, 55);
    self.temperatureDotLayer.fillColor = [UIColor whiteColor].CGColor;
    
    //设置圆的半径
    //设置路径
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(32, 32, 10, 10)];
    self.temperatureDotLayer.path = circlePath.CGPath;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima.duration = 10.f;
    anima.repeatCount = HUGE;
    anima.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    //    anima.removedOnCompletion = NO;
    //    anima.fillMode = kCAFillModeForwards;
    
    [self.temperatureDotLayer addAnimation:anima forKey:nil];
    
    //画圆
    CAShapeLayer * trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.temperatureView.bounds;
    trackLayer.fillColor = [[UIColor clearColor] CGColor];//填充颜色，这里应该是  clearColor
    trackLayer.strokeColor = [[UIColor redColor] CGColor];//边框颜色
    trackLayer.opacity = 1;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = 4.0;  // 红色的边框宽度
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(55, 55) radius:53 startAngle:DegreesToRadians(-210) endAngle:DegreesToRadians(30) clockwise:YES];
    //角度是从 -210到30度，具体可以看如下图所示
    trackLayer.path = [path CGPath];
    
    [self.temperatureView.layer addSublayer:trackLayer];
    
    
    CALayer * gradinetLayer = [CALayer layer];
    
    CAGradientLayer * gradLayer1 = [CAGradientLayer layer];
    gradLayer1.frame = CGRectMake(0, 0, self.temperatureView.width/2, self.temperatureView.height);
    [gradLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithARGB:0xff3ed0bd] CGColor],(id)[UIColor colorWithARGB:0xfff2e562].CGColor, nil]];
    [gradLayer1 setLocations:@[@0.5,@0.9,@1 ]];
    [gradLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradinetLayer addSublayer:gradLayer1];
    
    CAGradientLayer * gradLayer2 = [CAGradientLayer layer];
    gradLayer2.frame = CGRectMake(self.temperatureView.width/2, 0, self.temperatureView.width/2, self.temperatureView.height);
    [gradLayer2 setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithARGB:0xfff2e562].CGColor,(id)[[UIColor colorWithARGB:0xffd93d64] CGColor], nil]];
    [gradLayer2 setLocations:@[@0.2,@0.5,@1 ]];
    [gradLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradinetLayer addSublayer:gradLayer2];
    
    [gradinetLayer setMask:trackLayer];
    
    [self.temperatureView.layer addSublayer:gradinetLayer];
    [self.temperatureView.layer addSublayer:self.temperatureDotLayer];
}

- (void)batteryUI {
    self.batteryDotLayer = [CAShapeLayer layer];
    self.batteryDotLayer.position = CGPointMake(55, 55);
    self.batteryDotLayer.fillColor = [UIColor whiteColor].CGColor;
    
    //设置圆的半径
    //设置路径
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(32, 32, 10, 10)];
    self.batteryDotLayer.path = circlePath.CGPath;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima.duration = 10.f;
    anima.repeatCount = HUGE;
    anima.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    //    anima.removedOnCompletion = NO;
    //    anima.fillMode = kCAFillModeForwards;
    [self.batteryDotLayer addAnimation:anima forKey:nil];
    
    //画圆
    CAShapeLayer * trackLayer = [CAShapeLayer layer];
    trackLayer.frame = self.batteryDotLayer.bounds;
    trackLayer.fillColor = [[UIColor clearColor] CGColor];//填充颜色，这里应该是  clearColor
    trackLayer.strokeColor = [[UIColor redColor] CGColor];//边框颜色
    trackLayer.opacity = 1;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = 4.0;  // 红色的边框宽度
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(55, 55) radius:53 startAngle:DegreesToRadians(-210) endAngle:DegreesToRadians(30) clockwise:YES];
    //角度是从 -210到30度，具体可以看如下图所示
    trackLayer.path = [path CGPath];
    
    [self.batteryLifeView.layer addSublayer:trackLayer];
    
    
    CALayer * gradinetLayer = [CALayer layer];
    
    CAGradientLayer * gradLayer1 = [CAGradientLayer layer];
    gradLayer1.frame = CGRectMake(0, 0, self.batteryLifeView.width/2, self.batteryLifeView.height);
    [gradLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithARGB:0xff3ed0bd] CGColor],(id)[UIColor colorWithARGB:0xfff2e562].CGColor, nil]];
    [gradLayer1 setLocations:@[@0.5,@0.9,@1 ]];
    [gradLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradinetLayer addSublayer:gradLayer1];
    
    CAGradientLayer * gradLayer2 = [CAGradientLayer layer];
    gradLayer2.frame = CGRectMake(self.batteryLifeView.width/2, 0, self.batteryLifeView.width/2, self.temperatureView.height);
    [gradLayer2 setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithARGB:0xfff2e562].CGColor,(id)[[UIColor colorWithARGB:0xffd93d64] CGColor], nil]];
    [gradLayer2 setLocations:@[@0.2,@0.5,@1 ]];
    [gradLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradinetLayer addSublayer:gradLayer2];
    
    [gradinetLayer setMask:trackLayer];
    
    [self.batteryLifeView.layer addSublayer:gradinetLayer];
    [self.batteryLifeView.layer addSublayer:self.batteryDotLayer];

    
}

#pragma mark - setter & getter
- (UIView *)temperatureView {
    if (!_temperatureView) {
        _temperatureView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 - 130, 20, 110, 110)];
        _temperatureView.backgroundColor = [UIColor clearColor];
    }
    return _temperatureView;
}

- (UIView *)batteryLifeView {
    if (!_batteryLifeView) {
        _batteryLifeView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 + 20, 20, 110, 110)];
        _batteryLifeView.backgroundColor = [UIColor clearColor];
    }
    return _batteryLifeView;
}

- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 90, 20)];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.font = [UIFont systemFontOfSize:15.f];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.text = @"当前电池温度";
    }
    return _temperatureLabel;
}

- (UILabel *)temperatureValueLabel {
    if (!_temperatureValueLabel) {
        _temperatureValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 90, 20)];
        _temperatureValueLabel.textColor = [UIColor whiteColor];
        _temperatureValueLabel.font = [UIFont systemFontOfSize:20.f];
        _temperatureValueLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureValueLabel.text = [NSString stringWithFormat:@"%dC",30];
    }
    return _temperatureValueLabel;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 90, 20)];
        _batteryLabel.textColor = [UIColor whiteColor];
        _batteryLabel.font = [UIFont systemFontOfSize:15.f];
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
        _batteryLabel.text = @"电池剩余寿命";

    }
    return _batteryLabel;
}

- (UILabel *)batteryValueLabel {
    if (!_batteryValueLabel) {
        _batteryValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 90, 20)];
        _batteryValueLabel.textColor = [UIColor whiteColor];
        _batteryValueLabel.font = [UIFont systemFontOfSize:20.f];
        _batteryValueLabel.textAlignment = NSTextAlignmentCenter;
        _batteryValueLabel.text = @"2年6个月";
    }
    return _batteryValueLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
