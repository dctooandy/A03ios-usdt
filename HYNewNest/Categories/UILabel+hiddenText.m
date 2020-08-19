//
//  UILabel+hiddenText.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/27.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "UILabel+hiddenText.h"
#import <objc/runtime.h>

static NSString *originTextKey = @"originTextKey";
static NSString *kIsHiddenKey  = @"kIsHiddenKey";

@interface UILabel ()

@end

@implementation UILabel (hiddenText)

- (void)setOriginText:(NSString *)originText {
    objc_setAssociatedObject(self, &originTextKey, originText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.isOriginTextHidden) {
        self.text = originText;
    }
}

- (NSString *)originText {
    return objc_getAssociatedObject(self, &originTextKey);
}

- (void)setIsOriginTextHidden:(BOOL)isOriginTextHidden {
    objc_setAssociatedObject(self, &kIsHiddenKey, @(isOriginTextHidden), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isOriginTextHidden {
    return objc_getAssociatedObject(self, &kIsHiddenKey);
}



- (void)hideOriginText {
    self.isOriginTextHidden = YES;
//    if (self.isIndicating) {
//        [self hideIndicator];
//    }
    self.text = @"*****";
}

- (void)showOriginText {
    if (self.originText != nil && self.originText.length > 0) {
        self.text = self.originText;
    } else {
        self.text = @"";
    }
    self.isOriginTextHidden = NO;
    
//    if (self.isIndicating) {
//        [self showIndicatorIsBig:NO];
//    }
}

@end
