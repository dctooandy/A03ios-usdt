//
//  CNRecordDetailVC.h
//  HYNewNest
//
//  Created by Cean on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseVC.h"
#import "CreditQueryResultModel.h"

typedef enum : NSUInteger {
    CNRecordTypeDeposit,  //充值
    CNRecordTypeWithdraw, //提现
    CNRecordTypeXima,     //洗码
    CNRecordTypePromo,    //优惠
    CNRecordTypeTouZhu,   //投注
} CNRecordDetailType;

NS_ASSUME_NONNULL_BEGIN

@interface CNRecordDetailVC : CNBaseVC
- (instancetype)initWithType:(CNRecordDetailType)detailType;
@property (nonatomic, strong) CreditQueryDataModel *model;
@end

NS_ASSUME_NONNULL_END
