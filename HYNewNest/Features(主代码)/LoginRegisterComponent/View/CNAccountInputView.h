//
//  CNAccountInputView.h
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@class CNAccountInputView;
@protocol CNAccountInputViewDelegate
- (void)accountInputViewTextChange:(CNAccountInputView *)view;
@end


@interface CNAccountInputView : CNBaseXibView
/// 账号
@property (nonatomic, readonly) NSString *account;
/// 用户账号是否正确
@property (nonatomic, assign) BOOL correct;
/// 手机或者账号登录
@property (nonatomic, assign) BOOL phoneLogin;
@property (nonatomic, weak) id delegate;

/// 区别注册登录
@property (nonatomic, assign) BOOL isRegister;

- (void)showWrongMsg:(NSString *)msg;
- (void)setPlaceholder:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
