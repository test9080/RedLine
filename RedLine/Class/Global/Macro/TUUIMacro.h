//
//  TUUIMacro.h
//  RedLine
//
//  Created by chengxianghe on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#ifndef TUUIMacro_h
#define TUUIMacro_h

// 屏幕大小
#define kScreenSize     [[UIScreen mainScreen] bounds].size

#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define kScreenOneScale (1.0 / [UIScreen mainScreen].scale)

#define kRGBA(r,g,b,a)           \
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#define kTUNotificationCenter  [NSNotificationCenter defaultCenter]
//#define kTUNotificationPost(name, object)  [kTUNotificationCenter postNotificationName:name object:#object]


#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

// tip
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#endif /* TUUIMacro_h */
