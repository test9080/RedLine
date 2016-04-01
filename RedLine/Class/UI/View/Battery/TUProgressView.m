//
//  TUProgressView.m
//  ProgressAnimationDemo
//
//  Created by LXJ on 16/3/30.
//  Copyright © 2016年 LianLuo. All rights reserved.
//

#import "TUProgressView.h"
#import "UIView+Category.h"

@interface TUProgressView()

@property (strong, nonatomic) UIView *progressBarView;
@property (strong, nonatomic) UIView *dotView;

@property (nonatomic) NSTimeInterval barAnimationDuration;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation TUProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureViews];
}

-(void)configureViews {
    self.userInteractionEnabled = NO;
//    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:CGRectMake(-1, 1, 1, 2)];
//    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIColor *tintColor = [UIColor colorWithRGB:0xff5fb7ce];
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 2.f;
    
    _dotView = [[UIView alloc] initWithFrame:CGRectMake(-8, -2, 8, 8)];
    [_dotView roundToCircle];
    _dotView.backgroundColor = tintColor;
    [self addSubview:_dotView];
    
    _dotView.alpha = 0;
    _progressBarView.alpha = 0;
    _dotView.transform = CGAffineTransformIdentity;

}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    
    BOOL isGrowing = progress > 0.0;
    _dotView.alpha = isGrowing ? 1 : 0;
    _progressBarView.alpha = _dotView.alpha;
    _dotView.transform = CGAffineTransformMakeScale(1.5, 1.0);

    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = ceil(progress * self.bounds.size.width);
        _progressBarView.frame = frame;
        _dotView.x = frame.size.width-2;
        _dotView.transform = CGAffineTransformMakeScale(1.3, 1.2);
    } completion:^(BOOL finished) {
        CGRect frame = _progressBarView.frame;
        frame.size.width = 1;
        _progressBarView.frame = frame;
        _dotView.x = -8;
        _dotView.alpha = isGrowing ? 0 : 1;
        _progressBarView.alpha = _dotView.alpha;
        _dotView.transform = CGAffineTransformIdentity;
        _isAnimating = NO;
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
