//
//  HYWideOneBtnAlertView.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/2.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN


/// 宽弹窗，带顶部，底部按钮，自适应高度文字，用于 “提现说明”，“卖币弹窗”，“洗码规则”
@interface HYWideOneBtnAlertView : HYBaseAlertView

/// 单按钮宽弹窗
/// @param title 标题
/// @param content 内容 自适应高度
/// @param comfirmText 按钮标题
/// @param handler 回调
+ (void)showWithTitle:(NSString *)title
              content:(NSString *)content
          comfirmText:(NSString *)comfirmText
       comfirmHandler:(nullable void(^)(void))handler;

@end

NS_ASSUME_NONNULL_END
