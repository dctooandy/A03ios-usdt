//
//  BYDepositUsdtVC.h
//  HYNewNest
//
//  Created by zaky on 6/21/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYDepositUsdtVC : CNBaseVC
//新手任務2.0 建議儲值金額
@property (nonatomic, assign) int suggestRecharge;
@property (nonatomic, copy) NSString *amount_list; //快捷输入金额
@end

NS_ASSUME_NONNULL_END
