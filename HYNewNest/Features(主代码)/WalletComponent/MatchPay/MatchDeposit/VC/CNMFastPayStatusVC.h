//
//  CNMFastPayStatusVC.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/17/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMDepositBaseVC.h"
#import "CNMBankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNMFastPayStatusVC : CNMDepositBaseVC
/// 订单号
@property (nonatomic, copy) NSString *transactionId;
/// 剩余取消次数
@property (nonatomic, assign) NSInteger cancelTime;
///  YES 回到上一级页面，NO 回到 rootVC，默认NO
@property (nonatomic, assign) BOOL backToLastVC;
@end

NS_ASSUME_NONNULL_END
