//
//  NNControllerHelper.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/26.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kCurNavVC [NNControllerHelper currentTabbarSelectedNavigationController]

@interface NNControllerHelper : NSObject


/// 改变appdelegate的window的根控制器
/// @param vc 新的根控制器
+ (void)changeRootVc:(UIViewController *)vc;


/// push前销毁导航栈顶控制器
+(void)deallocLastVcAfterPush:(UIViewController *)vc;


/// 当前tabbar控制器
+(UITabBarController *)currentTabBarController;


/// 当前tabbar下的导航控制器
+(UINavigationController *)currentTabbarSelectedNavigationController;


/// 当前tabbar下的导航控制器下的根控制器
+(UIViewController*)currentRootVcOfNavController;


/// 当前顶部控制器
+ (UIViewController *)getCurrentViewController;


/// pop到某个控制器
+ (BOOL)pop2ViewControllerClassString:(NSString *)className;
+ (BOOL)pop2ViewControllerClass:(Class)aClass;


@end

NS_ASSUME_NONNULL_END
