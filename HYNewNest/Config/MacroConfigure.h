//
//  MacroConfigure.h
//  PrizeLottery
//
//  Created by Design on 2019/4/26.
//  Copyright © 2019 xunti.com. All rights reserved.
//

#ifndef MacroConfigure_h
#define MacroConfigure_h


#ifdef DEBUG // 处于开发阶段
#define NSLog(FORMAT, ...) fprintf(stderr, "%s [Line %d]\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#define MyLog(...) NSLog(__VA_ARGS__)
#else //处于发布阶段
#define NSLog(FORMAT, ...) nil
#define MyLog(...)
#endif

/** 十六进制颜色 */
#define kHexColorAlpha(value, a)    [UIColor colorWithRed:((float)(((value) & 0xFF0000) >> 16))/255.0 green:((float)(((value) & 0xFF00) >> 8))/255.0 blue:((float)((value) & 0xFF))/255.0 alpha:(a)]

#define kHexColor(value)            kHexColorAlpha(value, 1.0)

#define KColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define KRandomColor KColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#define KImageName(name)            [UIImage imageNamed:name]
#define KIsEmptyString(string)      (([string isKindOfClass:[NSNull class]] || string == nil || [string length] == 0 || [string isEqualToString:@"(null)"]) ? YES : NO)
#define KSafeString(string)         IsEmptyString(string)?@"":string
#define AD(width)                   ((width)*kScreenWidth/375.0)
#define NSNumberAddInt(num, i) num = @( num.floatValue + i )
#define NSNumberMultiplyInt(num, i) num = @( num.floatValue * i )


#define WEAKSELF_DEFINE     __weak __typeof(self)weakSelf = self;
#define STRONGSELF_DEFINE   __strong __typeof(weakSelf)strongSelf = weakSelf;
#define KWeakObj(type)      __weak typeof(type) weak##type = type;
#define KStrongObj(type)    __strong typeof(type) strong##type = type;


#define kPreventRepeatTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
});


#define KSetStatusBarBGColor(UIColor)   UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];\
if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {\
    statusBar.backgroundColor = (UIColor);\
}

#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})


// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


#endif /* MacroConfigure_h */
