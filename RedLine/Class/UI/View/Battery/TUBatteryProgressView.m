//
//  TUBatteryProgressView.m
//  RedLine
//
//  Created by LXJ on 16/3/28.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryProgressView.h"
#import "UIView+Category.h"
#import "UIColor+GGColor.h"

#define LOAD_NIB(name) [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject]

@interface TUBatteryProgressView ()
{
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;

@end

@implementation TUBatteryProgressView

+ (TUBatteryProgressView *)showProgressView {
    return LOAD_NIB(@"TUBatteryProgressView");
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    [self setup];
}

- (void)setup {
    [self.firstImage roundToCircle];
    [self.secondImage roundToCircle];
    [self.thirdImage roundToCircle];
    
    self.firstImage.backgroundColor = [UIColor colorWithRGB:0xff60b1ce];
    self.secondImage.backgroundColor = [UIColor colorWithRGB:0xff60b1ce];
    self.thirdImage.backgroundColor = [UIColor colorWithRGB:0xff60b1ce];
    
    [self.progressView setProgressTintColor:[UIColor colorWithARGB:0xff60b6cf]];
//    [self.progressView setTrackTintColor:[UIColor colorWithARGB:0xff81a6c1]];
    [self.progressView setProgress:0.0f];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)next {
    self.progressView.progress = self.progressView.progress + 0.01;
    // 进度条走完 销毁定时器
    if (self.progressView.progress == 1.0) {
        [_timer invalidate];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
