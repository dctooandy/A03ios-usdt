//
//  VIPHomeUserModel.h
//  HYNewNest
//
//  Created by zaky on 9/10/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"
#import "VIPMonthlyModel.h"
#import "VIPRewardAnocModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 历史身份
@interface HistoryBet :CNBaseModel
@property (nonatomic , assign) NSInteger              betBaCount;
@property (nonatomic , assign) NSInteger              betGoldCount;
@property (nonatomic , assign) NSInteger              betKingCount;
@property (nonatomic , assign) NSInteger              betSaintCount;
@property (nonatomic , assign) NSInteger              betXiaCount;
@property (nonatomic , assign) NSInteger              betZunCount;

@end

/// 用户等级特权
@interface EquityDataItem :CNBaseModel
@property (nonatomic , strong) NSNumber              * depositAmount;
@property (nonatomic , strong) NSNumber              * depositCNYAmount;
@property (nonatomic , strong) NSNumber              * betAmount;
@property (nonatomic , strong) NSNumber              * betCNYAmount;
@property (nonatomic , strong) NSNumber              * ydfhAmount;
@property (nonatomic , strong) NSNumber              * ydfhCnyAmount;
@property (nonatomic , copy) NSString              * clubLevel;
@property (nonatomic , strong) NSNumber              * rhljAmount;
@property (nonatomic , strong) NSNumber              * rhljCnyAmount;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , copy) NSString              * zzzpTime;
@end

/// 私享会用户模型
@interface VIPHomeUserModel :CNBaseModel
@property (nonatomic , strong) VipRhqk              * vipRhqk;
@property (nonatomic , strong) VipScjz              * vipScjz;
@property (nonatomic , copy) NSString              * maxValidAccount;
@property (nonatomic , assign) NSInteger              beginFlag;
@property (nonatomic , copy) NSString              * curBetName;
@property (nonatomic , strong) HistoryBet              * historyBet;
@property (nonatomic , copy) NSString              * clubLevel;
@property (nonatomic , strong) NSNumber *              totalDepositAmount;
@property (nonatomic , strong) NSNumber *              totalBetAmount;
@property (nonatomic , strong) NSNumber *              totalDepositCNYAmount;
@property (nonatomic , strong) NSNumber *              totalBetCNYAmount;
@property (nonatomic , strong) NSArray <EquityDataItem *>              * equityData;
@property (nonatomic , strong) NSArray <VIPRewardAnocModel *>          * prizeList;
@end

NS_ASSUME_NONNULL_END
