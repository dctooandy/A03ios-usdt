//
//  CNWDAddressRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNWDAccountRequest.h"

@implementation CNWDAccountRequest

+ (void)queryAccountHandler:(HandlerBlock)handler {
    [self POST:kGatewayPath(config_getQueryCard) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}

+ (void)deleteAccountId:(NSString *)accountId
                handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"accountId"] = accountId;
    
    [self POST:kGatewayPath(config_deleteAccount) parameters:param completionHandler:handler];
}

+ (void)getBankCardBinByBankCardNo:(NSString *)bankCardNo   handler:(HandlerBlock)handler {
    kPreventRepeatTime(0.5);
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"bankCardNo"] = bankCardNo;
    
    [self POST:kGatewayPath(config_getByCardBin) parameters:param completionHandler:handler];
}

+ (void)createAccountBankCardNo:(NSString *)accountNo
                       bankName:(NSString *)bankName
                    accountType:(NSString *)accountType
                 bankBranchName:(NSString *)bankBranchName
                       province:(NSString *)province
                           city:(NSString *)city
                      messageId:(NSString *)messageId
                     validateId:(NSString *)validateId
                         expire:(NSString *)expire
                        handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"accountNo"] = accountNo;
    param[@"bankName"] = bankName;
    param[@"accountType"] = accountType;
    param[@"bankBranchName"] = bankBranchName;
    param[@"province"] = province;
    param[@"city"] = city;
    param[@"messageId"] = messageId;
    param[@"validateId"] = validateId;
    param[@"expire"] = expire;
    
    [self POST:kGatewayPath(config_createBank) parameters:param completionHandler:handler];
    
}

+ (void)createAccountDCBoxAccountNo:(NSString *)accountNo
                           isOneKey:(BOOL)isOneKey
                         validateId:(nullable NSString *)validateId
                          messageId:(nullable NSString *)messageId
                            handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:accountNo forKey:@"accountNo"];
    [param setObject:accountNo forKey:@"accountNo2"];
    [param setObject:@"DCBOX" forKey:@"accountType"];
    [param setObject:@"DCBOX" forKey:@"walletType"];
    [param setObject:@"DCBOX" forKey:@"bankName"];
    [param setObject:@"ERC20" forKey:@"protocol"];
    [param setObject:[CNUserManager shareManager].printedloginName forKey:@"accountName"];
    [param setObject:isOneKey?@(1):@(2) forKey:@"flag"];
    if (validateId) {
        [param setObject:validateId forKey:@"validateId"];
    }
    if (messageId) {
        [param setObject:messageId forKey:@"messageId"];
    }
    
    [self POST:kGatewayPath(config_create) parameters:param completionHandler:handler];
    
}

+ (void)createAccountUSDTAccountNo:(NSString *)accountNo
                         bankAlias:(NSString *)bankAlias
                        validateId:(nullable NSString *)validateId
                         messageId:(nullable NSString *)messageId
                           handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    // 协议改为自动判定
    [param setObject:accountNo  forKey:@"accountNo"];
    [param setObject:bankAlias forKey:@"bankAlias"];
    [param setObject:@"USDT" forKey:@"accountType"];
    [param setObject:@"USDT" forKey:@"walletType"];
    [param setObject:[CNUserManager shareManager].printedloginName forKey:@"accountName"];
    [param setObject:[self autoUsdtProtocolAccountNo:accountNo] forKey:@"protocol"];
    [param setObject:@(2) forKey:@"flag"];
    if (validateId) {
        [param setObject:validateId forKey:@"validateId"];
    }
    if (messageId) {
        [param setObject:messageId forKey:@"messageId"];
    }

    [self POST:kGatewayPath(config_create) parameters:param completionHandler:handler];
}

+ (NSString *)autoUsdtProtocolAccountNo:(NSString *)accountNo {
    if (!KIsEmptyString(accountNo)) {
        if ([accountNo hasPrefix:@"1"] || [accountNo hasPrefix:@"3"]) {
            return @"OMNI";
        } else if ([accountNo hasPrefix:@"0x"]) {
            return @"ERC20";
        } else if ([accountNo hasPrefix:@"T"]) {
            return @"TRC20";
        }
    }
    return @"ERC20";
}

+ (void)createGoldAccountSmsCode:(NSString *)smsCode
                       messageId:(NSString *)messageId
                         handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"use"] = @8;
    param[@"smsCode"] = smsCode;
    param[@"messageId"] = messageId;
    
    [self POST:kGatewayPath(config_createGoldAccount) parameters:param completionHandler:handler];
}


@end
