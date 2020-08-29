//
//  VIPLevelData.h
//  HYGEntire
//
//  Created by zaky on 26/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "CNBaseModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface VIPLevelData : CNBaseModel

@property(nonatomic,copy) NSString *clubFlag;
@property(nonatomic,copy) NSString *integralCount;
@property(nonatomic,copy) NSString *lackBetAmount;
@property(nonatomic,copy) NSString *levelName;
@property(nonatomic,copy) NSString *levelStatus;
@property(nonatomic,copy) NSString *preTotalBetAmount;
@property(nonatomic,copy) NSString *remainTimes;
@property(nonatomic,copy) NSString *totalBetAmount;

@end

NS_ASSUME_NONNULL_END
