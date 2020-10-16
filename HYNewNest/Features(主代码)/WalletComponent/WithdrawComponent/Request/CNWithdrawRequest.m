//
//  CNWithdrawRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNWithdrawRequest.h"

@implementation CNWithdrawRequest

+ (void)transferBalanceToLocalHandler:(HandlerBlock)handler {
    [self POST:kGatewayPath(config_transfer_to_local) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}

+ (void)withdrawCalculatorMode:(NSNumber *)mode
                        amount:(NSNumber *)amount
                       accountId:(NSString *)accountId
                         handler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"amount"] = amount;
    param[@"accountId"] = accountId;
    
    [self POST:kGatewayPath(config_calculateSeparate) parameters:param completionHandler:handler];
}

+ (void)submitWithdrawRequestAmount:(NSNumber *)amount
                          accountId:(NSString *)accountId
                           protocol:(NSString *)protocol
                            remarks:(NSString *)remarks
                   subWallAccountId:(NSString *)subWallAccountId
                            handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"amount"] = amount;
    param[@"accountId"] = accountId;
    param[@"protocol"] = protocol;
    param[@"remarks"] = remarks;
    param[@"subWallAccountId"] = subWallAccountId;
    
    [self POST:kGatewayPath(config_drawCreateRequest) parameters:param completionHandler:handler];
}

@end
