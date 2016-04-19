//
//  TUMineCell.m
//  RedLine
//
//  Created by LXJ on 16/4/19.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUMineCell.h"

@interface  TUMineCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation TUMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInfo:(NSString *)title image:(NSString *)image {
    self.titleLabel.text = title;
    [self.headerImage setImage:[UIImage imageNamed:image]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
