//
//  UILabel+Gradient.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "UILabel+Gradient.h"

@implementation UILabel (Gradient)

// 左上角到右下角
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

- (void)setupGradientColorDirection:(BYLblGrdtColorDirection)direction From:(UIColor *)fromColor toColor:(UIColor *)toColor {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制渐变层
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef,
                                                           (__bridge CFArrayRef)@[(id)fromColor.CGColor,(id)toColor.CGColor],
                                                           NULL);
    CGPoint startPoint;
    CGPoint endPoint;
    switch (direction) {
        case BYLblGrdtColorDirectionTopLeftBtmRight:
            startPoint = CGPointZero;
            endPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
            break;
        case BYLblGrdtColorDirectionTopBottom:
            startPoint = CGPointMake(self.bounds.size.width * 0.5, 0);
            endPoint = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height);
            break;
        case BYLblGrdtColorDirectionTopRightBtmLeft:
            startPoint = CGPointMake(self.bounds.size.width, 0);
            endPoint = CGPointMake(0, self.bounds.size.height);
            break;
        case BYLblGrdtColorDirectionLeftRight:
            startPoint = CGPointMake(0, self.bounds.size.height*0.5);
            endPoint = CGPointMake(CGRectGetMaxY(self.bounds), self.bounds.size.height*0.5);
            break;
    }
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
