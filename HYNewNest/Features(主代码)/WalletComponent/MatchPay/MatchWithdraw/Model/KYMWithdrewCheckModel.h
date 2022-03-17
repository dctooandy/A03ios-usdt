//
//  KYMWithdrewCheckModel.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWithdrewAmountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrewCheckDataModel : NSObject
@property (nonatomic, strong) NSArray<KYMWithdrewAmountModel *> *amountList;
@property (nonatomic, strong) NSArray<KYMWithdrewAmountModel *> *currentAmountList;
@property (nonatomic, copy) NSString *inputAmount;
@property (nonatomic, copy) NSString *miniAmount;
@property (nonatomic, assign) BOOL isAvailable;
@property (nonatomic, copy) NSString *remainWithdrawTimes;
@property (nonatomic, copy) NSString *remainCancelDepositTimes;
@property (nonatomic, copy) NSString *mmProcessingOrderTransactionId;
@property (nonatomic, copy) NSString *mmProcessingOrderAmount;
@property (nonatomic, assign) NSInteger mmProcessingOrderStatus;
@property (nonatomic, assign) NSInteger mmProcessingOrderPairStatus;
/// 存在撮合，1 存款，2 取款
@property (nonatomic, assign) NSInteger mmProcessingOrderType;
//移除大于用户余额的项
- (void)removeAmountBiggerThanTotal:(NSString *)totatlAmount;
@end

@interface KYMWithdrewCheckModel : NSObject
@property (nonatomic, strong) KYMWithdrewCheckDataModel *data;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *requestId;
@end

NS_ASSUME_NONNULL_END
