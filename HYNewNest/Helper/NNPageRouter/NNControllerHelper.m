//
//  NNControllerHelper.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/26.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "NNControllerHelper.h"
#import "AppDelegate.h"

@implementation NNControllerHelper


+ (void)changeRootVc:(UIViewController *)vc {
    [kAppDelegate changeRootViewController:vc];
}

+ (void)deallocLastVcAfterPush:(UIViewController *)vc {
    NSMutableArray* navArray = [[NSMutableArray alloc] initWithArray:kCurNavVC.viewControllers];
    [navArray replaceObjectAtIndex:[navArray count]-1 withObject:vc];
    [kCurNavVC setViewControllers:navArray animated:YES];
}

+(UITabBarController *)currentTabBarController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabbarController;
    }
    return nil;
}

+(UINavigationController *)currentTabbarSelectedNavigationController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootVC = window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    }else if([rootVC isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabarController = [self currentTabBarController];
        UINavigationController *selectedNV = (UINavigationController *)tabarController.selectedViewController;
        if ([selectedNV isKindOfClass:[UINavigationController class]]) {
            return selectedNV;
        }
    }

    return nil;
}

+(UIViewController*)currentRootVcOfNavController{
    UINavigationController *selectedNV = [self currentTabbarSelectedNavigationController];
    if (selectedNV.viewControllers.count > 0) {
        return [selectedNV.viewControllers lastObject];
    }
    return nil;
}

+ (UIViewController *)getCurrentViewController{
    UIViewController* currentViewController = UIApplication.sharedApplication.keyWindow .rootViewController;
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
    }    return currentViewController;
}

+ (BOOL)pop2ViewControllerClassString:(NSString *)className {
    Class theClass = NSClassFromString(className);
    NSAssert(theClass, @"theClass you named is not exist");
    return [self pop2ViewControllerClass:theClass];
}

+ (BOOL)pop2ViewControllerClass:(Class)aClass {
    for (UIViewController *controller in kCurNavVC.viewControllers) {
        if ([controller isKindOfClass:aClass]) {
            UIViewController *A = (UIViewController *)controller;
            [kCurNavVC popToViewController:A animated:YES];
            return YES;
        }
    }
    return NO;
}

@end
