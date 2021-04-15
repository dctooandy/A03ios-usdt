//
//  UILabel+Gradient.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BYLblGrdtColorDirection) {
    BYLblGrdtColorDirectionTopLeftBtmRight = 0,
    BYLblGrdtColorDirectionTopBottom,
    BYLblGrdtColorDirectionTopRightBtmLeft,
    BYLblGrdtColorDirectionLeftRight,
};

@interface UILabel (Gradient)

/// 给label文字设置渐变色，该方法替代修改"textColor"属性
/// @param fromColor 开始颜色
/// @param toColor 结束颜色
- (UIColor *)setupGradientColorFrom:(UIColor *)fromColor toColor:(UIColor *)toColor;

- (UIColor *)setupGradientColorDirection:(BYLblGrdtColorDirection)direction From:(UIColor *)fromColor toColor:(UIColor *)toColor;

@end

NS_ASSUME_NONNULL_END
