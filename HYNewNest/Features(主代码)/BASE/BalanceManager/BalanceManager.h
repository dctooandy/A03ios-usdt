//
//  BalanceManager.h
//  HYNewNest
//
//  Created by zaky on 11/26/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BetAmountModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AccountBalancesBlock)(AccountMoneyDetailModel *_Nonnull model);
@interface BalanceManager : NSObject

+ (instancetype)shareManager;

/// 从单利获取缓存数据 如果数据为空或者倒计时为0则 调用接口请求方法
- (void)getBalanceDetailHandler:(AccountBalancesBlock)handler;
- (void)getPromoteXimaHandler:(void(^)(PromoteXimaModel * _Nonnull model))handler;
- (void)getWeeklyBetAmountHandler:(void(^)(BetAmountModel * _Nonnull model))handler;

/// 直接从接口获取数据 将倒计时重置为60s
- (void)requestBalaceHandler:(nullable AccountBalancesBlock)handler;
- (void)requestMonthPromoteAndXimaHandler:(nullable void(^)(PromoteXimaModel *))handler;
- (void)requestBetAmountHandler:(nullable void(^)(BetAmountModel *))handler;

@end

NS_ASSUME_NONNULL_END
