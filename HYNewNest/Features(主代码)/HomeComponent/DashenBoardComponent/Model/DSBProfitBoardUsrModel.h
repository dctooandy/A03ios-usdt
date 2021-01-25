//
//  DSBProfitBoardUsrModel.h
//  HYNewNest
//
//  Created by zaky on 1/25/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrListItem : CNBaseModel
@property (nonatomic , copy) NSString              * account;
@property (nonatomic , copy) NSString              * agCode;
@property (nonatomic , assign) NSInteger              bankerPoint;
@property (nonatomic , copy) NSString              * billNo;
@property (nonatomic , copy) NSString              * billTime;
@property (nonatomic , copy) NSString              * curIp;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , assign) NSInteger              currencyType;
@property (nonatomic , copy) NSString              * currentAmount;
@property (nonatomic , strong) NSNumber              * cusAccount;
@property (nonatomic , assign) NSInteger              flag;
@property (nonatomic , copy) NSString              * gameType;
@property (nonatomic , copy) NSString              * gmCode;
@property (nonatomic , assign) NSInteger              isOnline;
@property (nonatomic , copy) NSString              * platformId;
@property (nonatomic , assign) NSInteger              playType;
@property (nonatomic , copy) NSString              * playTypeName;
@property (nonatomic , assign) NSInteger              playerPoint;
@property (nonatomic , strong) NSNumber              * previosAmount;
@property (nonatomic , copy) NSString              * reckonTime;
@property (nonatomic , assign) NSInteger              score;
@property (nonatomic , copy) NSString              * tableCode;
@property (nonatomic , copy) NSString              * validAccount;

@end


@interface DSBProfitBoardUsrModel :CNBaseModel
@property (nonatomic , strong) NSNumber              * betAmountSum;
@property (nonatomic , assign) NSInteger              clubLevel;
@property (nonatomic , strong) NSNumber              * cusAmountSum;
@property (nonatomic , assign) NSInteger              customerLevel;
@property (nonatomic , copy) NSString              * headshot;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , strong) NSArray <PrListItem *>              * prList;

@property (copy,nonatomic,readonly) NSString *writtenLevel; 
@end

NS_ASSUME_NONNULL_END
