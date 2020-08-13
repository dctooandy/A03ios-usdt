//
//  CNWithdrawRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNWithdrawRequest : CNBaseNetworking


/// 转账到本地
/// @param handler 回调
+ (void)transferBalanceToLocalHandler:(HandlerBlock)handler;


/// 提交提现订单
/// @param amount 金额
/// @param accountId 账户ID
/// @param protocol usdt协议
/// @param remarks 备注
/// @param handler 回调
+ (void)submitWithdrawRequestAmount:(NSNumber *)amount
                          accountId:(NSString *)accountId
                           protocol:(NSString *)protocol
                            remarks:(NSString *)remarks
                            handler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
