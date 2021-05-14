//
//  BYGradientView.h
//  HYNewNest
//
//  Created by RM04 on 2021/5/13.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//IB_DESIGNABLE

@interface BYGradientView : UIView

@property (nonatomic, strong) IBInspectable UIColor *startColor;
@property (nonatomic, strong) IBInspectable UIColor *endColor;
@property (nonatomic, assign) IBInspectable BOOL gradientVertical;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/// Define 0 = All; 1 = Top; 2 = Bottom
@property (nonatomic, assign) IBInspectable int cornerType;

@end

NS_ASSUME_NONNULL_END
