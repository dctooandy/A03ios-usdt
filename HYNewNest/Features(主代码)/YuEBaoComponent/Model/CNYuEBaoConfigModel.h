//
//  CNYuEBaoConfigModel.h
//  HYNewNest
//
//  Created by zaky on 5/15/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNYuEBaoConfigModel : CNBaseModel
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , assign) NSInteger              configId;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , assign) NSInteger              maxAmount; //最大存入金额 -1代表不限制
@property (nonatomic , assign) NSInteger              maxHours;
@property (nonatomic , assign) NSInteger              minAmount; //最小存入金额
@property (nonatomic , assign) NSInteger              minHours;
@property (nonatomic , assign) NSInteger              periodHours; //核算周期（用户下次计息时间 = 当前时间 + periodHours）
@property (nonatomic , copy) NSString              * rate;
@property (nonatomic , assign) NSInteger              supportMulti;
@property (nonatomic , copy) NSString              * value;
@property (nonatomic , copy) NSString              * yearRate; //n% 年利率
@property (nonatomic , strong) NSNumber            * yebAmount; //过夜利息本金
@property (nonatomic , strong) NSNumber            * yebInterest; //过夜利息利息
@end

NS_ASSUME_NONNULL_END
