//
//  SCMyBonusModel.h
//  HYNewNest
//
//  Created by zaky on 12/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyBonusResultItem : CNBaseModel
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , assign) NSInteger           upLevel;
@property (nonatomic , copy) NSString              * upType;
@property (copy , nonatomic) NSString              * upLevelStr; 
@property (nonatomic , copy) NSString              * amount;
@property (nonatomic , copy) NSString              * createdDate;
@property (nonatomic , copy) NSString              * maturityDate;
@property (assign,nonatomic) NSInteger             flag; 

@end

@interface SCMyBonusModel : CNBaseModel
@property (nonatomic , strong) NSArray<MyBonusResultItem *> * result;
@property (nonatomic , strong) NSNumber            * receivedAmount;
@property (nonatomic , strong) NSNumber            * notReceivedAmount;

@end

NS_ASSUME_NONNULL_END
