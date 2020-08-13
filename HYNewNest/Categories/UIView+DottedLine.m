//
//  UIView+DottedLine.m
//  HYGEntire
//
//  Created by zaky on 25/11/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "UIView+DottedLine.h"

@implementation UIView (DottedLine)

- (void)addDottedLineWithView:(UIView *)view borderColor:(UIColor *)borderColor fillColor:(UIColor *)fillColor{
    
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


@end
