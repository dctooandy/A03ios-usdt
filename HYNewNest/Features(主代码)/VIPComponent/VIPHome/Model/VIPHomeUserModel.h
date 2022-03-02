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
@property (nonatomic , strong) NSNumber              * depositAmountCNY;
@property (nonatomic , strong) NSNumber              * depositAmountUSDT;
@property (nonatomic , strong) NSNumber              * betAmount;
@property (nonatomic , strong) NSNumber              * betAmountCNY;
@property (nonatomic , strong) NSNumber              * betAmountUSDT;
@property (nonatomic , copy) NSString                * clubLevel;
@property (nonatomic , copy) NSString                * currency;
@property (nonatomic , strong) NSNumber              * rhljAmount;//原入会礼金
@property (nonatomic , strong) NSNumber              * ydfhAmount;//原私享金
@property (nonatomic , copy) NSString                * zzzpTime;//原转盘数量
@property (nonatomic , copy) NSString                * clubName;//人物项次
@property (nonatomic , copy) NSString                * chance;//转盘数量
@property (nonatomic , strong) NSNumber              * membershipBonusCNY;//入会礼金-CNY
@property (nonatomic , strong) NSNumber              * membershipBonusUSDT;//入会礼金-USDT
@property (nonatomic , strong) NSNumber              * monthlyDividendCNY;//私享金-CNY
@property (nonatomic , strong) NSNumber              * monthlyDividendUSDT;//私享金-USDT

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
@property (nonatomic , strong) NSArray <EquityDataItem *>              * equityData;
@property (nonatomic , strong) NSArray <VIPRewardAnocModel *>          * prizeList;
@end

NS_ASSUME_NONNULL_END
