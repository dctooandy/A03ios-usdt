//
//  GlobalConstant.h
//  PrizeLottery
//
//  Created by Design on 2019/4/26.
//  Copyright © 2019 xunti.com. All rights reserved.
//

#ifndef GlobalConstant_h
#define GlobalConstant_h

#import "MacroConfigure.h"


//APP参数
#define kBundleName         [NSBundle mainBundle].infoDictionary[@"CFBundleName"]
#define kDisplayName        [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"]
#define kPackageName        [NSBundle mainBundle].infoDictionary[@"PackageName"]
#define kBuglyAppID         [NSBundle mainBundle].infoDictionary[@"BUGLY.APP_ID"]
#define kSystemVersionFloat [[[UIDevice currentDevice] systemVersion] floatValue]
#define kKeywindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        (AppDelegate *)[UIApplication sharedApplication].delegate


//屏幕宽高
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
//判断iPhone机型
#define kIsiphone4x_3_5         ([UIScreen mainScreen].bounds.size.height==480.0f)
#define kIsiphone5x_4_0         ([UIScreen mainScreen].bounds.size.height==568.0f)
#define kIsiphone6_4_7          ([UIScreen mainScreen].bounds.size.height==667.0f)
#define kIsiphone6Plus_5_5      ([UIScreen mainScreen].bounds.size.height==736.0f || [UIScreen mainScreen].bounds.size.height==414.0f)
#define kIsPad                ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define kIsiPhone5            ([[UIScreen mainScreen]bounds].size.height == 568)
#define KIsIphoneXSeries  (([[UIApplication sharedApplication] statusBarFrame].size.height == 44.0f) ? (YES):(NO))
//导航栏高度
#define kNavBarHeight  44.f
//底部Tabbar 高度
#define kTabBarHeight  49.f
//安全区域高度
#define kSafeAreaHeight  (KIsIphoneXSeries ? 34.f : 0.f)
//状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//顶部高度
#define kNavPlusStatusBarHeight (KNavBarHeight+KStatusBarHeight)






#endif /* GlobalConstant_h */
