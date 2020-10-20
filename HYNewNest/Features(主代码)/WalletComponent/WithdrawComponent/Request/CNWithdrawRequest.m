//
//  CNWithdrawRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNWithdrawRequest.h"
#import <IVLAManager.h>

@implementation CNWithdrawRequest

+ (void)transferBalanceToLocalHandler:(HandlerBlock)handler {
    [self POST:kGatewayPath(config_transfer_to_local) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}

+ (void)withdrawCalculatorMode:(NSNumber *)mode
                        amount:(nullable NSNumber *)amount
                     accountId:(nullable NSString *)accountId
                       handler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"mode"] = mode;
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
    
    [self POST:kGatewayPath(config_drawCreateRequest) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            if ([[responseObj allKeys] containsObject:@"referenceId"]) {
                dispatch_async(dispatch_queue_create(0, 0), ^{
                    // 取款成功埋点
                    [IVLAManager singleEventId:@"A03_withdraw_create" errorCode:@"" errorMsg:@"" customsData:@{@"requestId":responseObj[@"referenceId"]}];
                });
            }
        }
    }];
}

+ (void)getBalancesHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [self POST:kGatewayPath(config_getBalances) parameters:param completionHandler:handler];
}

@end
