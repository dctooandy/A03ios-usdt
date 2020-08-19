//
//  UILabel+Indicator.m
//  HYNewNest
//
//  Created by zaky on 8/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "UILabel+Indicator.h"

#import <objc/runtime.h>

static NSString *kIndicatorKey = @"IndicatorKey";

@implementation UILabel (Indicator)

- (void)setIsIndicating:(BOOL)isIndicating {
    objc_setAssociatedObject(self, &kIndicatorKey, @(isIndicating), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isIndicating {
    return objc_getAssociatedObject(self, &kIndicatorKey);
}

/** 显示菊花 */
- (void)showIndicatorIsBig:(BOOL)isBig{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIActivityIndicatorView class]] && subView.tag == 8888) {
            return;
        }
    }
    
    self.text = @"      ";
    self.isIndicating = YES;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:isBig?UIActivityIndicatorViewStyleWhiteLarge:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2 , self.bounds.size.height / 2);;
    [indicator startAnimating];
    indicator.tag = 8888;
    [self addSubview:indicator];
    
   
}

- (void)hideIndicator {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIActivityIndicatorView class]] && subView.tag == 8888) {
            subView.hidden = YES;
        }
    }
}


/** 隐藏菊花 */
- (void)hideIndicatorWithText:(NSString *)text{
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIActivityIndicatorView class]] && subView.tag == 8888) {
            [subView removeFromSuperview];
        }
    }
    
    self.isIndicating = NO;
    self.originText = text;
}

@end
