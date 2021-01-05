//
//  DSBRecharWithdrwUsrModel.h
//  HYNewNest
//
//  Created by zaky on 12/8/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSBRecharWithdrwUsrModel :CNBaseModel
@property (nonatomic , assign) NSInteger              clubLevel;
@property (nonatomic , copy) NSString              * createdDateBegin;
@property (nonatomic , copy) NSString              * createdDateEnd;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , assign) NSInteger              customerId;
@property (nonatomic , assign) NSInteger              customerLevel;
@property (nonatomic , copy) NSString              * headshot;
@property (nonatomic , copy) NSString              * lastDepositDate;
@property (nonatomic , copy) NSString              * lastWithdrawalDate;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , strong) NSNumber              * totalAmount;

@property (copy,nonatomic,readonly) NSString *writtenLevel; 
@property (copy,nonatomic,readonly) NSString *writtenTime; 
@end

NS_ASSUME_NONNULL_END
