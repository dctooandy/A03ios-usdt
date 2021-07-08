//
//  HYWithdrawComfirmView.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BetAmountModel.h"

NS_ASSUME_NONNULL_BEGIN


/// 提现金额 & 提现确认 & 支付等待 & 真实姓名绑定 -> 分开。。。
@interface HYWithdrawComfirmView : UIView

/// 真实姓名绑定
- (instancetype)initRealNameSubmitBlock:(void(^)(NSString *realName))block;

/// 金额输入
- (instancetype)initWithAmountModel:(nullable AccountMoneyDetailModel *)amoutModel
                            needPwd:(BOOL)needPwd
                        sumbitBlock:(nullable void(^)(NSString *withdrawAmout, NSString *fPwd))block;

/// CNY提现拆分 提现成功
- (void)showSuccessWithdrawCNYExUSDT:(NSNumber *)uAmount dismissBlock:(nullable void(^)(void))block;

/// CNY提现成功
- (void)showSuccessWithdraw;

/// 支付确认 等待到账
- (void)showRechargeWaiting;

- (void)hideView;
- (void)removeView;

@end

NS_ASSUME_NONNULL_END
