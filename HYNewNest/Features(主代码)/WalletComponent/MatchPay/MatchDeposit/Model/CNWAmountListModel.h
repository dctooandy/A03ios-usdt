//
//  CNWAmountListModel.h
//  HYNewNest
//
//  Created by cean on 2/26/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"
#import "CNMBankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNWAmountListModel : CNBaseModel
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, assign) BOOL isRecommend;
@end


@interface CNWFastPayModel : CNBaseModel
/// 渠道是否开启
@property (nonatomic, assign) BOOL isAvailable;
/// 金额列表，撮合系统使用
@property (nonatomic, copy, nullable) NSArray <CNWAmountListModel *> *amountList;
@property (nonatomic, copy) NSString *remainDepositTimes;
@property (nonatomic, copy) NSString *remainCancelDepositTimes;
/// 存在撮合，1 存款，2 取款
@property (nonatomic, assign) NSInteger mmProcessingOrderType;
/// 存在撮合单ID
@property (nonatomic, copy) NSString *mmProcessingOrderTransactionId;
/// 2-存款等待 展示存款确认，其他展示催单
@property (nonatomic, assign) CNMPayBillStatus mmProcessingOrderStatus;
@property (nonatomic, copy) NSString *mmProcessingOrderAmount;

/// 是否需要上传凭证， = 1 时需要先上传
@property (nonatomic, assign) NSInteger needUploadFlag;

@end

NS_ASSUME_NONNULL_END
