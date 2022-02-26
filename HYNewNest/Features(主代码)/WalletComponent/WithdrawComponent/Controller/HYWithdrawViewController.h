//
//  HYWithdrawViewController.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseVC.h"
#import "KYMWithdrewCheckModel.h"
NS_ASSUME_NONNULL_BEGIN
@class WithdrawCalculateModel;
@interface HYWithdrawViewController : CNBaseVC
@property (nonatomic, assign) BOOL isMatchWithdraw; //是否为撮合取款
@property (nonatomic, strong) KYMWithdrewCheckModel *checkModel;
@property (nonatomic, strong) WithdrawCalculateModel *calculatorModel; //CNY needed
@end

NS_ASSUME_NONNULL_END
