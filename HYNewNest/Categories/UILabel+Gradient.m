//
//  UILabel+Gradient.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "UILabel+Gradient.h"

@implementation UILabel (Gradient)

- (void)setupGradientColorFrom:(UIColor *)fromColor toColor:(UIColor *)toColor {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制渐变层
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef,
                                                           (__bridge CFArrayRef)@[(id)fromColor.CGColor,(id)toColor.CGColor],
                                                           NULL);
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint,  kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    //取到渐变图片
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    //释放资源
    CGColorSpaceRelease(colorSpaceRef);
    CGGradientRelease(gradientRef);
    UIGraphicsEndImageContext();
    self.textColor = [UIColor colorWithPatternImage:gradientImage];
}

@end
