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

- (void)dottedLineBorderColor:(UIColor *)borderColor
                    fillColor:(UIColor *)fillColor;

- (void)dottedLineBorderWithView:(UIView *)view
                     borderColor:(UIColor *)borderColor
                       fillColor:(UIColor *)fillColor;

- (void)drawDottedLineBeginPoint:(CGPoint)bPoint
                        endPoint:(CGPoint)ePoint
                       lineWidth:(CGFloat)lWidth
                       lineColor:(UIColor *)lColor;

- (void)drawNormalLineBeginPoint:(CGPoint)bPoint
                        endPoint:(CGPoint)ePoint
                       lineWidth:(CGFloat)lWidth
                       lineColor:(UIColor *)lColor;

@end

NS_ASSUME_NONNULL_END
