//
//  SCMyRecommenModel.h
//  HYNewNest
//
//  Created by zaky on 12/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCMyRecommenModel :CNBaseModel
@property (nonatomic , assign) NSInteger              clubLevel;
@property (nonatomic , copy) NSString              *createdDate;
@property (nonatomic , copy) NSString              *currency;
@property (nonatomic , copy) NSString              *customerId;
@property (nonatomic , copy) NSString              *customerLevel;
@property (nonatomic , copy) NSString              *customerType;
@property (nonatomic , copy) NSString              *depositAmount;
@property (nonatomic , copy) NSString              *flag;
@property (nonatomic , copy) NSString              *lastLoginDate;
@property (nonatomic , copy) NSString              *loginName;
@property (nonatomic , copy) NSString              *loginTimes;
@property (nonatomic , copy) NSString              *parentId;

@end

NS_ASSUME_NONNULL_END
