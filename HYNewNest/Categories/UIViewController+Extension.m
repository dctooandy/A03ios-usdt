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
static NSString *navBarTransparentKey = @"navBarTransparentKey";
static NSString *navPopupBlockKey = @"navPopupBlockKey";


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

- (void)setNavBarTransparent:(BOOL)navBarTransparent
{
    objc_setAssociatedObject(self, &navBarTransparentKey, @(navBarTransparent), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)navBarTransparent
{
    return objc_getAssociatedObject(self, &navBarTransparentKey);
}

- (void)setNavPopupBlock:(void (^)(id))navPopupBlock
{
    objc_setAssociatedObject(self, &navPopupBlockKey, navPopupBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(id))navPopupBlock {
    return objc_getAssociatedObject(self, &navPopupBlockKey);
}

@end
