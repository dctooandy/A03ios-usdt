//
//  UIButton+Indicator.h
//  HYGEntire
//
//  Created by zaky on 20/11/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Indicator)


- (void)showIndicator;

/** 显示菊花 */
- (void)showIndicatorWithTitle:(NSString *)title;

/** 隐藏菊花 */
- (void)hideIndicator;

/** 显示图片 */
- (void)showWithImageName:(NSString *)imageName title:(NSString *)title bgColor:(UIColor *)bgColor;

/** 隐藏图片 */
- (void)hideImage;

@end

NS_ASSUME_NONNULL_END
