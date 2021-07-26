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
#import "CNPushRequest.h"

@implementation CNLoginRequest

+ (void)getImageCodeWithType:(CNImageCodeType)type
           completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @(type);
    
    [self POST:(config_generateCaptcha) parameters:paras completionHandler:completionHandler];
}

+ (void)getHanImageCodeHandler:(HandlerBlock)completionHandler {
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    [self POST:(config_generateHanCaptcha) parameters:paras completionHandler:completionHandler];
}

+ (void)verifyHanImageCodeCaptcha:(NSString *)captcha
                        captchaId:(NSString *)captchaId
                          handler:(HandlerBlock)completionHandler{
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"captcha"] = captcha;
    paras[@"captchaId"] = captchaId;
    [self POST:(config_validateHanCaptcha) parameters:paras completionHandler:completionHandler];
}

+ (void)getSMSCodeWithType:(CNSMSCodeType)type
                     phone:(NSString *)phone
         completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @(type);
    paras[@"mobileNo"] = [CNEncrypt encryptString:phone];
    
    [self POST:(config_SendCodePhone) parameters:paras completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [kKeywindow jk_makeToast:[NSString stringWithFormat:@"向手机%@\n发送了一条验证码", phone] duration:2 position:JKToastPositionCenter];
        }
        completionHandler(responseObj, errorMsg);
    }];
}

+ (void)getSMSCodeWithType:(CNSMSCodeType)type
                     phone:(NSString *)phone
                validateId:(NSString *)vId
         completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @(type);
    paras[@"mobileNo"] = [CNEncrypt encryptString:phone];
    paras[@"validateId"] = vId;
    
    [self POST:(config_SendCodePhone) parameters:paras completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [kKeywindow jk_makeToast:[NSString stringWithFormat:@"向手机%@\n发送了一条验证码", phone] duration:2 position:JKToastPositionCenter];
        }
        completionHandler(responseObj, errorMsg);
    }];
}

+ (void)getSMSCodeByLoginNameType:(CNSMSCodeType)type   completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @(type);
    
    [self POST:config_sendCodeByLoginName parameters:paras completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [kKeywindow jk_makeToast:[NSString stringWithFormat:@"向手机%@\n发送了一条验证码", [CNUserManager shareManager].userDetail.mobileNo] duration:2.5 position:JKToastPositionCenter];
        }
        completionHandler(responseObj, errorMsg);
    }];
}

+ (void)verifySMSCodeWithType:(CNSMSCodeType)type
                      smsCode:(NSString *)smsCode
                    smsCodeId:(NSString *)smsCodeId
            completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @(type);
    paras[@"smsCode"] = smsCode;
    paras[@"messageId"] = smsCodeId;
    
    [self POST:(config_verifySmsCode) parameters:paras completionHandler:completionHandler];
}

+ (void)accountPreLoginCompletionHandler:(HandlerBlock)completionHandler {

    [self POST:(config_preLogin) parameters:[kNetworkMgr baseParam] completionHandler:completionHandler];
}

+ (void)accountLogin:(NSString *)account
            password:(NSString *)password
           messageId:(NSString *)messageId
           imageCode:(NSString *)imageCode
         imageCodeId:(NSString *)imageCodeId
   completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"messageId"] = messageId;
    paras[@"loginName"] = [CNEncrypt encryptString:account];
    paras[@"verifyStr"] = [CNEncrypt encryptString:password];

    if (!KIsEmptyString(imageCode)) {
        paras[@"captcha"] = imageCode;
        paras[@"captchaId"] = imageCodeId;
    }

    [self POST:(config_LoginEx) parameters:paras completionHandler:^(NSDictionary *responseObj, NSString *errorMsg) {
        if ([responseObj isKindOfClass:[NSDictionary class]] && [responseObj.allKeys containsObject:@"samePhoneLoginNames"]) {
            completionHandler(responseObj, errorMsg);
        } else {
            if (!errorMsg) {
                [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
                [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 请求详细信息
//                [self checkTopDomainSuccessHandler:nil]; //查询是否白名单用户
                // 推送相关    (登录后才能获取到udid)
                [CNPushRequest GetUDIDHandler:^(id responseObj, NSString *errorMsg) {
                    [CNPushRequest GTInterfaceHandler:nil];
                }];
                
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
    param[@"loginName"] = loginName;
    param[@"messageId"] = messageId;
    param[@"validateId"] = validateId;
    
    [self POST:(config_loginMessageIdAndLoginName) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
            [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 请求详细信息
//            [self checkTopDomainSuccessHandler:nil]; //查询是否白名单用户
            // 推送相关    (登录后才能获取到udid)
            [CNPushRequest GetUDIDHandler:^(id responseObj, NSString *errorMsg) {
                [CNPushRequest GTInterfaceHandler:nil];
            }];
        }
        completionHandler(responseObj, errorMsg);
    }];
}

+ (void)getSMSCodeByLoginName:(NSString *)loginName     completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"use"] = @2;
    paras[@"loginName"] = loginName;
    
    [self POST:(config_sendCodeByLoginName) parameters:paras completionHandler:completionHandler];
}

+ (void)verifyLoginWith2FALoginName:(NSString *)loginName
                            smsCode:(NSString *)smsCode
                          messageId:(NSString *)messageId
                  completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"loginName"] = loginName;
    param[@"smsCode"] = smsCode;
    param[@"messageId"] = messageId;
    param[@"phase"] = @2; // 登录后追加双因子认证
    param[@"type"] = @1; //双因子登录类型：1.sms
    
    [self POST:(config_loginWith2FA) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
            [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 请求详细信息
            // 推送相关    (登录后才能获取到udid)
            [CNPushRequest GetUDIDHandler:^(id responseObj, NSString *errorMsg) {
                [CNPushRequest GTInterfaceHandler:nil];
            }];
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
//    [self POST:(config_createTryAccount) parameters:paras completionHandler:^(id responseObj, NSString *errorMsg) {
//        [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
//        [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 请求详细信息
//        completionHandler(responseObj, errorMsg);
//    }];
//}

+ (void)accountRegisterUserName:(NSString *)loginName
                       password:(NSString *)password
                        captcha:(NSString *)captcha
                      captchaId:(NSString *)captchaId
               completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"loginName"] = loginName;
    paras[@"password"] = [CNEncrypt encryptString:password];
    paras[@"captchaId"] = captchaId;
    paras[@"captcha"] = captcha;

    [self POST:(config_registUserName) parameters:paras completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [[CNUserManager shareManager] saveUserInfo:responseObj]; // 内部自动保存
            [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 请求详细信息
//            [self checkTopDomainSuccessHandler:nil]; //查询是否白名单用户
            // 推送相关    (登录后才能获取到udid)
            [CNPushRequest GetUDIDHandler:^(id responseObj, NSString *errorMsg) {
                [CNPushRequest GTInterfaceHandler:nil];
            }];
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
    paras[@"oldPassword"] = [CNEncrypt encryptString:oldPassword];
    paras[@"newPassword"] = [CNEncrypt encryptString:newPassword];
    paras[@"type"] = @"1";
    
    [self POST:(config_modifyPwd) parameters:paras completionHandler:completionHandler];
}

+ (void)modifyFundPwdSmsCode:(NSString *)smsCode
                   messageId:(NSString *)messageId
                 oldPassword:(NSString *)oldPassword
                 newPassword:(NSString *)newPassword
                        type:(NSNumber *)type
                     handler:(HandlerBlock)handler{
    
    NSMutableDictionary *paras = @{}.mutableCopy;
    paras[@"oldPassword"] = oldPassword?[CNEncrypt encryptString:oldPassword]:nil;
    paras[@"newPassword"] = [CNEncrypt encryptString:newPassword];
    paras[@"type"] = type;
    paras[@"use"] = @20;
    paras[@"smsCode"] = smsCode;
    paras[@"messageId"] = messageId;
    
    [self POST:config_modifyPwd parameters:paras completionHandler:handler];
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
    
    [self POST:(config_forgetPassword_validate) parameters:param completionHandler:completionHandler];
}

+ (void)modifyPasswordLoginName:(NSString *)loginName
                      smsCode:(NSString *)smsCode
                  newPassword:(NSString *)newPassword
                   validateId:(NSString *)validateId
                    messageId:(NSString *)messageId
            completionHandler:(HandlerBlock)completionHandler{
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"loginName"] = loginName;
    paramDic[@"type"] = @2;
    paramDic[@"use"] = @2;
    paramDic[@"newPassword"] = [CNEncrypt encryptString:newPassword];
    paramDic[@"smsCode"] = smsCode;
    paramDic[@"validateId"] = validateId;
    paramDic[@"messageId"] = messageId;
    
    [self POST:(config_modifyPwdBySmsCode) parameters:paramDic completionHandler:completionHandler];
}


+ (void)requestPhoneBind:(NSString*)smsCode
               messageId:(NSString *)messageId
       completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paras = [kNetworkMgr baseParam];
    paras[@"messageId"] = messageId;
    paras[@"smsCode"] = smsCode;
    
    [self POST:(config_bindMobileNoV2) parameters:paras completionHandler:completionHandler];
}

+ (void)requestRebindPhone:(NSString *)smsCode
                 messageId:(NSString *)messageId
         completionHandler:(HandlerBlock)completionHandler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:messageId forKey:@"messageId"];
    [paramDic setObject:smsCode forKey:@"smsCode"];
//    [paramDic setObject:@"2" forKey:@"bindType"];
//    [paramDic setObject:@"0" forKey:@"use"];
    
    [self POST:(config_reBindMobileNoV2) parameters:paramDic completionHandler:completionHandler];
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
    paramDic[@"inclExistsWithdralPwd"] = @1;       //是否设置了资金密码
//    paramDic[@"inclPromoAmountByMonth"] = @(1); // 本月优惠
//    paramDic[@"inclRebatedAmountByMonth"] = @(1); // 本月洗码

    [self POST:(config_getByLoginName) parameters:paramDic completionHandler:^(id responseObj, NSString *errorMsg) {
        [[CNUserManager shareManager] saveUserDetail:responseObj];
        if (completionHandler) {
            completionHandler(responseObj, errorMsg);
        }
    }];
}

+ (void)logoutHandler:(HandlerBlock)completionHandler{
    [self POST:(config_logout) parameters:[kNetworkMgr baseParam] completionHandler:^(id responseObj, NSString *errorMsg) {
        [[CNUserManager shareManager] cleanUserInfo];
        if (completionHandler) {
            completionHandler(responseObj, errorMsg);
        }
    }];
}

// 又特么不用top域名判断了
//+ (void)checkTopDomainSuccessHandler:(nullable HandlerBlock)completionHandler {
//    NSMutableDictionary *param = [kNetworkMgr baseParam];
//    param[@"appGroup"] = @"GROUP_A03_H5_REAL_NEW";
//    param[@"topDomain"] = [CNUserManager shareManager].printedloginName;
//
//    [self POST:kGatewayExtraPath(config_getTopDomain) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
//        if (KIsEmptyString(errorMsg)) {
//            CNUserModel *userInfo = [CNUserManager shareManager].userInfo;
//            userInfo.isWhiteListUser = YES;
//            [[CNUserManager shareManager] saveUserInfo:[userInfo yy_modelToJSONObject]];
//        }
//        !completionHandler?:completionHandler(responseObj, errorMsg);
//    }];
//}

+ (void)switchAccountSuccessHandler:(HandlerBlock)completionHandler{
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    //1 主账户 2 USDT 在这里usdtmodeon已经打开了
//    [param setObject:[CNUserManager shareManager].isUsdtMode?@1:@2 forKey:@"accountType"]; //废弃
    param[@"uiMode"] = [CNUserManager shareManager].isUsdtMode?@"CNY":@"USDT";
    
    [self POST:(config_switchAccount) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            if (responseObj[@"loginName"]) {
                CNUserModel *userInfo = [CNUserManager shareManager].userInfo;
                userInfo.loginName = responseObj[@"loginName"];
                userInfo.subAccountFlag = responseObj[@"subAccountFlag"];
                if (![userInfo.loginName hasSuffix:@"usdt"]) {
                    userInfo.currency = @"CNY";
                    userInfo.uiMode = @"CNY";
                } else {
                    userInfo.currency = @"USDT";
                    userInfo.uiMode = @"USDT";
                }
                NSDictionary *newUIF = [userInfo yy_modelToJSONObject];
                [[CNUserManager shareManager] saveUserInfo:newUIF];
                [[CNUserManager shareManager] deleteWebCache];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:HYSwitchAcoutSuccNotification object:nil];
                if ([CNUserManager shareManager].isUsdtMode) {
                    [CNTOPHUB showSuccess:@"切换到了USDT模式"];
                } else {
                    [CNTOPHUB showSuccess:@"切换到了CNY模式"];
                }
                !completionHandler?:completionHandler(responseObj, errorMsg);
            }
        }
        
    }];
}

+ (void)switchAccountSuccessHandler:(HandlerBlock)completionHandler faileHandler:(void (^ _Nullable)(void))faileHandloer{
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    //1 主账户 2 USDT 在这里usdtmodeon已经打开了
//    [param setObject:[CNUserManager shareManager].isUsdtMode?@1:@2 forKey:@"accountType"]; //废弃
    param[@"uiMode"] = [CNUserManager shareManager].isUsdtMode?@"CNY":@"USDT";
    
    [self POST:(config_switchAccount) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            if (responseObj[@"loginName"]) {
                CNUserModel *userInfo = [CNUserManager shareManager].userInfo;
                userInfo.loginName = responseObj[@"loginName"];
                userInfo.subAccountFlag = responseObj[@"subAccountFlag"];
                if (![userInfo.loginName hasSuffix:@"usdt"]) {
                    userInfo.currency = @"CNY";
                    userInfo.uiMode = @"CNY";
                } else {
                    userInfo.currency = @"USDT";
                    userInfo.uiMode = @"USDT";
                }
                NSDictionary *newUIF = [userInfo yy_modelToJSONObject];
                [[CNUserManager shareManager] saveUserInfo:newUIF];
                [[CNUserManager shareManager] deleteWebCache];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:HYSwitchAcoutSuccNotification object:nil];
                if ([CNUserManager shareManager].isUsdtMode) {
                    [CNTOPHUB showSuccess:@"切换到了USDT模式"];
                } else {
                    [CNTOPHUB showSuccess:@"切换到了CNY模式"];
                }
                !completionHandler?:completionHandler(responseObj, errorMsg);
            }
        }
        else {
            faileHandloer();
        }
        
    }];
}
@end
