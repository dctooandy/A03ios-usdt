//
//  CNWithdrawRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "WithdrawCalculateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNWithdrawRequest : CNBaseNetworking


/// 转账到本地
/// @param handler 回调
+ (void)transferBalanceToLocalHandler:(HandlerBlock)handler;


/// 取款计算信息查询接口(CNY)
/// @param mode 0:实时计算， 1:查询配置信息，前端计算
/// @param amount 金额 mode=0时必传
/// @param accountId 账户ID mode=0时必传
/// @param handler 回调
+ (void)withdrawCalculatorMode:(NSNumber *)mode
                        amount:(nullable NSString *)amount
                     accountId:(nullable NSString *)accountId
                       handler:(HandlerBlock)handler ;

/// 提交提现订单
/// @param amount 金额
/// @param accountId 账户ID
/// @param protocol usdt协议
/// @param remarks 备注
/// @param subWallAccountId 子账户ID (CNY转账才需要传)
/// @param handler 回调
+ (void)submitWithdrawRequestAmount:(NSString *)amount
                          accountId:(NSString *)accountId
                           protocol:(NSString *)protocol
                            remarks:(NSString *)remarks
                   subWallAccountId:(nullable NSString *)subWallAccountId
                           password:(NSString *)password
                            handler:(HandlerBlock)handler;

/// 查询是否需要资金密码
+ (void)checkIsNeedWithdrawPwdHandler:(HandlerBlock)handler;

/// 查询所有钱包额度
+ (void)getBalancesHandler:(HandlerBlock)handler;

/// 获取用户手机绑定状态
+ (void)getUserMobileStatusCompletionHandler:(nullable HandlerBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
