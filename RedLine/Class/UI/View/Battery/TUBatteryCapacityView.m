//
//  TUBatteryCapacityView.m
//  CycleAnimationDemo
//
//  Created by LXJ on 16/3/25.
//  Copyright © 2016年 LianLuo. All rights reserved.
//

#import "TUBatteryCapacityView.h"
#import "UIView+Category.h"

@interface TUBatteryCapacityView ()
{
    CAAnimationGroup *_animaTionGroup;
    CADisplayLink *_disPlayLink;
}


@property (strong, nonatomic) CALayer *animationLayer;


@end

@implementation TUBatteryCapacityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:UIApplicationDidBecomeActiveNotification object:nil];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self initAnimation2];
    [self initLable];
    
//    [self initAnimation];
    
}

- (void)initLable {
    [self addSubview:self.batteryCapacityLabel];
    self.batteryCapacityLabel.text = @"10%";
    
    [self addSubview:self.batteryTimeLabel];
    self.batteryTimeLabel.text = @"充满所需1小时22分钟";
}

- (void)initAnimation {
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAnimation)];
    _disPlayLink.frameInterval = 60;
    [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)initAnimation2 {
    [[UIColor clearColor] setFill];
    
//    UIRectFill(rect);
    
    NSInteger pulsingCount = 3;//上波纹的条数
    double animationDuration = 2;//一组动画持续的时间，直接决定了动画运行快慢。
    
    CALayer * animationLayer = [[CALayer alloc]init];
    self.animationLayer = animationLayer;
    
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [[CALayer alloc]init];
        pulsingLayer.cornerRadius = self.frame.size.height/2;
        pulsingLayer.frame = CGRectMake(0, 0, pulsingLayer.cornerRadius * 2, pulsingLayer.cornerRadius * 2);
        pulsingLayer.backgroundColor = [UIColor redColor].CGColor;//圈圈背景颜色，不设置则为透明。
        pulsingLayer.borderColor = [UIColor redColor].CGColor;
        pulsingLayer.borderWidth = 1.0;
        pulsingLayer.position  = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.fillMode = kCAFillModeBoth;
        //因为每个圈圈的大小不一致，故需要他们在一定的相位差的时刻开始运行。
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration/(double)pulsingCount;
        animationGroup.duration = animationDuration;//每个圈圈从生成到消失使用时常，也即动画组每轮动画持续时常
        animationGroup.repeatCount = HUGE_VAL;//表示动画组持续时间为无限大，也即动画无限循环。
        animationGroup.timingFunction = defaultCurve;
        
        //圆圈初始大小以及最终大小比率。
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithDouble:0.2];
        scaleAnimation.toValue = [NSNumber numberWithDouble:1.0];
        
        //圆圈在n个运行阶段的透明度，n为数组长度。
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        //运行四个阶段不同的透明度。
        opacityAnimation.values = @[[NSNumber numberWithDouble:1.0],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.3],[NSNumber numberWithDouble:0.0]];
        //运行的不同的四个阶段，为0.0表示刚运行，0.5表示运行了一半，1.0表示运行结束。
        opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:1.0]];
        //将两组动画（大小比率变化动画，透明度渐变动画）组合到一个动画组。
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:self.animationLayer];
}

// 动画因应用程序进入后台后会停止。故避免在重新激活程序时出现卡死假象。
- (void)resume{
    
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
        [self setNeedsDisplay];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - getter or setter
- (UILabel *)batteryCapacityLabel {
    if (!_batteryCapacityLabel) {
        _batteryCapacityLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - 60, self.height/2 - 20, 120, 40)];
        _batteryCapacityLabel.textColor = [UIColor whiteColor];
        _batteryCapacityLabel.font = [UIFont systemFontOfSize:30];
        _batteryCapacityLabel.backgroundColor = [UIColor clearColor];
        _batteryCapacityLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _batteryCapacityLabel;
}

- (UILabel *)batteryTimeLabel {
    if (!_batteryTimeLabel) {
        _batteryTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - 150, self.height - 25, 300, 20)];
        _batteryTimeLabel.textColor = [UIColor whiteColor];
        _batteryTimeLabel.font = [UIFont systemFontOfSize:17];
        _batteryTimeLabel.backgroundColor = [UIColor clearColor];
        _batteryTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _batteryTimeLabel;
}

#pragma mark - 这个方法有问题
- (void)startAnimation
{
    
    
    //    CALayer *layer = [[CALayer alloc] init];
    //    layer.cornerRadius = self.frame.size.height/2;
    //    layer.frame = CGRectMake(0, 0, layer.cornerRadius * 2, layer.cornerRadius * 2);
    //    layer.position  = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //    UIColor *color = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    //    layer.backgroundColor = color.CGColor;
    //    [self.layer addSublayer:layer];
    //
    //    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    //
    //    _animaTionGroup = [CAAnimationGroup animation];
    //    _animaTionGroup.delegate = self;
    //    _animaTionGroup.duration = 2;
    //    _animaTionGroup.removedOnCompletion = YES;
    //    _animaTionGroup.timingFunction = defaultCurve;
    //
    //    //大小
    //    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    //    scaleAnimation.fromValue = @0;
    //    scaleAnimation.toValue = @1.0;
    //    scaleAnimation.duration = 2;
    //
    //    //透明度
    //    CAKeyframeAnimation *opencityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    //    opencityAnimation.duration = 2;
    //    opencityAnimation.values = @[@0.8,@0.4,@0];
    //    opencityAnimation.keyTimes = @[@0,@0.5,@1];
    //    opencityAnimation.removedOnCompletion = YES;
    //
    //    NSArray *animations = @[scaleAnimation,opencityAnimation];
    //    _animaTionGroup.animations = animations;
    //    [layer addAnimation:_animaTionGroup forKey:nil];
    //
    //    [self performSelector:@selector(removeLayer:) withObject:layer afterDelay:2];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    NSLog(@"%@",dateTime);
}

- (void)removeLayer:(CALayer *)layer
{
    [layer removeFromSuperlayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAnimation)];
    _disPlayLink.frameInterval = 40;
    [_disPlayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.layer removeAllAnimations];
    [_disPlayLink invalidate];
    _disPlayLink = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
