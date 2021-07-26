//
//  BYWithdrawVC.h
//  HYNewNest
//
//  Created by RM04 on 2021/7/7.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseVC.h"
#import "AccountModel.h"
#import "BetAmountModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol BYWithdrawDelegate
- (void)sumitWithdrawSuccess;
@end

@interface BYWithdrawConfirmVC : CNBaseVC
- (instancetype)initWithDelegate:(id<BYWithdrawDelegate>)delegate selectedBankAccount:(AccountModel *)account andAvailableBalance:(AccountMoneyDetailModel *)balance;
@end

NS_ASSUME_NONNULL_END
