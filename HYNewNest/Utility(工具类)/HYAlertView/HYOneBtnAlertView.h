//
//  HYOneBtnAlertView.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/2.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN


/// 带渐变按钮的小弹窗，用于“温馨提示”
@interface HYOneBtnAlertView : HYBaseAlertView


/// 单按钮弹窗
/// @param title 标题
/// @param content 内容 自适应高度
/// @param comfirmText 按钮标题
/// @param handler 回调
+ (void)showWithTitle:(NSString *)title
              content:(NSString *)content
          comfirmText:(NSString *)comfirmText
       comfirmHandler:(void(^)(void))handler;

@end

NS_ASSUME_NONNULL_END
