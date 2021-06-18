//
//  SCMyRebateModel.h
//  HYNewNest
//
//  Created by zaky on 4/20/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRebateResultItem : CNBaseModel
@property (nonatomic , strong) NSNumber * commission;
@property (strong,nonatomic) NSString *currency;
@property (strong,nonatomic) NSString *loginName;
@property (strong,nonatomic) NSNumber * totalBet;
@property (assign,nonatomic) NSInteger customerLevel;
@property (copy , nonatomic) NSString * upLevelStr;
@end

@interface SCMyRebateModel : CNBaseModel
@property (nonatomic , strong) NSArray * result;
@property (nonatomic , strong) NSString * weekEstimate;
@end

NS_ASSUME_NONNULL_END
