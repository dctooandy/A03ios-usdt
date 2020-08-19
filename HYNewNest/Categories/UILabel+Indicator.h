//
//  UILabel+Indicator.h
//  HYNewNest
//
//  Created by zaky on 8/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+hiddenText.h"

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Indicator)

@property (nonatomic, assign) BOOL isIndicating;

/** 显示菊花 */
- (void)showIndicatorIsBig:(BOOL)isBig;

/** 隐藏菊花 */
- (void)hideIndicator;
- (void)hideIndicatorWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
