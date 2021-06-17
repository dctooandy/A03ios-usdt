//
//  BYGradientView.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/13.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGradientView.h"

@interface BYGradientView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *shapLayer;

@end

@implementation BYGradientView
@synthesize gradientLayer;

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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayer];
}

#pragma mark -
#pragma mark Setter
- (void)setStartColor:(UIColor *)startColor {
    if (startColor != self.startColor) {
        _startColor = startColor;
        [self updateLayer];
    }
}

- (void)setEndColor:(UIColor *)endColor {
    if (endColor != self.endColor) {
        _endColor = endColor;
        [self updateLayer];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (cornerRadius != self.cornerRadius) {
        _cornerRadius = cornerRadius;
        [self updateLayer];
    }
}

- (void)setGradientVertical:(BOOL)gradientVertical {
    if (gradientVertical != self.gradientVertical) {
        _gradientVertical = gradientVertical;
        [self updateLayer];
    }
}

- (void)setCornerType:(int)cornerType {
    if (cornerType != self.cornerType) {
        _cornerType = cornerType;
        [self updateLayer];
    }
}

#pragma mark -
#pragma mark Custom Method
- (void)setupDefault {
    
    self.backgroundColor = UIColor.clearColor;
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    
    self.shapLayer = [CAShapeLayer layer];
    self.shapLayer.frame = self.bounds;
    
    _startColor = UIColor.clearColor;
    _endColor = UIColor.clearColor;
    _cornerRadius = 0;
    _gradientVertical = true;

}

- (void)updateLayer {
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.colors = @[(id)[self.startColor CGColor], (id)[self.endColor CGColor]];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(self.gradientVertical ? 1:0, 1);
    
    UIRectCorner corner = UIRectCornerAllCorners;
    switch (self.cornerType) {
        case 1:
            corner = (UIRectCornerTopLeft | UIRectCornerTopRight);
            break;
        case 2:
            corner = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
            break;
        default:
            break;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    self.shapLayer.path = maskPath.CGPath;
    self.layer.mask = self.shapLayer;
}

@end
