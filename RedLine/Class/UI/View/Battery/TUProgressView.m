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
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progressBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 1, 2)];
    _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIColor *tintColor = [UIColor colorWithRGB:0xff5fb7ce];
    _progressBarView.backgroundColor = tintColor;
    [self addSubview:_progressBarView];
    
    _barAnimationDuration = 2.f;
    
    _dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    [_dotView roundToCircle];
    _dotView.backgroundColor = tintColor;
    [self addSubview:_dotView];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        _progressBarView.frame = frame;
        _dotView.x = frame.size.width;
    } completion:^(BOOL finished) {
        CGRect frame = _progressBarView.frame;
        frame.size.width = 1;
        _progressBarView.frame = frame;
        _dotView.x = 0;
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
