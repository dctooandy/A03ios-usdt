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


#define KColorRGBVal(rgbValue)   [UIColor \colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define KColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define KRandomColor KColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#define KImageName(name)            [UIImage imageNamed:name]
#define KIsEmptyString(string)      (([string isKindOfClass:[NSNull class]] || string == nil || [string length] == 0 || [string isEqualToString:@"(null)"]) ? YES : NO)
#define KSafeString(string)         IsEmptyString(string)?@"":string
#define AD(width)                   ((width)*IPHONE_WIDTH/375.0)


#define WEAKSELF_DEFINE     __weak __typeof(self)weakSelf = self;
#define STRONGSELF_DEFINE   __strong __typeof(weakSelf)strongSelf = weakSelf;
#define KWeakObj(type)      __weak typeof(type) weak##type = type;
#define KStrongObj(type)    __strong typeof(type) strong##type = type;



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
