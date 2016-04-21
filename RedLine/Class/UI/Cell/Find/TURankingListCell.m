//
//  TURankingListCell.m
//  RedLine
//
//  Created by LXJ on 16/4/21.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TURankingListCell.h"

@interface TURankingListCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankingNumLabel;

@end

@implementation TURankingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(BOOL)isSelf {
    self.nameLabel.text = @"小花";
    self.rankingNumLabel.text = @"第28名";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
