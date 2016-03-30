//
//  TUTabBar.m
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "TUTabBar.h"

#define kTabBarHeight   (49)
#define kTabAnimateImageHeight (40)
#define kTabAnimateImageWidthPecent (0.7)
#define kTabAnimateImageScale (1.8)
#define kTabAnimateImageTranslation (-10)
#define kTabLineColor   kRGBA(74, 173, 201, 1)


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
    
    CGFloat space = 4;
    CGFloat imageH = 20;
    CGFloat labelH = 10;
    CGFloat imageY = (kTabBarHeight - imageH - labelH - space) * 0.5;

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, imageY, width, imageH);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = imageView;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, imageY + imageH + space, width, labelH);
    label.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = label;
    
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.frame = CGRectMake(width - 10,  0, 10, 10);
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeLabel = badgeLabel;

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
    [self addTabLine];
    [self addAnimateView];
    self.tabConfig = [NSMutableDictionary dictionaryWithDictionary:[self defaultConfig]];
}

- (void)addAnimateView {
    UIView *view = [[UIView alloc] init];
    view.layer.borderColor = kTabLineColor.CGColor;
    view.layer.borderWidth = kScreenOneScale;
    self.animateView = view;
    [self addSubview:view];
}

- (void)addTabLine {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, -kScreenOneScale, CGRectGetWidth(self.bounds), kScreenOneScale);
    view.backgroundColor = kTabLineColor;
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

}

- (void)onItemViewClick:(UIButton *)sender {
    if (sender.tag != self.currentIndex) {
        NSUInteger from = self.currentIndex;
        NSUInteger to = sender.tag;

        self.currentIndex = sender.tag;

        if ([self.delegate respondsToSelector:@selector(tabBar:didSelectFrom:to:)]) {
            [self.delegate tabBar:self didSelectFrom:from to:to];
        }
        
        TUTabBarItemView *fromItemView = nil;
        TUTabBarItemView *toItemView = nil;

        if (from < _itemViews.count) {
            fromItemView = self.itemViews[from];
            fromItemView.imageView.image = self.items[from].unSelectImage;
        }
        
        if (to < _itemViews.count) {
            toItemView = self.itemViews[to];
            toItemView.imageView.image = self.items[to].selectImage;
        }
        
        
        UIFont *unSelectFont = self.tabConfig[keyTabBarItemUnSelectionTitleFont];
        UIColor *unSelectColor = self.tabConfig[keyTabBarItemUnSelectionTextColor];
        UIColor *unSelectBackColor = self.tabConfig[keyTabBarItemUnSelectionBackColor];
        
        fromItemView.isSelect = NO;
        fromItemView.titleLabel.font = unSelectFont;
        fromItemView.titleLabel.textColor = unSelectColor;
        fromItemView.backgroundColor = unSelectBackColor;
        
        
        UIFont *selectFont = self.tabConfig[keyTabBarItemSelectionTitleFont];
        UIColor *selectColor = self.tabConfig[keyTabBarItemSelectionTextColor];
        UIColor *selectBackColor = self.tabConfig[keyTabBarItemSelectionBackColor];
        
        toItemView.isSelect = YES;
        toItemView.titleLabel.font = selectFont;
        toItemView.titleLabel.textColor = selectColor;
        toItemView.backgroundColor = selectBackColor;
        
        CGFloat animateW = CGRectGetWidth(self.animateView.frame);
        CGFloat itemW = CGRectGetWidth(toItemView.frame);
        CGFloat offSetW = (itemW - animateW) * 0.5;
        
        CGRect toFrame = self.animateView.frame;
        toFrame.origin.x = itemW * to + offSetW;
        
        @weakify(self);
        
//        fromItemView.imageView.alpha = 0.1;
//        [UIView animateWithDuration:0.3 animations:^{
//            CGAffineTransform from = CGAffineTransformMakeScale(1, 1);
//            fromItemView.imageView.transform = from;
//            fromItemView.imageView.alpha = 1;
//
//        } completion:^(BOOL finished) {
//            fromItemView.imageView.transform = CGAffineTransformIdentity;
//        }];
        
        fromItemView.imageView.alpha = 0.1;
        
        // usingSpringWithDamping 抖动系数 越小抖的越厉害
        // initialSpringVelocity 动画初始速度
        CGFloat damp = 0.75;
        if (from == NSNotFound) {
            damp = 10;
        } else {
            damp = 0.71 + 0.04 * abs((int)(to - from));
        }
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:damp initialSpringVelocity:5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            fromItemView.imageView.transform = CGAffineTransformIdentity;
            fromItemView.imageView.alpha = 1;
            toItemView.imageView.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, kTabAnimateImageTranslation), kTabAnimateImageScale, kTabAnimateImageScale);
            
            weak_self.animateView.frame = toFrame;
            
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    NSLog(@"%s", __func__);
}

- (NSDictionary *)defaultConfig {
    return @{
             keyTabBarItemSelectionTextColor    : [UIColor whiteColor],
             keyTabBarItemUnSelectionTextColor  : [UIColor whiteColor],
             keyTabBarItemSelectionTitleFont    : [UIFont systemFontOfSize:11.0],
             keyTabBarItemUnSelectionTitleFont  : [UIFont systemFontOfSize:11.0],
             keyTabBarItemSelectionBackColor    : kRGBA(51, 59, 98, 1),
             keyTabBarItemUnSelectionBackColor  : kRGBA(51, 59, 98, 1),
             };
}

@end
