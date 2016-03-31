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
#import "UIImage+Color.h"
#import "UIImage+YYWebImage.h"
#import "TUSystemInfoManager.h"
#import "TUAttributeLabel.h"

#define DegreesToRadians(_degrees) ((M_PI * (_degrees))/180)

@interface TUBatteryBottomView ()

@property (strong, nonatomic) CAShapeLayer *temperatureDotLayer;
@property (strong, nonatomic) CAShapeLayer *temperatureDotOpacityLayer;

@property (strong, nonatomic) CAShapeLayer *batteryDotLayer;
@property (strong, nonatomic) CAShapeLayer *batteryDotOpacityLayer;

@property (strong, nonatomic) UIImageView *temperatureImage;
@property (strong, nonatomic) UIImageView *batteryLifeImage;

@property (strong, nonatomic) UILabel *temperatureLabel;
@property (strong, nonatomic) UILabel *batteryLabel;

@property (strong, nonatomic) UILabel *temperatureValueLabel;//电池温度Value
@property (strong, nonatomic) TUAttributeLabel *batteryValueLabel;//电池剩余寿命Value

@property (assign, nonatomic) CGFloat lastTemperature;
@property (assign, nonatomic) NSInteger remainLifeMonths;
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
    
    [self addSubview:self.temperatureImage];
    [self addSubview:self.batteryLifeImage];
    
    [self.temperatureImage addSubview:self.temperatureLabel];
    [self.temperatureImage addSubview:self.temperatureValueLabel];
    
    [self.batteryLifeImage addSubview:self.batteryLabel];
    [self.batteryLifeImage addSubview:self.batteryValueLabel];

    [self temperatureUI];
    [self batteryUI];
}

- (void)temperatureUI {
    self.temperatureDotLayer = [CAShapeLayer layer];
    self.temperatureDotLayer.position = CGPointMake(self.temperatureImage.width/2, self.temperatureImage.height/2);
    self.temperatureDotLayer.fillColor = [UIColor colorWithRGB:0xff79d6a2].CGColor;
    
    self.temperatureDotLayer.mask = self.temperatureDotOpacityLayer;
    self.temperatureDotOpacityLayer = [CAShapeLayer layer];
    self.temperatureDotOpacityLayer.position = CGPointMake(self.temperatureImage.width/2, self.temperatureImage.height/2);
    self.temperatureDotOpacityLayer.fillColor = [UIColor colorWithRGB:0xff79d6a2].CGColor;
    self.temperatureDotOpacityLayer.opacity = 0.5;
    
    //设置圆的半径
    //设置路径
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-53, -3, 6, 6)];
    self.temperatureDotLayer.path = circlePath.CGPath;
    
    UIBezierPath *circleMaskPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-55, -5, 10, 10)];
    
    self.temperatureDotOpacityLayer.path = circleMaskPath.CGPath;

    [self.temperatureImage.layer addSublayer:self.temperatureDotLayer];
    [self.temperatureImage.layer addSublayer:self.temperatureDotOpacityLayer];
}

- (void)batteryUI {
    self.batteryDotLayer = [CAShapeLayer layer];
    self.batteryDotLayer.position = CGPointMake(self.batteryLifeImage.width/2, self.batteryLifeImage.height/2);
    self.batteryDotLayer.fillColor = [UIColor whiteColor].CGColor;
    
    self.batteryDotLayer.mask = self.batteryDotOpacityLayer;
    self.batteryDotOpacityLayer = [CAShapeLayer layer];
    self.batteryDotOpacityLayer.position = CGPointMake(self.batteryLifeImage.width/2, self.batteryLifeImage.height/2);
    self.batteryDotOpacityLayer.fillColor = [UIColor whiteColor].CGColor;
    self.batteryDotOpacityLayer.opacity = 0.5;

    //设置圆的半径
    //设置路径
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-35, 33, 6, 6)];
    self.batteryDotLayer.path = circlePath.CGPath;
    
    UIBezierPath *circleMaskPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-37, 31, 10, 10)];
    self.batteryDotOpacityLayer.path = circleMaskPath.CGPath;

    
    [self.batteryLifeImage.layer addSublayer:self.batteryDotLayer];
    [self.batteryLifeImage.layer addSublayer:self.batteryDotOpacityLayer];

}

- (void)updateTemperatureUI:(CGFloat)temperature {
    self.temperatureValueLabel.text = [NSString stringWithFormat:@"%.1f℃",temperature];
    
//    self.temperatureDotLayer.transform = CATransform3DMakeRotation(M_PI_4 * 3, 0, 0, 1);
//    self.temperatureDotOpacityLayer.transform = CATransform3DMakeRotation(M_PI_4 * 3, 0, 0, 1);

    CGFloat lastTemp = self.lastTemperature ? self.lastTemperature : 0;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima.duration = 1.f;

    anima.fromValue = [NSNumber numberWithFloat: DegreesToRadians(lastTemp/35.0*180)];
    anima.toValue = [NSNumber numberWithFloat: DegreesToRadians(temperature/35.0*180)];
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    anima.delegate = self;
    [self.temperatureDotLayer addAnimation:anima forKey:@"temperatureDotLayer"];
    [self.temperatureDotOpacityLayer addAnimation:anima forKey:@"temperatureDotOpacityLayer"];
    
    self.lastTemperature = temperature;
}

- (void)updateBatteryLifeUI:(NSInteger)remainLifeMonths {
    self.remainLifeMonths = remainLifeMonths;

    self.batteryValueLabel.text = [NSString stringWithFormat:@"%ld年%ld个月",remainLifeMonths/12,remainLifeMonths%12];
    
    [self.batteryValueLabel addTextFont:[UIFont systemFontOfSize:13] range:NSMakeRange(1, 1)];
    [self.batteryValueLabel addTextFont:[UIFont systemFontOfSize:13] range:NSMakeRange(3, 2)];
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anima.duration = 5.f;
//    anima.fromValue = [NSNumber numberWithFloat:M_PI_2];
    anima.toValue = [NSNumber numberWithFloat:DegreesToRadians((60-remainLifeMonths)/60.0*270)];
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    anima.delegate = self;
    
    [self.batteryDotLayer addAnimation:anima forKey:@"batteryDotLayer"];
    [self.batteryDotOpacityLayer addAnimation:anima forKey:@"batteryDotOpacityLayer"];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (anim.duration == 1.0f) {
        if (flag) {
            NSNumber *toValue = [(CABasicAnimation *)anim toValue];
            CGPoint point = [self.class calcCircleCoordinateWithCenter:CGPointMake(self.temperatureImage.width/2, self.temperatureImage.height/2) andWithAngle:toValue.floatValue andWithRadius:50];
            
            UIColor *color = [self.temperatureImage.image colorAtPoint:point];
            self.temperatureDotLayer.fillColor = color.CGColor;
            self.temperatureDotOpacityLayer.fillColor = color.CGColor;
        }
    }
     else if (anim.duration == 5.0f){
    
        if (flag) {
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0, 0, 4, 4);
            view.backgroundColor = [UIColor redColor];
        
            CGPoint point = [self.class calcCircleCoordinateWithCenterPoint:CGPointMake(self.batteryLifeImage.width/2, self.batteryLifeImage.height/2) andWithAngle:(60-self.remainLifeMonths)/60.0*270 andWithRadius:48];

            view.center = point;
//            [self.batteryLifeImage addSubview:view];
        
            UIColor *color = [self.batteryLifeImage.image colorAtPoint:point];
        
            view.backgroundColor = [UIColor redColor];
        
            self.batteryDotLayer.fillColor = color.CGColor;
            self.batteryDotOpacityLayer.fillColor = color.CGColor;
        }
    }
}

+(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}

+(CGPoint)calcCircleCoordinateWithCenterPoint:(CGPoint)center andWithAngle:(CGFloat)angle andWithRadius:(CGFloat)radius{
    CGFloat x = radius*cosf(-M_PI_4 + angle*M_PI/180);
    CGFloat y= radius*sinf(-M_PI_4 + angle*M_PI/180);
    return CGPointMake(center.x - x, center.y - y);
}


#pragma mark - setter & getter
- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.temperatureImage.width/2-45, 40, 90, 20)];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.font = [UIFont systemFontOfSize:13.f];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.text = @"当前电池温度";
    }
    return _temperatureLabel;
}

- (UILabel *)temperatureValueLabel {
    if (!_temperatureValueLabel) {
        _temperatureValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.temperatureImage.width/2-45, 60, 90, 20)];
        _temperatureValueLabel.textColor = [UIColor whiteColor];
        _temperatureValueLabel.font = [UIFont systemFontOfSize:20.f];
        _temperatureValueLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureValueLabel.text = [NSString stringWithFormat:@"%dC",30];
    }
    return _temperatureValueLabel;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.batteryLifeImage.width/2-45, 40, 90, 20)];
        _batteryLabel.textColor = [UIColor whiteColor];
        _batteryLabel.font = [UIFont systemFontOfSize:13.f];
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
        _batteryLabel.text = @"电池剩余寿命";

    }
    return _batteryLabel;
}

- (TUAttributeLabel *)batteryValueLabel {
    if (!_batteryValueLabel) {
        _batteryValueLabel = [[TUAttributeLabel alloc] initWithFrame:CGRectMake(self.batteryLifeImage.width/2-45, 60, 90, 20)];
        _batteryValueLabel.textColor = [UIColor whiteColor];
        _batteryValueLabel.font = [UIFont systemFontOfSize:20.f];
        _batteryValueLabel.textAlignment = NSTextAlignmentCenter;
        _batteryValueLabel.text = @"";
    }
    return _batteryValueLabel;
}

- (UIImageView *)temperatureImage {
    if (!_temperatureImage) {
        _temperatureImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2 - 165, 10, 155, 130)];
        _temperatureImage.image = [UIImage imageNamed:@"battery_wendu"];
    }
    return _temperatureImage;
}

- (UIImageView *)batteryLifeImage {
    if (!_batteryLifeImage) {
        _batteryLifeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2 + 10, 10, 155, 130)];
        _batteryLifeImage.image = [UIImage imageNamed:@"battery_life"];
    }
    return _batteryLifeImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
