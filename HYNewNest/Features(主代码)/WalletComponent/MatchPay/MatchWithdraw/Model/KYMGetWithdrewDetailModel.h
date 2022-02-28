//
//  KYMGetWithdrewDetailModel.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYMWidthdrewUtility.h"

typedef NS_ENUM(NSInteger, KYMWithdrewDetailStatus) {
    KYMWithdrewDetailStatusSubmit = 0, //撮合提交
    KYMWithdrewDetailStatusDoing = 1, //撮合处理中
    KYMWithdrewDetailStatusSuccess = 2, //撮合成功
    KYMWithdrewDetailStatusFaild = -1, //撮合失败
};
typedef NS_ENUM(NSInteger, KYMWithdrewStatus) {
    KYMWithdrewStatusSubmit1 = 0, //撮合提交
    KYMWithdrewStatusSubmit = 1, //撮合提交
    KYMWithdrewStatusWaiting = 2, //取款等待
    KYMWithdrewStatusNotMatch = 3, //取款未匹配
    KYMWithdrewStatusTimeout = 4, //取款超时
    KYMWithdrewStatusConfirm = 5, //取款确认
    KYMWithdrewStatusFaild = 6, //取款失败
    KYMWithdrewStatusSuccessed = 100, //取款成功
};

NS_ASSUME_NONNULL_BEGIN
@interface KYMGetWithdrewDetailDataModel : NSObject
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *bankAccountName;
@property (nonatomic, copy) NSString *bankAccountNo;
@property (nonatomic, copy) NSString *bankAccountType;
@property (nonatomic, copy) NSString *bankBanckName;
@property (nonatomic, copy) NSString *bankCity;
@property (nonatomic, copy) NSString *bankCode;
@property (nonatomic, copy) NSString *bankIcon;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankProvince;
@property (nonatomic, copy) NSString *bankUrl;
@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *processedDate;
@property (nonatomic, copy) NSString *loginName;
@property (nonatomic, copy) NSString *merchant;
@property (nonatomic, assign) KYMWithdrewStatus status; //取款当前状态
@property (nonatomic, copy) NSString *transactionId; //取款单号
@property (nonatomic, copy) NSString *confirmTime; // 确认时间
@property (nonatomic, copy) NSString *confirmTimeFmt; //确认时间倒计时
@property (nonatomic, assign) KYMWithdrewStatus depositStatus; //对应的撮合单存款状态
@end



@interface KYMGetWithdrewDetailModel : NSObject
@property (nonatomic, assign) KYMWithdrewDetailStatus matchStatus;
@property (nonatomic, copy) NSString *withdrawType;
@property (nonatomic, copy) NSString *matchConfirmStatus;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic, copy) KYMGetWithdrewDetailDataModel *data;
@end

NS_ASSUME_NONNULL_END
