//
//  BYGradientButton.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/14.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGradientButton.h"

@implementation BYGradientButton

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
- (void)setStartColor:(UIColor *)startColor {
    if (startColor != self.startColor) {
        _startColor = startColor;
        UIImage *image = [UIColor gradientImageFromColors:@[self.startColor, self.endColor]
                                             gradientType:GradientTypeLeftToRight
                                                  imgSize:self.frame.size];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        
        image = [UIColor gradientImageFromColors:@[[self.startColor colorWithAlphaComponent:0.8], [self.endColor colorWithAlphaComponent:0.8]]
                                    gradientType:GradientTypeLeftToRight
                                         imgSize:self.frame.size];
        [self setBackgroundImage:image forState:UIControlStateDisabled];
    }
}

- (void)setEndColor:(UIColor *)endColor {
    if (endColor != self.endColor) {
        _endColor = endColor;
        UIImage *image = [UIColor gradientImageFromColors:@[self.startColor, self.endColor]
                                             gradientType:GradientTypeLeftToRight
                                                  imgSize:self.frame.size];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        
        image = [UIColor gradientImageFromColors:@[[self.startColor colorWithAlphaComponent:0.8], [self.endColor colorWithAlphaComponent:0.8]]
                                    gradientType:GradientTypeLeftToRight
                                         imgSize:self.frame.size];
        [self setBackgroundImage:image forState:UIControlStateDisabled];
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
    self.backgroundColor = UIColor.clearColor;
    _startColor = UIColor.clearColor;
    _endColor = UIColor.clearColor;
    _cornerRadius = 0;
    self.layer.masksToBounds = true;
}

@end
