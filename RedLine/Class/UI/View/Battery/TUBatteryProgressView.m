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
@property (weak, nonatomic) IBOutlet UIImageView *secondIconImage;
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
    self.bgLabel.backgroundColor = [UIColor colorWithRGB:0xff80a7ce];
    _progressView = [[TUProgressView alloc] initWithFrame:CGRectMake(self.bgLabel.frame.origin.x, 27, self.width - 60, 4)];
//    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.progressView];

    [self insertSubview:self.secondImage aboveSubview:_progressView];
    [self insertSubview:self.secondIconImage aboveSubview:self.secondIconImage];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgLabel.mas_left);
        make.width.mas_equalTo(self.mas_width).mas_offset(-60);
        make.height.mas_equalTo(4);
        make.top.mas_equalTo(13);
    }];
    
}

- (void)updateProgress:(CGFloat)progress {
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
