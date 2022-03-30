//
//  CNMAlertView.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/21/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNMAlertView : CNBaseXibView

/// 撮合弹框样式
/// @param title 标题
/// @param content 内容
/// @param desc 内容补充描述，为空传nil
/// @param need 是否需要右上角关闭按钮
/// @param commit 确认标题
/// @param commitAction 确认事件
/// @param cancel 取消标题，为空传nil
/// @param cancelAction 取消事件，为空传nil
+ (instancetype)showAlertTitle:(NSString *)title
                       content:(NSString *)content
                          desc:(nullable NSString *)desc
             needRigthTopClose:(BOOL)need
                   commitTitle:(nullable NSString *)commit
                  commitAction:(nullable dispatch_block_t)commitAction
                   cancelTitle:(nullable NSString *)cancel
                  cancelAction:(nullable dispatch_block_t)cancelAction;


/// 撮合弹框，3秒后自动执行commit 事件
/// @param title 标题
/// @param content 内容
/// @param interval   倒计时：秒
/// @param commitAction 确认事件
+ (instancetype)show3SecondAlertTitle:(NSString *)title
                              content:(NSString *)content
                             interval:(NSInteger)interval
                         commitAction:(dispatch_block_t)commitAction;
@end

NS_ASSUME_NONNULL_END
