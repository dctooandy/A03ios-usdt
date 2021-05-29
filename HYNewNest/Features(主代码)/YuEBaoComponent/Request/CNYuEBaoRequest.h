//
//  CNYuEBaoRequest.h
//  HYNewNest
//
//  Created by zaky on 5/14/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "CNYuEBaoConfigModel.h"
#import "CNYuEBaoBalanceModel.h"
#import "CNYuEBaoTransferModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YEBTransferType) {
    YEBTransferTypeWithdraw = 0,
    YEBTransferTypeDeposit,
};

@interface CNYuEBaoRequest : CNBaseNetworking

+ (void)checkYuEBaoInterestLogsSumHandler:(HandlerBlock)handler;
+ (void)checkYuEBaoTicketsHandler:(HandlerBlock)handler;
+ (void)transferYuEBaoType:(YEBTransferType)type
                    amount:(NSNumber *)amount
                   handler:(HandlerBlock)handler;
+ (void)checkYuEBaoConfigHandler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
