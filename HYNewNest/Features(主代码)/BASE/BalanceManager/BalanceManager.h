//
//  BalanceManager.h
//  HYNewNest
//
//  Created by zaky on 11/26/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNBaseNetworking.h"
#import "BetAmountModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AccountBalancesBlock)(AccountMoneyDetailModel *_Nonnull model);
@interface BalanceManager : NSObject

+ (instancetype)shareManager;

/// 从单利获取缓存数据 如果数据为空或者倒计时为0则 调用接口请求方法
- (void)getBalanceDetailHandler:(AccountBalancesBlock)handler;
- (void)getWeeklyBetAmountHandler:(void(^)(BetAmountModel * _Nonnull model))handler;
//TODO: test
- (void)getYuEBaoYesterdaySumHandler:(void(^)(id unknowModel))handler;

/// 直接从接口获取数据 将倒计时重置为120s
- (void)requestBalaceHandler:(nullable AccountBalancesBlock)handler;
- (void)requestBetAmountHandler:(nullable void(^)(BetAmountModel *))handler;

/// 提币页面拿可提币金额：类方法
/// 针对新钱包 取款时 模拟结算 不走缓存 不查厅内余额 本地不做缓存
+ (void)requestWithdrawAbleBalanceHandler:(nullable  AccountBalancesBlock)handler;

@end

NS_ASSUME_NONNULL_END
