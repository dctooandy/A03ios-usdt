//
//  UIView+DottedLine.h
//  HYGEntire
//
//  Created by zaky on 25/11/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DottedLine)

// 虚线边框
- (void)dottedLineBorderColor:(UIColor *)borderColor
                    fillColor:(UIColor *)fillColor;

// 虚线边框
- (void)dottedLineBorderWithView:(UIView *)view
                     borderColor:(UIColor *)borderColor
                       fillColor:(UIColor *)fillColor;

// 绘制虚线
- (void)drawDottedLineBeginPoint:(CGPoint)bPoint
                        endPoint:(CGPoint)ePoint
                       lineWidth:(CGFloat)lWidth
                       lineColor:(UIColor *)lColor;

// 绘制实线
- (void)drawNormalLineBeginPoint:(CGPoint)bPoint
                        endPoint:(CGPoint)ePoint
                       lineWidth:(CGFloat)lWidth
                       lineColor:(UIColor *)lColor;

@end

NS_ASSUME_NONNULL_END
