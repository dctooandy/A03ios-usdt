//
//  CNWithdrawRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNWithdrawRequest.h"
#import <IVLoganAnalysis/IVLAManager.h>

@implementation CNWithdrawRequest

+ (void)transferBalanceToLocalHandler:(HandlerBlock)handler {
    [self POST:(config_transfer_to_local) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}

+ (void)withdrawCalculatorMode:(NSNumber *)mode
                        amount:(nullable NSNumber *)amount
                     accountId:(nullable NSString *)accountId
                       handler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"mode"] = mode;
    param[@"amount"] = amount;
    param[@"accountId"] = accountId;
    
    [self POST:(config_calculateSeparate) parameters:param completionHandler:handler];
}

+ (void)submitWithdrawRequestAmount:(NSNumber *)amount
                          accountId:(NSString *)accountId
                           protocol:(NSString *)protocol
                            remarks:(NSString *)remarks
                   subWallAccountId:(nullable NSString *)subWallAccountId
                           password:(NSString *)password
                            handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"amount"] = amount;
    param[@"accountId"] = accountId;
    param[@"protocol"] = protocol;
    param[@"remarks"] = remarks;
    param[@"subWallAccountId"] = subWallAccountId;
    param[@"password"] = password;
    
    [self POST:(config_drawCreateRequest) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            if ([[responseObj allKeys] containsObject:@"referenceId"]) {
                dispatch_async(dispatch_queue_create(0, 0), ^{
                    // 取款成功埋点
                    [IVLAManager singleEventId:@"A03_withdraw_create" errorCode:@"" errorMsg:@"" customsData:@{@"requestId":responseObj[@"referenceId"]}];
                });
            }
        }
        handler(responseObj, errorMsg);
    }];
}

+ (void)getBalancesHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [self POST:(config_getBalances) parameters:param completionHandler:handler];
}

+ (void)getUserMobileStatusCompletionHandler:(nullable HandlerBlock)completionHandler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"inclMobileNo"] = @(1);
    paramDic[@"inclMobileNoBind"] = @(1);
    paramDic[@"inclRealName"] = @(1);
    paramDic[@"inclExistsWithdralPwd"] = @1;
    
    [self POST:(config_getByLoginName) parameters:paramDic completionHandler:^(id responseObj, NSString *errorMsg) {
        [[CNUserManager shareManager] saveUserMobileStatus:responseObj];
        if (completionHandler) {
            completionHandler(responseObj, errorMsg);
        }
    }];
}

+ (void)checkIsNeedWithdrawPwdHandler:(HandlerBlock)handler {
    NSDictionary *param = @{@"bizCode" : @"WITHDRAL_PWD_FLAG"};
    [self POST:(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            handler(responseObj[@"data"], errorMsg);
        }
    }];
}

@end
