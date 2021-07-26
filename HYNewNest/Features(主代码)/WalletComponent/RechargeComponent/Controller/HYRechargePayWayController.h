//
//  HYRechargeSwitchPayWayController.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseVC.h"
#import "PayWayV3Model.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PaywayType) {
    PaywayTypePaywayV3,    //人民币渠道
    PaywayTypeDepositBank, //usdt渠道
    PaywayTypeBQBank,        //选择银行
};

@interface HYRechargePayWayController : CNBaseVC

//- (instancetype)initWithDepositModels:(NSArray<DepositsBankModel *> *)models
//                              selcIdx:(NSInteger)selcIdx;

- (instancetype)initWithPaywayItems:(NSArray<PayWayV3PayTypeItem *> *)models
                            selcIdx:(NSInteger)selcIdx;

//- (instancetype)initWithBQbanks:(NSArray<BQBankModel *> *)models
//                        selcIdx:(NSInteger)selcIdx;

@end

NS_ASSUME_NONNULL_END
