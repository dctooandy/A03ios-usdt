//
//  BYBorderButton.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/14.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYBorderButton.h"

@implementation BYBorderButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -
#pragma mark Init
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDefault];
    }
    return self;
}

#pragma mark -
#pragma mark Setter
- (void)setBorderColor:(UIColor *)borderColor {
    if (borderColor != self.borderColor ) {
        _borderColor = borderColor;
        self.layer.borderColor = self.borderColor.CGColor;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth != self.borderWidth) {
        _borderWidth = borderWidth;
        self.layer.borderWidth = self.borderWidth;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (cornerRadius != self.cornerRadius) {
        _cornerRadius = cornerRadius;
        self.layer.cornerRadius = self.cornerRadius;
    }
    
}

#pragma mark -
#pragma mark Custom Method
- (void)setupDefault {
    _borderColor = UIColor.clearColor;
    _borderWidth = 0;
    _cornerRadius = 0;
    
    self.layer.masksToBounds = true;
    
}

@end
