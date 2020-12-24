//
//  AgentRecordModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/6.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultItem :CNBaseModel
@property (nonatomic , assign) NSInteger              agentCommission;
@property (nonatomic , copy) NSString              * loginName;

@end


@interface WsQuerySumCount :CNBaseModel
@property (nonatomic , copy) NSString              * count;
@property (nonatomic , copy) NSString              * sumAmount;

@end


@interface AgentCommissionRecord :CNBaseModel
@property (nonatomic , assign) NSInteger              agentCommission;
@property (nonatomic , assign) NSInteger              cycleType;
@property (nonatomic , assign) NSInteger              firstBet;
@property (nonatomic , assign) NSInteger              firstBetCustNum;
@property (nonatomic , assign) NSInteger              firstCommission;
@property (nonatomic , assign) NSInteger              firstCommissionRate;
@property (nonatomic , assign) NSInteger              firstWinlost;
@property (nonatomic , assign) NSInteger              secondBet;
@property (nonatomic , assign) NSInteger              secondBetCustNum;
@property (nonatomic , assign) NSInteger              secondCommission;
@property (nonatomic , assign) NSInteger              secondCommissionRate;
@property (nonatomic , assign) NSInteger              secondCustNum;
@property (nonatomic , assign) NSInteger              secondWinlost;
@property (nonatomic , assign) NSInteger              thirdBet;
@property (nonatomic , assign) NSInteger              thirdBetCustNum;
@property (nonatomic , assign) NSInteger              thirdCommission;
@property (nonatomic , assign) NSInteger              thirdCommissionRate;
@property (nonatomic , assign) NSInteger              thirdCustNum;
@property (nonatomic , assign) NSInteger              thirdWinlost;
@property (nonatomic , assign) NSInteger              totalBetCustNum;
@property (nonatomic , assign) NSInteger              totalEffectiveCustNum;
@property (nonatomic , assign) NSInteger              totalSubCustNum;

@end


@interface AgentRecordModel :CNBaseModel
@property (nonatomic , strong) NSArray <ResultItem *>              * result;
@property (nonatomic , assign) NSInteger              wsAgentAmount;
@property (nonatomic , strong) WsQuerySumCount              * wsQuerySumCount;
@property (nonatomic , strong) AgentCommissionRecord              * agentCommissionRecord;

@end



NS_ASSUME_NONNULL_END
