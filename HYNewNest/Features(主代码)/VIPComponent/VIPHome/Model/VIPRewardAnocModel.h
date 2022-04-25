//
//  VIPRewardAnocModel.h
//  HYNewNest
//
//  Created by zaky on 8/29/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

///奖品模型
@interface VIPRewardAnocModel : CNBaseModel
@property (nonatomic , copy) NSString              * activityId;
@property (nonatomic , assign) NSInteger              amount;
@property (nonatomic , copy) NSString              * createdDate;
@property (nonatomic , assign) NSInteger              flag; //传 1，代表查询领取成功的奖品
@property (nonatomic , copy) NSString              * loginname;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , assign) NSInteger              pageNumber;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , assign) NSInteger              prizeLevel;
@property (nonatomic , copy) NSString              * prizeName;
@property (nonatomic , copy) NSString              * prizedesc;
@property (nonatomic , assign) NSInteger              prizelevel;
@property (nonatomic , assign) NSInteger              prizetype;
@property (nonatomic , copy) NSString              * productId;
@property (nonatomic , assign) NSInteger              refAmount;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * fetchDate;

@end

NS_ASSUME_NONNULL_END
