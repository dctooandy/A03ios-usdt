//
//  UIViewController+Extension.m
//  UtilityToolComponentOC
//
//  Created by carey on 2019/4/27.
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>


static NSString *bgColorKey = @"bgColorKey";
static NSString *makeTranslucentKey = @"makeTranslucentKey";
static NSString *hideNavgationKey = @"hideNavgationKey";


@implementation UIViewController (Extension)

@dynamic bgColor;

- (void)setBgColor:(UIColor *)bgColor
{
    objc_setAssociatedObject(self, &bgColorKey, bgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)bgColor
{
    return objc_getAssociatedObject(self, &bgColorKey);
}

- (void)setMakeTranslucent:(BOOL)makeTranslucent
{
    objc_setAssociatedObject(self, &makeTranslucentKey, @(makeTranslucent), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)makeTranslucent
{
    return objc_getAssociatedObject(self, &makeTranslucentKey);
}

- (void)setHideNavgation:(BOOL)hideNavgation
{
    objc_setAssociatedObject(self, &hideNavgationKey, @(hideNavgation), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hideNavgation
{
    return [objc_getAssociatedObject(self, &hideNavgationKey) boolValue];
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

@end
