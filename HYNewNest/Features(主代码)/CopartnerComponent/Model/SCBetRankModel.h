//
//  SCBetRankModel.h
//  HYNewNest
//
//  Created by zaky on 12/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BetRankResultItem :CNBaseModel
@property (nonatomic , copy) NSString              * activityCode;
@property (nonatomic , copy) NSString              * downlineCount;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , copy) NSString              * prizeAmount;
@property (nonatomic , copy) NSString              * ranking;

@end


@interface SCBetRankModel :CNBaseModel
@property (nonatomic , assign) NSInteger              month;
@property (nonatomic , strong) NSArray<BetRankResultItem *> * result;
@property (nonatomic , strong) NSNumber            * totalDownlineBet;

@end

NS_ASSUME_NONNULL_END
