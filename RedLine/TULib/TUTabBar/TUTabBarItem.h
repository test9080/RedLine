//
//  TUTabBarItem.h
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TUTabBarItem : NSObject

@property (nonatomic,   copy) NSString    *title;
@property (nonatomic, strong) UIImage     *selectImage;
@property (nonatomic, strong) UIImage     *unSelectImage;

@end
