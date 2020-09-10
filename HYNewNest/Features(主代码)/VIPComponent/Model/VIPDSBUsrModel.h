//
//  VIPDSBUsrModel.h
//  HYNewNest
//
//  Created by zaky on 9/10/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPDSBUsrModel :CNBaseModel
@property (nonatomic , copy) NSString              * clubLevel;
@property (nonatomic , copy) NSString              * clubName;
@property (nonatomic , copy) NSString              * createDate;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , assign) NSInteger              dataType;
@property (nonatomic , assign) NSInteger              likeCount;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , assign) NSInteger              pageNo;
@property (nonatomic , assign) NSInteger              pageSize;
@property (nonatomic , strong) NSNumber *              totalBetAmount;
@property (nonatomic , strong) NSNumber *              totalDepositAmount;
@property (nonatomic , copy) NSString              * updateDate;

@end

NS_ASSUME_NONNULL_END
