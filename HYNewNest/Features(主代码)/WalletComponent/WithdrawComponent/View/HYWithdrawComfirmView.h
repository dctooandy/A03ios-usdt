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


/// 提现金额 & 提现确认 & 支付等待 & 真实姓名绑定
@interface HYWithdrawComfirmView : UIView

/// 真实姓名绑定
- (instancetype)initRealNameSubmitBlock:(void(^)(NSString *realName))block;

/// 提现金额输入
- (instancetype)initWithAmountModel:(nullable AccountMoneyDetailModel *)amoutModel
                        sumbitBlock:(nullable void(^)(NSString *withdrawAmout))block;

/// 提现确认 正在受理中
- (void)showSuccessWithdraw;

/// 支付确认 等待到账
- (void)showRechargeWaiting;

@end

NS_ASSUME_NONNULL_END
