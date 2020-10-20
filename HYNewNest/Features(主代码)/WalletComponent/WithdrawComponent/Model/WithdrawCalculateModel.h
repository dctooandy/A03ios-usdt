//
//  WithdrawCalculateModel.h
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CanWithdrawInfoItem :CNBaseModel
@property (nonatomic , strong) NSNumber              * amount;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , strong) NSNumber              * rate;
@property (nonatomic , copy) NSString              * rateUuid;
@property (nonatomic , strong) NSNumber              * srcAmount;
@property (nonatomic , copy) NSString              * srcCurrency;

@end


@interface PromoInfo :CNBaseModel
@property (nonatomic , copy) NSNumber              * amount;
@property (nonatomic , assign) NSInteger              betAmountMultiplier;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , assign) NSInteger              maxAmount;
@property (nonatomic , assign) NSInteger              maxAmountPerTime;
@property (nonatomic , assign) NSInteger              promoRatio;
@property (nonatomic , copy) NSString              * promotionType;
@property (nonatomic , strong) NSNumber              * refAmount;

@end


@interface WithdrawCalculateModel :CNBaseModel
/// 取款金额  请求金额直接返回的
@property (nonatomic , strong) NSNumber             * amount;
/// ！可取款信息列表
@property (nonatomic , strong) NSArray <CanWithdrawInfoItem *>              * canWithdrawInfo;
/// ！是否计算需要拆分标示 否则正常转账(白名单)
@property (nonatomic , assign) BOOL              creditExchangeFlag;
/// ！转到USDT的百分比（%）
@property (nonatomic , assign) NSInteger              creditExchangeRatio;
/// ！取款拆分限额 （CNY小于该数额则全数转为USDT子账户取款）
@property (nonatomic , assign) NSInteger              exchangeAmountLimit;
@property (nonatomic , strong) PromoInfo              * promoInfo;
/// 取款USDT最小限额？
@property (nonatomic , assign) NSInteger              usdtWithdrawLimitAmount;

@end
NS_ASSUME_NONNULL_END
