//
//  CNWDAddressRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "AccountModel.h"
#import "CardBinTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

// 卡列表分类
typedef enum : NSUInteger {
    HYAddressTypeBANKCARD = 0,  //银行卡
    HYAddressTypeDCBOX,         //小金库
    HYAddressTypeUSDT,          //其他地址
} HYAddressType;

@interface CNWDAccountRequest : CNBaseNetworking


#pragma mark - 卡列表

/// 获取所有提现地址（银行卡，小金库，加密货币钱包）
+ (void)queryAccountHandler:(HandlerBlock)handler;


/// 删卡
/// @param accountId 卡ID
/// @param handler 回调
+ (void)deleteAccountId:(NSString *)accountId
                handler:(HandlerBlock)handler;


#pragma mark - 绑卡

/// 获取银行卡信息
/// @param bankCardNo 银行卡号
/// @param handler 回调
+ (void)getBankCardBinByBankCardNo:(NSString *)bankCardNo
                           handler:(HandlerBlock)handler;

/// 绑定银行卡
/// @param accountNo 卡号
/// @param bankName 银行名称
/// @param accountType 账户类型
/// @param bankBranchName 支行名
/// @param province 省
/// @param city 市
/// @param messageId 验证短信ID
/// @param validateId 校验信息ID
/// @param expire 验证过期时间
/// @param handler 回调
+ (void)createAccountBankCardNo:(NSString *)accountNo
                       bankName:(NSString *)bankName
                    accountType:(NSString *)accountType
                 bankBranchName:(NSString *)bankBranchName
                       province:(NSString *)province
                           city:(NSString *)city
                      messageId:(NSString *)messageId
                     validateId:(NSString *)validateId
                         expire:(NSString *)expire
                        handler:(HandlerBlock)handler;

/// 绑定币付宝账户
/// @param accountNo 账号
/// @param isOneKey 是否一键绑定币付宝
/// @param handler 回调
+ (void)createAccountDCBoxAccountNo:(NSString *)accountNo
                           isOneKey:(BOOL)isOneKey
                         validateId:(nullable NSString *)validateId
                          messageId:(nullable NSString *)messageId
                            smsCode:(nullable NSString *)smsCode
                            handler:(HandlerBlock)handler;

/// 绑定USDT地址
/// @param accountNo 地址
/// @param bankAlias 别名
/// @param validateId SmsCodeModel.validateId
/// @param handler 回调
+ (void)createAccountUSDTAccountNo:(NSString *)accountNo
                         bankAlias:(NSString *)bankAlias
                        validateId:(nullable NSString *)validateId
                         messageId:(nullable NSString *)messageId
                           handler:(HandlerBlock)handler;


/// 创建小金库
+ (void)createGoldAccountHandler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
