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
@property (nonatomic , assign) NSInteger              rfCode;
@property (nonatomic , assign) NSInteger              customerLevel;
@property (nonatomic , copy) NSString              * headshot;
//deposit
@property (nonatomic , copy) NSString              * lastDepositDate;
//withdraw
@property (nonatomic , copy) NSString              * lastWithdrawalDate;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , strong) NSNumber              * totalAmount;
//Xima
@property (nonatomic , strong) NSNumber              * totalAmount1;
@property (nonatomic , strong) NSNumber              * totalAmount2;
//累计盈利
@property (strong,nonatomic) NSNumber                *cusAmountSum;
//单笔盈利
@property (strong,nonatomic) NSNumber                *cusAmount;

@property (copy,nonatomic,readonly) NSString *writtenLevel; 
@property (copy,nonatomic,readonly) NSString *writtenTime; 
@end


@interface DSBWeekMonthModel : CNBaseModel
@property (strong,nonatomic) NSArray <DSBRecharWithdrwUsrModel *>*xm;
@property (strong,nonatomic) NSArray <DSBRecharWithdrwUsrModel *>*dbyl;
@property (strong,nonatomic) NSArray <DSBRecharWithdrwUsrModel *>*cz;
@property (strong,nonatomic) NSArray <DSBRecharWithdrwUsrModel *>*ljyl;
@property (strong,nonatomic) NSArray <DSBRecharWithdrwUsrModel *>*tx;
@end

NS_ASSUME_NONNULL_END
