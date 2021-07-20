//
//  BYDottedLine.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/19.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYDottedLine.h"

@implementation BYDottedLine


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1);
    
    CGFloat lengths[] = {8, 8};
    
    CGContextSetStrokeColorWithColor(context, kHexColor(0x50BDF8).CGColor);
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(self.frame));
    
    CGContextStrokePath(context);
    CGContextClosePath(context);
}


@end
