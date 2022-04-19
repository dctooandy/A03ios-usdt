//
//  HYRechargeHelper.h
//  HYGEntire
//
//  Created by zaky on 08/05/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayWayV3Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYRechargeHelper : NSObject

/// 根据模型返回限额金额文字
+ (NSString *)amountTip:(PayWayV3PayTypeItem *)item;
+ (NSString *)amountTipV3USDT:(PayWayV3PayTypeItem *)bank;
+ (NSString *)amountTipUSDT:(DepositsBankModel *)bank;

/// 支付类型是否在线支付类型
+ (BOOL)isOnlinePayWay:(PayWayV3PayTypeItem *)item;



/// 支付类型是否是小金库
+ (BOOL)isOnlinePayWayDCBox:(DepositsBankModel *)item;

/// 支付类型USDT是否其它钱包（钱包扫码）
+ (BOOL)isUSDTOtherBankModel:(DepositsBankModel *)item;

/// 支付类型USDT是否公链充值 （需要填写转账人地址）
+ (BOOL)isUSDTBankModelPublicChain:(DepositsBankModel *)bank;

/// 支付类型USDT是否其它钱包（钱包扫码）
+ (BOOL)isUSDTOtherBankV3Model:(PayWayV3PayTypeItem *)item;
@end

NS_ASSUME_NONNULL_END
