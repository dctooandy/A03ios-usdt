//
//  BYDeleteBankCardVC.h
//  HYNewNest
//
//  Created by RM03 on 2021/10/29.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseVC.h"
#import "CNAddressInfoTCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYDeleteBankCardVC : UIViewController
//+ (void)modalVc;
+ (void)modalVcWithBankModel:(AccountModel*) accounts handler:(HandlerBlock)handler ;
@end

NS_ASSUME_NONNULL_END
