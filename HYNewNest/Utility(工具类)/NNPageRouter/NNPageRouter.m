//
//  NNPageRouter.m
//  HYNewNest
//
//  Created by zaky on 03/07/2020.
//  Copyright © 2020 james. All rights reserved.
//

#import "NNPageRouter.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation NNPageRouter

+ (void)jump2MainPage {

//        HYTabBarViewController *tabVC = [[HYTabBarViewController alloc] init];
    ViewController *vc = [[ViewController alloc] init];
    [kAppDelegate changeRootViewController:vc];
}

+ (void)deallocLastVcAfterPush:(UIViewController *)vc {
    NSMutableArray* navArray = [[NSMutableArray alloc] initWithArray:kCurNavVC.viewControllers];
    [navArray replaceObjectAtIndex:[navArray count]-1 withObject:vc];
    [kCurNavVC setViewControllers:navArray animated:YES];
}

//MARK: - OTHER
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

+(UIViewController*)currentViewController{
    UINavigationController *selectedNV = [self currentTabbarSelectedNavigationController];
    if (selectedNV.viewControllers.count > 0) {
        return [selectedNV.viewControllers lastObject];
    }
    return nil;
}
@end
