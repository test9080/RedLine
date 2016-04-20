//
//  TUFindCell.m
//  RedLine
//
//  Created by LXJ on 16/4/20.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUFindCell.h"

@interface TUFindCell ()

@property (weak, nonatomic) IBOutlet UIView *actionView;

@end

@implementation TUFindCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

//- (void)setInfoWithRow:(NSInteger)row {
//    if (row == 0) {
//        self.actionView.hidden = YES;
//    } else {
//        self.actionView.hidden = NO;
//    }
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
