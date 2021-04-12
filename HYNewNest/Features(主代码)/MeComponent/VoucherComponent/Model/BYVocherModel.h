//
//  BYVocherModel.h
//  HYNewNest
//
//  Created by zaky on 3/17/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYVocherModel : CNBaseModel
@property (nonatomic , copy) NSString              * activityId; //!<优惠配置ID
@property (nonatomic , copy) NSString              * amountDemand;
@property (nonatomic , assign) NSInteger              bonusAmount; //!<优惠券金额
@property (nonatomic , copy) NSString              * createDate; //!<优惠券发放时间
@property (nonatomic , strong) NSNumber              * depositAmount; //!<存款本金
@property (nonatomic , assign) NSInteger              depositPromotion;
@property (nonatomic , copy) NSString              * enableDate; //!<有效期
@property (nonatomic , assign) NSInteger              finishedBetAmount; //!<已打流水
@property (nonatomic , assign) NSInteger              isDepositPromotion;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , assign) NSInteger              lockSurplusAmount;
@property (nonatomic , assign) NSInteger              missingBetAmount;
@property (nonatomic , assign) NSInteger              order;
@property (nonatomic , copy) NSString              * prizeName;
@property (nonatomic , copy) NSString              * prizeNo; //!< 优惠券编号
@property (nonatomic , copy) NSString              * productId;
@property (nonatomic , assign) NSInteger              profitAmount; //!<优惠盈利
@property (nonatomic , copy) NSString              * promotionName; //!<优惠大类
@property (nonatomic , assign) NSInteger              rebateEnable;
@property (nonatomic , assign) NSInteger              releaseAmount; //!<释放额度
@property (nonatomic , copy) NSString              * remarks;
@property (nonatomic , assign) NSInteger              status; //!<优惠券状态
@property (nonatomic , assign) NSInteger              surplusAmount;
@property (nonatomic , assign) NSInteger              totalAmount; //!<优惠券总额 不需要多个字段加起来
@property (nonatomic , assign) NSInteger              unlockBetAmount; //!<流水要求
@property (nonatomic , assign) NSInteger              unlockBetMultiple;
@property (copy,nonatomic) NSString                * platforms; //!<支持平台
@end

NS_ASSUME_NONNULL_END
