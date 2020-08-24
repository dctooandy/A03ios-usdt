//
//  CNMessageBoxView.h
//  HYNewNest
//
//  Created by Cean on 2020/8/5.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN
@interface CNMessageBoxView : CNBaseXibView

/// 消息盒子弹框
/// @param images 数组，可以是 图片，图片名称 或 图片地址
+ (void)showMessageBoxWithImages:(NSArray *)images onView:(UIView *)onView tapBlock:(void(^)(int idx))tapBlock;

@end

NS_ASSUME_NONNULL_END
