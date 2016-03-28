//
//  TUTabBar.m
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUTabBar.h"

#define kTabBarHeight   (49)
#define kTabImageHeight (28)
#define kTabAnimateImageHeight (40)
#define kTabAnimateImageWidthPecent (0.7)

@interface TUTabBarItemView : UIView

@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIImageView   *imageView;
//@property (nonatomic, strong) UILabel *backView;
@property (nonatomic, strong) UIButton      *button;
@property (nonatomic, assign) BOOL          isSelect; // default is false
@property (nonatomic, assign) BOOL          isAnimate; // default is true
//@property (nonatomic, assign) CGFloat       space;
@property (nonatomic,   copy) NSString      *badgeValue;
@property (nonatomic, strong) UILabel       *badgeLabel;
@end

@implementation TUTabBarItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    CGFloat width = CGRectGetWidth(self.frame);
//    CGFloat height = CGRectGetHeight(self.frame);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, kTabImageHeight + 2, width, kTabBarHeight - kTabImageHeight);
    label.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = label;
    
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.frame = CGRectMake(width - 10,  0, 10, 10);
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeLabel = badgeLabel;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, width, kTabImageHeight);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = imageView;
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = self.bounds;
    self.button = button;
    
    [self addSubview:label];
    [self addSubview:badgeLabel];
    [self addSubview:imageView];
    [self addSubview:button];
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    if (badgeValue == nil) {
        _badgeLabel.hidden = YES;
    } else {
        _badgeLabel.hidden = NO;
        _badgeLabel.text = badgeValue;
    }
}

@end

@interface TUTabBar ()

@property (nonatomic, strong) NSMutableArray <__kindof TUTabBarItemView *> *itemViews;
@property (nonatomic, strong) NSMutableArray <__kindof TUTabBarItem *> *items;
@property (nonatomic, strong) UIView *animateView;
@property (nonatomic, strong) NSMutableDictionary *tabConfig;
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation TUTabBar

- (instancetype)initWithItems:(NSArray<__kindof TUTabBarItem *> *)items frame:(CGRect)frame {
    
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)) {
        frame = CGRectMake(0, kScreenHeight - kTabBarHeight, kScreenWidth, kTabBarHeight);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFirst];
        [self setupItems:items];
    }
    return self;
}

- (void)setTabBarConfig:(NSDictionary *)config {

    for (NSString *key in [config allKeys]) {
        [self.tabConfig setObject:config[key] forKey:key];
    }
}

- (void)setBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index {
    if (index < self.itemViews.count) {
        TUTabBarItemView *itemView = self.itemViews[index];
        itemView.badgeValue = badgeValue;
    }
}

- (void)setSelectIndex:(NSUInteger)index {
    if (index < self.itemViews.count) {
        TUTabBarItemView *itemView = self.itemViews[index];
        [self onItemViewClick:itemView.button];
    }
}

- (NSUInteger)currentIndex {
    return _currentIndex;
}

- (void)setupFirst {
    NSLog(@"%s", __func__);
    self.itemViews = [NSMutableArray array];
    self.items = [NSMutableArray array];
    self.currentIndex = NSNotFound;
    [self addAnimateView];
    self.tabConfig = [NSMutableDictionary dictionaryWithDictionary:[self defaultConfig]];
}

- (void)addAnimateView {
    UIView *view = [[UIView alloc] init];
    self.animateView = view;
    [self addSubview:view];
}

- (void)setupItems:(NSArray<__kindof TUTabBarItem *> *)items {
    
    [self.items addObjectsFromArray:items];
    
    CGFloat width = kScreenWidth/items.count;
    CGFloat height = CGRectGetHeight(self.frame);
    
    UIFont *unSelectFont = self.tabConfig[keyTabBarItemUnSelectionTitleFont];
    UIColor *unSelectColor = self.tabConfig[keyTabBarItemUnSelectionTextColor];
    UIColor *unSelectBackColor = self.tabConfig[keyTabBarItemUnSelectionBackColor];

//    CGFloat space = [self.tabConfig[keyTabBarItemContentVerticalMargin] floatValue];

    for (int i = 0; i < items.count; i ++) {
        CGFloat x = i * width;
        TUTabBarItemView *itemView = [[TUTabBarItemView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
//        itemView.space = space;
        [itemView.button addTarget:self action:@selector(onItemViewClick:) forControlEvents:UIControlEventTouchUpInside];
        itemView.button.tag = i;
        itemView.titleLabel.text = items[i].title;
        itemView.titleLabel.font = unSelectFont;
        itemView.titleLabel.textColor = unSelectColor;
        itemView.imageView.image = items[i].unSelectImage;
        itemView.backgroundColor = unSelectBackColor;
        [self.itemViews addObject:itemView];
        [self addSubview:itemView];
    }
    
    CGFloat animateW = width * kTabAnimateImageWidthPecent;
    
    self.animateView.frame = CGRectMake(animateW * kTabAnimateImageWidthPecent, -animateW * 0.35, animateW, animateW);
    self.animateView.backgroundColor = self.tabConfig[keyTabBarItemSelectionBackColor];
    self.animateView.layer.cornerRadius = animateW * 0.5;
    self.animateView.clipsToBounds = YES;
//    [self bringSubviewToFront:self.animateView];


}

- (void)onItemViewClick:(UIButton *)sender {
    if (sender.tag != self.currentIndex) {
        NSUInteger from = self.currentIndex;
        NSUInteger to = sender.tag;

        self.currentIndex = sender.tag;

        if ([self.delegate respondsToSelector:@selector(tabBarDidSelectFrom:to:)]) {
            [self.delegate tabBarDidSelectFrom:from to:to];
        }
        
        if (from < _itemViews.count) {
            UIFont *unSelectFont = self.tabConfig[keyTabBarItemUnSelectionTitleFont];
            UIColor *unSelectColor = self.tabConfig[keyTabBarItemUnSelectionTextColor];
            UIColor *unSelectBackColor = self.tabConfig[keyTabBarItemUnSelectionBackColor];

            TUTabBarItemView *itemView = self.itemViews[from];
            itemView.isSelect = NO;
            itemView.titleLabel.font = unSelectFont;
            itemView.titleLabel.textColor = unSelectColor;
            itemView.backgroundColor = unSelectBackColor;
            itemView.imageView.image = self.items[from].unSelectImage;
        }
        
        if (to < _itemViews.count) {
            UIFont *selectFont = self.tabConfig[keyTabBarItemSelectionTitleFont];
            UIColor *selectColor = self.tabConfig[keyTabBarItemSelectionTextColor];
            UIColor *selectBackColor = self.tabConfig[keyTabBarItemSelectionBackColor];

            TUTabBarItemView *itemView = self.itemViews[to];
            itemView.isSelect = YES;
            itemView.titleLabel.font = selectFont;
            itemView.titleLabel.textColor = selectColor;
            itemView.backgroundColor = selectBackColor;
            itemView.imageView.image = self.items[to].selectImage;
            
            // usingSpringWithDamping 抖动系数 越小抖的越厉害
            // initialSpringVelocity 动画初始速度
            CGFloat animateW = CGRectGetWidth(self.animateView.frame);
            CGFloat itemW = CGRectGetWidth(itemView.frame);
            CGFloat offSetW = (itemW - animateW) * 0.5;
            
            CGRect toFrame = self.animateView.frame;
            toFrame.origin.x = itemW * to + offSetW;
            
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.animateView.frame = toFrame;
                //            imageView.frame = oldframe;
                //        backgroundView.alpha = 0;
            } completion:^(BOOL finished) {
                //            [backgroundView removeFromSuperview];
                
            }];
        }

    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    NSLog(@"%s", __func__);
}

- (NSDictionary *)defaultConfig {
    return @{keyTabBarItemContentVerticalMargin : @6,
             keyTabBarItemSelectionTextColor    : [UIColor whiteColor],
             keyTabBarItemUnSelectionTextColor  : [UIColor whiteColor],
             keyTabBarItemSelectionTitleFont    : [UIFont systemFontOfSize:14.0],
             keyTabBarItemUnSelectionTitleFont  : [UIFont systemFontOfSize:14.0],
             keyTabBarItemSelectionBackColor    : kRGBA(51, 59, 98, 1),
             keyTabBarItemUnSelectionBackColor  : kRGBA(51, 59, 98, 1),
             };
}

@end
