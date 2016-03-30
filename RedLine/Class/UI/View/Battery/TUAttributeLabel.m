//
//  TUAttributeLabel.m
//  RedLine
//
//  Created by LXJ on 16/3/30.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUAttributeLabel.h"
#import <CoreText/CoreText.h>

@implementation TUAttributeLabel


- (void)addTextFont:(UIFont *)font range:(NSRange)range
{
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSMutableAttributedString *as = [self returnLabelAttributedString];
    [as removeAttribute:NSFontAttributeName range:range];
    [as addAttribute:NSFontAttributeName value:(__bridge id)(ctFont) range:range];
    self.attributedText = as;
    CFRelease(ctFont);
}

- (NSMutableAttributedString *)returnLabelAttributedString
{
    if (self.attributedText) {
        return [self.attributedText mutableCopy];
    }else if(self.text){
        return [[NSMutableAttributedString alloc]initWithString:self.text];
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
