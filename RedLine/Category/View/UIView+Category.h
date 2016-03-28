//
//  UIView+Category.h
//  RedLine
//
//  Created by LXJ on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

- (void)roundWithCornerRadius:(CGFloat)radius;
- (void)roundToCircle;


@end
