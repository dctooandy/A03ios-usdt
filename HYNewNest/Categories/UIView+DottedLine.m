//
//  UIView+DottedLine.m
//  HYGEntire
//
//  Created by zaky on 25/11/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "UIView+DottedLine.h"

@implementation UIView (DottedLine)

- (void)dottedLineBorderColor:(UIColor *)borderColor
                    fillColor:(UIColor *)fillColor{
    
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = borderColor.CGColor;
    //填充的颜色
    border.fillColor = fillColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    
    //设置路径
    border.path = path.CGPath;
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = AD(1);
    
    //设置线条的样式
    //border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @3];
    [self.layer insertSublayer:border atIndex:0];
 }

- (void)dottedLineBorderWithView:(UIView *)view
                     borderColor:(UIColor *)borderColor
                       fillColor:(UIColor *)fillColor{
    
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = borderColor.CGColor;
    //填充的颜色
    border.fillColor = fillColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    
    //设置路径
    border.path = path.CGPath;
    border.frame = view.bounds;
    //虚线的宽度
    border.lineWidth = AD(1);
    
    //设置线条的样式
    //border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @3];
    [view.layer addSublayer:border];
 }

- (void)drawDottedLineBeginPoint:(CGPoint)bPoint
                        endPoint:(CGPoint)ePoint
                       lineWidth:(CGFloat)lWidth
                       lineColor:(UIColor *)lColor {
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:bPoint];
    // 其他点
    [linePath addLineToPoint:ePoint];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = lWidth;
    lineLayer.strokeColor = lColor.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    lineLayer.lineDashPattern = @[@4, @3];
    
    [self.layer addSublayer:lineLayer];
}

- (void)drawNormalLineBeginPoint:(CGPoint)bPoint
                        endPoint:(CGPoint)ePoint
                       lineWidth:(CGFloat)lWidth
                       lineColor:(UIColor *)lColor {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:bPoint];
    [linePath addLineToPoint:ePoint];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = lWidth;
    lineLayer.strokeColor = lColor.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil;
    
    [self.layer addSublayer:lineLayer];
}


@end
