//
//  CNLoginRequest.m
//  LCNewApp
//
//  Created by cean.q on 2019/11/25.
//  Copyright © 2019 B01. All rights reserved.
//

#import "CNLoginRequest.h"
#import "CNEncrypt.h"
#import "HYNetworkConfigManager.h"

@implementation CNLoginRequest

+ (void)getImageCodeWithType:(CNImageCodeType)type
           completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @(type);
    
    [self POST:kGatewayPath(config_generateCaptcha) parameters:paras completionHandler:completionHandler];
}

+ (void)getSMSCodeWithType:(CNSMSCodeType)type
                     phone:(NSString *)phone
         completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [NSMutableDictionary new];
    paras[@"productId"] = @"A03";
    paras[@"use"] = @(type);
//    paras[@"mobileNo"] = [CNEncrypt encryptString:phone];
    paras[@"mobileNo"] = phone;
    
    [self POST:kGatewayPath(config_SendCodePhone) parameters:paras completionHandler:completionHandler];
}

+ (void)getSMSCodeByLoginNameType:(CNSMSCodeType)type   completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @(type);
    
    [self POST:kGatewayPath(config_sendCodeByLoginName) parameters:paras completionHandler:completionHandler];
}

+ (void)verifySMSCodeWithType:(CNSMSCodeType)type
                      smsCode:(NSString *)smsCode
                    smsCodeId:(NSString *)smsCodeId
            completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @(type);
    paras[@"smsCode"] = smsCode;
    paras[@"messageId"] = smsCodeId;
    
    [self POST:kGatewayPath(config_verifySmsCode) parameters:paras completionHandler:completionHandler];
}

//+ (void)accountPreLogin:(NSString *)account
//      completionHandler:(HandlerBlock)completionHandler {
//
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    paras[@"loginName"] = account;
//
//    [self POST:LCAccountPreLoginPath parameters:paras completionHandler:completionHandler];
//}

+ (void)accountLogin:(NSString *)account
            password:(NSString *)password
           messageId:(NSString *)messageId
           imageCode:(NSString *)imageCode
         imageCodeId:(NSString *)imageCodeId
   completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [NSMutableDictionary new];
    paras[@"productId"] = @"A03";
    paras[@"messageId"] = messageId;
    // ???: 加密就会失败
//    paras[@"loginName"] = [CNEncrypt encryptString:account];
//    paras[@"verifyStr"] = [CNEncrypt encryptString:password];
    paras[@"loginName"] = account;
    paras[@"verifyStr"] = password;
    paras[@"captcha"] = imageCode;
    paras[@"captchaId"] = imageCodeId;

    [self POST:kGatewayPath(config_LoginEx) parameters:paras completionHandler:^(NSDictionary *responseObj, NSString *errorMsg) {
        if ([responseObj isKindOfClass:[NSDictionary class]] && [responseObj.allKeys containsObject:@"samePhoneLoginNames"]) {
            completionHandler(responseObj, errorMsg);
        } else {
            if (!errorMsg) {
                [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
                [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 请求详细信息
                //            [self checkTopDomainSuccessHandler:nil]; //查询是否白名单用户
            }
            completionHandler(responseObj, errorMsg);
        }
    }];
}

+ (void)mulLoginSelectedLoginName:(NSString *)loginName
                        messageId:(NSString *)messageId
                       validateId:(NSString *)validateId
                completionHandler:(HandlerBlock)completionHandler{
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:loginName forKey:@"loginName"];
    [param setObject:messageId forKey:@"messageId"];
    [param setObject:validateId forKey:@"validateId"];
    
    [self POST:kGatewayPath(config_loginMessageIdAndLoginName) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
            [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 请求详细信息
            //        [self checkTopDomainSuccessHandler:nil]; //查询是否白名单用户
        }
        completionHandler(responseObj, errorMsg);
    }];
}

//+ (void)phoneLoginSmsCode:(NSString *)smsCode
//                smsCodeId:(NSString *)smsCodeId
//               validateId:(NSString *)validateId
//        completionHandler:(HandlerBlock)completionHandler {
//
//    NSMutableDictionary *paras = [kNetworkMgr baseParam];
//    paras[@"smsCode"] = smsCode;
//    paras[@"messageId"] = smsCodeId;
//    paras[@"validateId"] = validateId;
//
//    [self POST:LCPhoneLoginPath parameters:paras completionHandler:completionHandler];
//}

//+ (void)creatTryAcountCompletionHandler:(HandlerBlock)completionHandler {
//    NSMutableDictionary *paras = [NSMutableDictionary new];
//    paras[@"productId"] = @"A03";
//    [self POST:kGatewayPath(config_createTryAccount) parameters:paras completionHandler:^(id responseObj, NSString *errorMsg) {
//        [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
//        [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 请求详细信息
//        completionHandler(responseObj, errorMsg);
//    }];
//}

+ (void)accountRegisterUserName:(NSString *)loginName
                       password:(NSString *)password
               completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"loginName"] = loginName;
//    paras[@"password"] = [CNEncrypt encryptString:password];
    paras[@"password"] = password;

    [self POST:kGatewayPath(config_registUserName) parameters:paras completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
            [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 请求详细信息
            //        [self checkTopDomainSuccessHandler:nil]; //查询是否白名单用户
        }
        completionHandler(responseObj, errorMsg);
    }];
}

//
//+ (void)phoneRegisterSmsCode:(NSString *)smsCode
//                   smsCodeId:(NSString *)smsCodeId
//                    password:(NSString *)password
//                  validateId:(NSString *)validateId
//           completionHandler:(HandlerBlock)completionHandler {
//    
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    paras[@"smsCode"] = smsCode;
//    paras[@"messageId"] = smsCodeId;
//    paras[@"password"] = [CNEncrypt encryptString:password];
//    paras[@"validateId"] = validateId;
//
//    [self POST:LCPhoneRegisterPath parameters:paras completionHandler:completionHandler];
//}
//

//+ (void)modifyLoginName:(NSString *)loginName
//           newLoginName:(NSString *)newLoginName
//               password:(NSString *)password
//      completionHandler:(HandlerBlock)completionHandler {
//
//    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
//    paras[@"loginName"] = loginName;
//    paras[@"userAccount"] = newLoginName;
//    paras[@"password"] = [CNEncrypt encryptString:password];
//    paras[@"type"] = @"1";
//
//    [self POST:LCModifyAccountPath parameters:paras completionHandler:completionHandler];
//}

+ (void)modifyPassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
     completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
//    paras[@"oldPassword"] = [CNEncrypt encryptString:oldPassword];
//    paras[@"newPassword"] = [CNEncrypt encryptString:newPassword];
    paras[@"oldPassword"] = oldPassword;
    paras[@"newPassword"] = newPassword;
    paras[@"type"] = @"1";
    
    [self POST:kGatewayPath(config_modifyPwd) parameters:paras completionHandler:completionHandler];
}


+ (void)forgetPasswordValidateSmsCode:(NSString *)smsCode
                            messageId:(NSString *)messageId
                             phoneNum:(NSString *)phone
                    completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"use"] = @(2);
    param[@"smsCode"] = smsCode;
    param[@"messageId"] = messageId;
    param[@"phone"] = phone;
    
    [self POST:kGatewayPath(config_forgetPassword_validate) parameters:param completionHandler:completionHandler];
}

+ (void)modifyPasswordLoginName:(NSString *)loginName
                      smsCode:(NSString *)smsCode
                  newPassword:(NSString *)newPassword
                   validateId:(NSString *)validateId
                    messageId:(NSString *)messageId
            completionHandler:(HandlerBlock)completionHandler{
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:loginName forKey:@"loginName"];
//    [paramDic setObject:[CNEncrypt encryptString:newPassword] forKey:@"newPassword"];
    [paramDic setObject:newPassword forKey:@"newPassword"];
    [paramDic setObject:smsCode forKey:@"smsCode"];
    [paramDic setObject:@"2" forKey:@"type"];
    [paramDic setObject:@"2" forKey:@"use"];
    [paramDic setObject:validateId forKey:@"validateId"];
    [paramDic setObject:messageId forKey:@"messageId"];
    
    [self POST:kGatewayPath(config_modifyPwdBySmsCode) parameters:paramDic completionHandler:completionHandler];
}


+ (void)requestPhoneBind:(NSString*)smsCode
               messageId:(NSString *)messageId
       completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"messageId"] = messageId;
    paras[@"smsCode"] = smsCode;
    
    [self POST:kGatewayPath(config_bindMobileNoV2) parameters:paras completionHandler:completionHandler];
}

+ (void)requestRebindPhone:(NSString *)smsCode
                 messageId:(NSString *)messageId
         completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:messageId forKey:@"messageId"];
    [paramDic setObject:smsCode forKey:@"smsCode"];
    [paramDic setObject:@"2" forKey:@"bindType"];
    [paramDic setObject:@"0" forKey:@"use"];
    
    [self POST:kGatewayPath(config_reBindMobileNoV2) parameters:paramDic completionHandler:completionHandler];
}

+ (void)getUserInfoByTokenCompletionHandler:(nullable HandlerBlock)completionHandler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"inclMobileNo"] = @(1);
    paramDic[@"inclMobileNoBind"] = @(1);
    paramDic[@"inclRealName"] = @(1);
    paramDic[@"inclVerifyCode"] = @(1);
    paramDic[@"inclBankAccount"] = @(1);
    paramDic[@"inclOnlineMessenger2"] = @(1);
    paramDic[@"inclEmail"] = @(1);
    paramDic[@"inclPromoAmountByMonth"] = @(1); // 本月优惠
    paramDic[@"inclRebatedAmountByMonth"] = @(1); // 本月洗码

    
    [self POST:kGatewayPath(config_getByLoginName) parameters:paramDic completionHandler:^(id responseObj, NSString *errorMsg) {
        [[CNUserManager shareManager] saveUserDetail:responseObj];
        if (completionHandler) {
            completionHandler(responseObj, errorMsg);
        }
    }];
}

+ (void)logoutHandler:(HandlerBlock)completionHandler{
    [self POST:kGatewayPath(config_logout) parameters:[kNetworkMgr baseParam] completionHandler:^(id responseObj, NSString *errorMsg) {
        [[CNUserManager shareManager] cleanUserInfo];
        if (completionHandler) {
            completionHandler(responseObj, errorMsg);
        }
    }];
}

+ (void)checkTopDomainSuccessHandler:(nullable HandlerBlock)completionHandler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"appGroup"] = @"GROUP_A03_H5_REAL_NEW";
    param[@"topDomain"] = [CNUserManager shareManager].printedloginName;

    [self POST:kGatewayExtraPath(config_getTopDomain) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            if ([CNUserManager shareManager].userInfo.starLevel >= 3) {
                [CNUserManager shareManager].userInfo.isWhiteListUser = YES;
                [[CNUserManager shareManager] saveUerInfoToSandBox];
            }
        }
        !completionHandler?:completionHandler(responseObj, errorMsg);
    }];
}

+ (void)switchAccountSuccessHandler:(HandlerBlock)completionHandler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    //1 主账户 2 USDT 在这里usdtmodeon已经打开了
    [param setObject:[CNUserManager shareManager].isUsdtMode?@1:@2 forKey:@"accountType"];
    
    [self POST:kGatewayPath(config_switchAccount) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            if (responseObj[@"loginName"]) {
                [CNUserManager shareManager].userInfo.currency = @"CNY";
                [CNUserManager shareManager].userInfo.loginName = responseObj[@"loginName"];
                [[CNUserManager shareManager] saveUerInfoToSandBox];
                [IVHttpManager shareManager].loginName = responseObj[@"loginName"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:HYSwitchAcoutSuccNotification object:nil];
                !completionHandler?:completionHandler(responseObj, errorMsg);
            }
            if ([CNUserManager shareManager].isUsdtMode) {
                [CNHUB showSuccess:@"切换到了USDT模式"];
            } else {
                [CNHUB showSuccess:@"切换到了CNY模式"];
            }
        }
    }];
}

@end
