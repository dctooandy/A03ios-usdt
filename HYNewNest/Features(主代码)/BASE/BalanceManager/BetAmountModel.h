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
@interface PromoteRebateModel : CNBaseModel

@property (nonatomic, strong) NSNumber *promoAmount; //月优惠
@property (nonatomic, strong) NSNumber *rebateAmount; //月洗码

@end



/// 投注额
@interface BetAmountModel : CNBaseModel

@property(nonatomic,assign) NSUInteger customerLevel;    //等级
@property(nonatomic,strong) NSNumber *minNextBetAmount; //有效投注额
@property(nonatomic,strong) NSNumber *weekBetAmount;    //周投注额
@property (strong,nonatomic) PromoteRebateModel *statis; //!<本月优惠和洗码
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


#pragma mark - 新钱包
@interface NewWalletBalance : CNBaseModel
// 可转换额度
@property (strong,nonatomic) NSNumber *moneyChangeAmount;
// 不可提现额度
@property (strong,nonatomic) NSNumber *nonWithDrawable;
// 优惠额度
@property (strong,nonatomic) NSNumber *promotion;
// 可提现额度
@property (strong,nonatomic) NSNumber *withdrawable;
@end

UIKIT_EXTERN NSString * DBName_AccountBalance;
/// 账户余额
@interface AccountMoneyDetailModel : CNBaseModel
// 用户总额：balance=withdrawable+promotion+nonWithdrawable
@property (strong,nonatomic) NSNumber *balance;
@property (strong,nonatomic) NSNumber *localBalance;
@property (strong,nonatomic) NSString *currency;
@property (strong,nonatomic) NSNumber *minWithdrawAmount;
@property (strong,nonatomic) NSNumber *maxWithdrawAmount;
@property (strong,nonatomic) NSArray<platformBalancesItem *> *platformBalances;
// 厅方总额
@property (strong,nonatomic) NSNumber *platformTotalBalance;
// 可提现余额（新钱包放在walletBalance里面）
@property (strong,nonatomic) NSNumber *withdrawBal;
@property (strong,nonatomic) NSNumber *yebInterest;
@property (strong,nonatomic) NSNumber *yebAmount;
// 新钱包
@property (strong,nonatomic) NewWalletBalance *walletBalance;

@property (nonatomic, strong) NSString *primaryKey;
@end


NS_ASSUME_NONNULL_END
