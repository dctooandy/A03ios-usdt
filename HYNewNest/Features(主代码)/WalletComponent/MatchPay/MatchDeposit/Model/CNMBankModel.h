//
//  CNMBankModel.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/21/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 订单状态 1-存款提交 2-存款等待 3-存款取消 4-存款超时 5-存款确认 6-存款未匹配 100-存款完成
typedef NS_ENUM(NSUInteger, CNMPayBillStatus) {
    CNMPayBillStatusSubmit = 1,
    CNMPayBillStatusPaying,
    CNMPayBillStatusCancel,
    CNMPayBillStatusTimeout,
    CNMPayBillStatusConfirm,
    CNMPayBillStatusUnMatch,
    CNMPayBillStatusSuccess = 100,
};

@interface CNMBankModel : CNBaseModel
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *bankAccountName;
@property (nonatomic, copy) NSString *bankAccountNo;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankBranchName;
@property (nonatomic, copy) NSString *bankCity;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankIcon;

/// 单号
@property (nonatomic, copy) NSString *transactionId;
/// 确认按钮倒计时
@property (nonatomic, assign) NSInteger createdDateFmt;
@property (nonatomic, copy) NSString *currency;
/// 1-存款提交 2-存款等待 3-存款取消 4-存款超时 5-存款确认 6-存款未匹配 100-存款完成
@property (nonatomic, assign) CNMPayBillStatus status;
/// 是否需要上传凭证
@property (nonatomic, assign) BOOL needUploadFlag;
@end

NS_ASSUME_NONNULL_END
