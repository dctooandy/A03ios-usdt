//
//  UIColor+Gradient.h
//  HYNewNest
//
//  Created by zaky on 9/24/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GradientType) {// 渐变方向
    GradientTypeTopToBottom      = 0,//从上到下
    GradientTypeLeftToRight      = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIColor (Gradient)
//--------------------------------------------------------------------------------
//
// Description  - 基础数据请求
// Para         - 1.(NSArray) colors，请求地址
//              - 2.(GradientType) gradientType, 渐变方向
//              - 3.(CGSize) imgSize,区域大小
//
// Return       - UIColor
// Author       - Barney
//
+ (UIColor *)gradientColorImageFromColors:(NSArray*)colors
                             gradientType:(GradientType)gradientType
                                  imgSize:(CGSize)imgSize;
//
//--------------------------------------------------------------------------------

+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
