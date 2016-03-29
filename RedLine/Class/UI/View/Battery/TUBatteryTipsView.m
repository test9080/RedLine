//
//  TUBatteryTipsView.m
//  RedLine
//
//  Created by LXJ on 16/3/27.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUBatteryTipsView.h"
#import "UIView+Category.h"

#define kButtonWH (30)

@interface TUBatteryTipsView ()

@property (assign, nonatomic) NSInteger buttonCount;
@end

@implementation TUBatteryTipsView

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.buttonCount = count;
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat margin = (kScreenWidth - kButtonWH * self.buttonCount) / (self.buttonCount+1);

    for (int i = 0; i < self.buttonCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        button.frame = CGRectMake(margin + (margin + kButtonWH) * i, 0, kButtonWH, kButtonWH);
        [button roundToCircle];
        button.tag = i;
        [button addTarget:self action:@selector(tipsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)tipsBtnClicked:(UIButton *)button {
    NSLog(@"tipsTag:%ld",(long)button.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
