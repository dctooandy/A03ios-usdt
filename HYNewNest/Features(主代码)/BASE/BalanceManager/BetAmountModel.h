//
//  BetAmountModel.h
//  HYGEntire
//
//  Created by zaky on 04/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "CNBaseModel.h"
#import <BGFMDB/BGFMDB.h>

NS_ASSUME_NONNULL_BEGIN


/// 本月优惠和洗码
@interface PromoteXimaModel : CNBaseModel

@property (nonatomic, strong) NSNumber *promoAmountByMonth; //月优惠
@property (nonatomic, strong) NSNumber *rebatedAmountByMonth; //月洗码

@end



/// 投注额
@interface BetAmountModel : CNBaseModel

@property(nonatomic,strong) NSNumber *customerLevel;    //等级
@property(nonatomic,strong) NSNumber *minNextBetAmount; //有效投注额
@property(nonatomic,strong) NSNumber *weekBetAmount;    //周投注额

@end




/// 平台余额
@interface platformBalancesItem : CNBaseModel
@property (strong,nonatomic) NSNumber *balance;
@property (nonatomic, assign) NSUInteger gameKind;
@property (nonatomic, strong) NSString *platformCode;
@property (nonatomic, strong) NSString *platformCurrency;
@property (nonatomic, strong) NSString *platformName;
@property (nonatomic, assign) NSUInteger sortNo;

@end



UIKIT_EXTERN NSString * DBName_AccountBalance;
/// 账户余额
@interface AccountMoneyDetailModel : CNBaseModel

@property (strong,nonatomic) NSNumber *balance;
@property (strong,nonatomic) NSNumber *localBalance;
@property (strong,nonatomic) NSString *currency;
@property (assign,nonatomic) NSNumber *minWithdrawAmount;
@property (strong,nonatomic) NSArray<platformBalancesItem *> *platformBalances;
@property (strong,nonatomic) NSNumber *platformTotalBalance;
@property (strong,nonatomic) NSNumber *withdrawBal;
@property (strong,nonatomic) NSNumber *yebInterest;
@property (strong,nonatomic) NSNumber *yebAmount;

@property (nonatomic, strong) NSString *primaryKey;
@end

NS_ASSUME_NONNULL_END
