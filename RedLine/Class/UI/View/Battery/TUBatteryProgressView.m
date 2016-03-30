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
#import "TUProgressView.h"

#define LOAD_NIB(name) [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject]

@interface TUBatteryProgressView ()
{
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

@property (strong, nonatomic) TUProgressView *progressView;

@end

@implementation TUBatteryProgressView

+ (TUBatteryProgressView *)showProgressView {
    return LOAD_NIB(@"TUBatteryProgressView");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
//    [self setup];
}

- (void)setup {
    [self.firstImage roundToCircle];
    [self.secondImage roundToCircle];
    [self.thirdImage roundToCircle];
    
    self.firstImage.backgroundColor = [UIColor colorWithRGB:0xff60b1ce];
    self.secondImage.backgroundColor = [UIColor colorWithRGB:0xff60b1ce];
    self.thirdImage.backgroundColor = [UIColor colorWithRGB:0xff60b1ce];
    
    _progressView = [[TUProgressView alloc] initWithFrame:CGRectMake(self.bgLabel.frame.origin.x, 27, self.width - 60, 4)];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.progressView];
}

- (void)updateProgress:(CGFloat)progress {
    NSLog(@"hahahaah");
    
    [_progressView setProgress:progress animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
