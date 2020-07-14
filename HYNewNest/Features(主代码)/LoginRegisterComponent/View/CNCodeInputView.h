//
//  CNCodeInputView.h
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@class CNCodeInputView;
@protocol CNCodeInputViewDelegate
- (void)codeInputViewTextChange:(CNCodeInputView *)view;
@end

@interface CNCodeInputView : CNBaseXibView
/// 验证码/密码
@property (nonatomic, readonly) NSString *code;
/// 密码输入是否符合规则
@property (nonatomic, assign) BOOL correct;
/// 手机或者账号登录
@property (nonatomic, assign) BOOL phoneLogin;
@property (nonatomic, weak) id delegate;

- (void)showWrongMsg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
