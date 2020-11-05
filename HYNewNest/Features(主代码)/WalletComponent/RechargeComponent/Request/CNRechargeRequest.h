//
//  CNRechargeRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"

#import "PayWayV3Model.h"
#import "BQPaymentModel.h"
#import "PayOnlinePaymentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNRechargeRequest : CNBaseNetworking


#pragma mark - 获取充值渠道

/// 查询所有人民币充值渠道
+ (void)queryPayWaysV3Handler:(HandlerBlock)handler;


/// 查询所有USDT充值渠道
+ (void)queryUSDTPayWalletsHandler:(HandlerBlock)handler;


/// 查询USDT收银台 （买卖币跳转）
+ (void)queryUSDTCounterHandler:(HandlerBlock)handler;


#pragma mark - 查询充值渠道信息（选中充值渠道后调用）

/// BQ支付 查询快捷金额和限额（人民币渠道下的 手工存款(payType==0) 和 银行卡转账）
+ (void)queryAmountListPayType:(NSString *)payType
                       handler:(HandlerBlock)handler;


/// BQ支付 查询公司可用于转账的银行卡（点击选择收款银行）
/// @param payType PayWayItem.payType
/// @param depositor 付款人（如果是用户手动输入的付款人 就不需要传depositorId）
/// @param depositorId 付款人id（如果是用户选中曾经付款记录里的人 就不需要传depositor）
/// @param handler 回调
//+ (void)queryBQBanksPayType:(NSString *)payType
//                  depositor:(nullable NSString *)depositor
//                depositorId:(nullable NSString *)depositorId
//                    handler:(HandlerBlock)handler;


/// 查询在线支付银行列表（选中充值渠道后必须调用）
/// @param payType PayWayItem.payType / DepositBankItem.payType
/// @param usdtProtocol 当是USDT渠道时必传协议
/// @param handler 回调
+ (void)queryOnlineBanksPayType:(NSString *)payType
                   usdtProtocol:(nullable NSString *)usdtProtocol
                        handler:(HandlerBlock)handler;


#pragma mark - 创建订单

/// 创建在线支付订单 (USDT)
/// @param amount 金额
/// @param currency 货币
/// @param usdtProtocol 协议
/// @param payType DepositBankItem.payType
/// @param payid OnlineBanksModel.payid
/// @param showQRCode 是否返回二维码  0:否 ，1:是
/// @param handler 回调
+ (void)submitOnlinePayOrderAmount:(NSString *)amount
                          currency:(NSString *)currency
                      usdtProtocol:(NSString *)usdtProtocol
                           payType:(NSString *)payType
                             payid:(NSString *)payid
                        showQRCode:(NSInteger)showQRCode
                           handler:(HandlerBlock)handler;


/// 创建在线支付订单（USDT渠道：钱包扫码）
/// @param amount 金额
/// @param currency 货币
/// @param usdtProtocol 协议
/// @param payType DepositBankItem.payType
/// @param handler 回调
+ (void)submitOnlinePayOrderV2Amount:(NSString *)amount
                            currency:(NSString *)currency
                        usdtProtocol:(NSString *)usdtProtocol
                             payType:(NSString *)payType
                             handler:(HandlerBlock)handler;

/// 创建在线支付订单（人民币渠道）
/// @param amount 金额
/// @param payType DepositBankItem.payType
/// @param payid OnlineBanksModel.payid
/// @param handler 回调
+ (void)submitOnlinePayOrderRMBAmount:(NSString *)amount
                              payType:(NSString *)payType
                                payid:(NSString *)payid
                              handler:(HandlerBlock)handler;

/// 提交BQ订单
/// @param payType PayWayItem.payType
/// @param amount 金额
/// @param depositor 存款人
/// @param depositorType 如果是用户曾经付款记录里的人传1 否则传0
+ (void)submitBQPaymentPayType:(NSString *)payType
                        amount:(NSString *)amount
                     depositor:(NSString *)depositor
                 depositorType:(NSInteger)depositorType
//                      bankCode:(NSString *)bankCode
                       handler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
