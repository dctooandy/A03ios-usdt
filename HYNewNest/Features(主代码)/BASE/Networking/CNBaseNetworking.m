//
//  CNBaseNetworking.m
//  LCNewApp
//
//  Created by cean.q on 2019/11/19.
//  Copyright © 2019 B01. All rights reserved.
//

#import "CNBaseNetworking.h"
#import <IVHttpManager.h>
#import "ApiErrorCodeConst.h"
#import "LoadingView.h"

@implementation CNBaseNetworking

+ (NSArray *)errorCodeOfTokenException {
    return @[TokenFailure_ErrorCode,
             TokenExpired_ErrorCode,
             TokenInvalid_ErrorCode,
             TokenNotMatch_ErrorCode,
             SingleDeviceLogin_ErrorCode,
             TokenEmpty_ErrorCode,
             Network_LoginName_ErroCode];
}

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HandlerBlock)completionHandler {
    
    [LoadingView show];
    
    return [[IVHttpManager shareManager] sendRequestWithUrl:path parameters:parameters callBack:^(IVJResponseObject * _Nullable response, NSError * _Nullable error) {
        
        if ([response.head.errCode isEqualToString:@"0000"]) {
            [LoadingView showSuccess];
            !completionHandler ?: completionHandler(response.body, nil);
            
        } else if ([[self errorCodeOfTokenException] containsObject:response.head.errCode]) {
            [LoadingView hide];
            // token过期
            [CNTOPHUB showError:@"登录失效，请重新登录"];
            !completionHandler ?: completionHandler(response.head.errCode, @"登录失效，请重新登录");
            [[CNUserManager shareManager] cleanUserInfo];
            
        } else {
            [LoadingView hide];
            if (error) {
                [CNTOPHUB showError:error.localizedDescription];
                !completionHandler ?: completionHandler(nil, error.localizedDescription);
            } else {
                [CNTOPHUB showError:response.head.errMsg];
                !completionHandler ?: completionHandler(response.head.errCode, response.head.errMsg);
            }
        }
    }];
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HandlerBlock)completionHandler {
    if (!([path containsString:config_betAmountLevel] || [path containsString:config_getBalanceInfo] || [path containsString:config_getByLoginNameEx] || [path containsString:config_getByLoginName] || [path containsString:config_getByCardBin] || [path containsString:config_createUdid] || [path containsString:config_superSignSend] || [path containsString:config_upgradeApp] || [path containsString:config_queryDSBRank] || [path containsString:config_dynamicQuery])) { //加载一些信息不要loading
        [LoadingView show];
    }
    
    return [[IVHttpManager shareManager] sendRequestWithMethod:KYHTTPMethodPOST url:path parameters:parameters callBack:^(IVJResponseObject * _Nullable response, NSError * _Nullable error) {
        
        if ([response.head.errCode isEqualToString:@"0000"]) { // 正常返回
            [LoadingView showSuccess];
            !completionHandler ?: completionHandler(response.body, nil);
            
        } else if ([[self errorCodeOfTokenException] containsObject:response.head.errCode]) { // token过期
            [LoadingView hide];
            [CNTOPHUB showError:@"登录失效，请重新登录"];
            !completionHandler ?: completionHandler(response.head.errCode, @"登录失效，请重新登录");
            [[CNUserManager shareManager] cleanUserInfo];
            [[NNControllerHelper currentTabBarController] setSelectedIndex:0];
            
        } else if ([response.head.errCode isEqualToString:LoginRegionRisk_ErroCode]) { //异地登录
            [LoadingView hide];
            [CNTOPHUB showAlert:response.head.errMsg];
            !completionHandler ?: completionHandler(response.body, response.head.errCode);
            
        } else {
            [LoadingView hide];
            // 有错误信息的错误
            if (error) {
                // 错误信息处理
                if ([response.head.errCode isEqualToString:Network_TimeOut_ErroCode]) {
                    [CNTOPHUB showError: @"请求超时 请重试"];
                } else {
                    [CNTOPHUB showError:error.localizedDescription];
                }
                !completionHandler ?: completionHandler(nil, error.localizedDescription);
                
            // 无错误信息的错误
            } else {
                //一些错误信息不要提示
                if ([response.head.errCode isEqualToString:Network_TopDomainEmpty_ErroCode]) {
                    //非白名单用户错误 不提示
                }
                else if (![path containsString:config_getByCardBin]) { //非银行卡错误 才提示
                    [CNTOPHUB showError:response.head.errMsg];
                    
                }
                !completionHandler ?: completionHandler(response.head.errCode, response.head.errMsg);
            }
        }
    }];
}
@end
 
