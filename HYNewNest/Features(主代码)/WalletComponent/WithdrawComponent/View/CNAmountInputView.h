//
//  CNAmountInputView.h
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseXibView.h"
#import "SmsCodeModel.h"
#import "CNLoginRequest.h"
#import "BetAmountModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CNAmountType) {
    CNAmountTypeWithdraw,       //取款
};

@class CNAmountInputView;
@protocol CNAmountInputViewDelegate
- (void)amountInputViewTextChange:(CNAmountInputView *)view;
@end

@interface CNAmountInputView : CNBaseXibView
/// 金额
@property (nonatomic, strong) NSString *money;
/// 是否能提现
@property (nonatomic, assign) BOOL correct;

@property (nonatomic, strong) AccountMoneyDetailModel *model;

@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) CNAmountType codeType;

- (void)showWrongMsg:(NSString *)msg;
- (void)setPlaceholder:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
