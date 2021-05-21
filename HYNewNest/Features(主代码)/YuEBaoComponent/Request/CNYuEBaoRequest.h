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

NS_ASSUME_NONNULL_BEGIN

@interface CNYuEBaoRequest : CNBaseNetworking

+ (void)checkYuEBaoInterestLogsSumHandler:(HandlerBlock)handler;
+ (void)checkYuEBaoTicketsHandler:(HandlerBlock)handler;
+ (void)transferInYuEBaoAmount:(NSNumber *)amount
                       handler:(HandlerBlock)handler;
+ (void)transferOutYuEBaoAmount:(NSNumber *)amount
                        handler:(HandlerBlock)handler;
+ (void)checkYuEBaoConfigHandler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
