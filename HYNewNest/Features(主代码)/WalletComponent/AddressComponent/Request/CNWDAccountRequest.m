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
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    // 0 仅查询银行账户  1 查询当前账户和子账户(usdt)列表  2 仅查询子账户列表
    // subWalletAccounts
    param[@"queryType"] = @1;
    [self POST:kGatewayPath(config_getQueryCard) parameters:param completionHandler:handler];
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
    param[@"accountNo"] = accountNo;
    param[@"accountNo2"] = accountNo;
    param[@"accountType"] = @"DCBOX";
    param[@"walletType"] = @"DCBOX";
    param[@"bankName"] = @"DCBOX";
    param[@"protocol"] = @"ERC20";
    param[@"accountName"] = [CNUserManager shareManager].printedloginName;
    param[@"flag"] = isOneKey?@1:@2;
    if (validateId) {
        param[@"validateId"] = validateId;
    }
    if (messageId) {
        param[@"messageId"] = messageId;
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
    param[@"accountNo"] = accountNo;
    param[@"bankAlias"] = bankAlias;
    param[@"accountType"] = @"USDT";
    param[@"walletType"] = @"USDT";
    param[@"accountName"] = [CNUserManager shareManager].printedloginName;
    param[@"protocol"] = [self autoUsdtProtocolAccountNo:accountNo];
    [param setObject:@2 forKey:@"flag"];
    if (validateId) {
        param[@"validateId"] = validateId;
    }
    if (messageId) {
        param[@"messageId"] = messageId;
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
