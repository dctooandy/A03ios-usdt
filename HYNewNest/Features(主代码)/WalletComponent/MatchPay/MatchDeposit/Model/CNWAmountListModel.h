//
//  CNWAmountListModel.h
//  HYNewNest
//
//  Created by cean on 2/26/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNWAmountListModel : CNBaseModel
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, assign) BOOL isRecommend;
@end


@interface CNWFastPayModel : CNBaseModel
/// 渠道是否开启
@property (nonatomic, assign) BOOL isAvailable;
/// 金额列表，撮合系统使用
@property (nonatomic, copy) NSArray <CNWAmountListModel *> *amountList;
@property (nonatomic, copy) NSString *remainDepositTimes;
@property (nonatomic, copy) NSString *remainCancelDepositTimes;
/// 存在撮合，1 存款，2 取款
@property (nonatomic, assign) NSInteger mmProcessingOrderType;
/// 存在撮合单ID
@property (nonatomic, copy) NSString *mmProcessingOrderTransactionId;
@end

NS_ASSUME_NONNULL_END
