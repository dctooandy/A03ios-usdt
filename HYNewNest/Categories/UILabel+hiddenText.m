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

@interface UILabel ()

@end

@implementation UILabel (hiddenText)

- (void)setOriginText:(NSString *)originText {
    objc_setAssociatedObject(self, &originTextKey, originText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.text = originText;
}

- (NSString *)originText {
    return objc_getAssociatedObject(self, &originTextKey);
}

- (void)hideOriginText {
    self.text = @"******";
}

- (void)showOriginText {
    if (self.originText != nil && self.originText.length > 0) {
        self.text = self.originText;
    } else {
        self.text = @"";
    }
}

@end
