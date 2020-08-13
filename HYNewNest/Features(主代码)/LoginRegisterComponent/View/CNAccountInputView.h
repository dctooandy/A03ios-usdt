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
@property (nonatomic, copy) NSString *account;
/// 用户账号是否正确
@property (nonatomic, assign) BOOL correct;
/// 手机或者账号登录
@property (nonatomic, assign) BOOL phoneLogin;
@property (nonatomic, weak) id delegate;

/// 区别注册登录
@property (nonatomic, assign) BOOL isRegister;

- (void)showWrongMsg:(NSString *)msg;
- (void)setPlaceholder:(NSString *)text;


/// 电话回拨新增页面，为了不改版原来业务，修改键盘类型即可避免
/// 后期优化：与上面合并成枚举，区分各种输入来源
@property (nonatomic, assign) BOOL fromServer;
@end

NS_ASSUME_NONNULL_END
