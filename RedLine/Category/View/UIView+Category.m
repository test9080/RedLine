//
//  UIView+Category.m
//  RedLine
//
//  Created by LXJ on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)w {
    CGRect rect = self.frame;
    rect.size.width = w;
    self.frame = rect;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)h {
    CGRect rect = self.frame;
    rect.size.height = h;
    self.frame = rect;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)roundWithCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)roundToCircle {
    [self roundWithCornerRadius:self.height / 2];
}

@end
