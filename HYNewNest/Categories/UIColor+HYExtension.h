//
//  UIColor+HYExtension.h
//  HYNewNest
//
//  Created by zaky on 9/8/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HYExtension)

+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
