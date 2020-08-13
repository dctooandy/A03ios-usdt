//
//  CNImaginaryLine.m
//  LCNewApp
//
//  Created by cean.q on 2019/12/3.
//  Copyright © 2019 B01. All rights reserved.
//

#import "CNImaginaryLine.h"

@implementation CNImaginaryLine

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 绘制线的宽度
    CGContextSetLineWidth(context, 1.0);
    // 线的颜色
    CGContextSetStrokeColorWithColor(context, kHexColorAlpha(0xFFFFFF, 0.2).CGColor);
    // 开始绘制
    CGContextBeginPath(context);
    // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
    CGFloat lengths[] = {3, 3};
    // 虚线的起始点
    CGContextSetLineDash(context, 0, lengths, 2);
    // 绘制虚线的边框
    CGContextAddRect(context, rect);
    // 绘制
    CGContextStrokePath(context);
    // 关闭图像
    CGContextClosePath(context);
}

@end
