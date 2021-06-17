//
//  BYGradientButton.h
//  HYNewNest
//
//  Created by RM04 on 2021/5/14.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface BYGradientButton : UIButton

@property (nonatomic, strong) IBInspectable UIColor *startColor;
@property (nonatomic, strong) IBInspectable UIColor *endColor;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
