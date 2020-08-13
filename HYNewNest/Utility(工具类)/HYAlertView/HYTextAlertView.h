//
//  HYTextAlertView.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/24.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

/// 用于账号过期，冻结校验，删除地址..
@interface HYTextAlertView : HYBaseAlertView


/// 文字弹窗 不带右上角关闭按钮
/// @param title 标题
/// @param content 内容自适应高度
/// @param comfirmText 确认按钮
/// @param cancelText 取消按钮（如果不传则只有确认按钮）
/// @param handler 回调
+ (void)showWithTitle:(NSString *)title
              content:(NSString *)content
          comfirmText:(NSString *)comfirmText
           cancelText:(nullable NSString *)cancelText
       comfirmHandler:(void(^)(BOOL isComfirm))handler;


@end

NS_ASSUME_NONNULL_END
