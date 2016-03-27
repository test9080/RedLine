//
//  TUBatteryHeaderView.m
//  RedLine
//
//  Created by LXJ on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryHeaderView.h"
#import "UIView+Category.h"

@interface TUBatteryHeaderView ()

@property (strong, nonatomic) UILabel *stateLabel;

@end

@implementation TUBatteryHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addSubview:self.stateLabel];
}


#pragma mark - setter & getter
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - 100, 10, 200, 30)];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = [UIFont systemFontOfSize:18];
        _stateLabel.text = @"已开启全面保护模式";
        
        [_stateLabel.layer setMasksToBounds:YES];
        [_stateLabel.layer setCornerRadius:18.0]; //设置矩形四个圆角半径
        [_stateLabel.layer setBorderWidth:1.0]; //边框宽度
        [_stateLabel.layer setBorderColor:[UIColor whiteColor].CGColor];//边框颜色

    }
    return _stateLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
