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
             TokenEmpty_ErrorCode];
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
            [CNHUB showError:@"登录失效，请重新登录"];
            !completionHandler ?: completionHandler(response.head.errCode, @"登录失效，请重新登录");
            [[CNUserManager shareManager] cleanUserInfo];
            
        } else {
            [LoadingView hide];
            if (error) {
                [CNHUB showError:error.localizedDescription];
                !completionHandler ?: completionHandler(nil, error.localizedDescription);
            } else {
                [CNHUB showError:response.head.errMsg];
                !completionHandler ?: completionHandler(response.head.errCode, response.head.errMsg);
            }
        }
    }];
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HandlerBlock)completionHandler {
    if (!([path containsString:config_getByLoginName] || [path containsString:config_betAmountLevel] || [path containsString:config_getByLoginNameEx] || [path containsString:config_getBalanceInfo] || [path containsString:config_getByCardBin])) { //加载一些信息不要loading
        [LoadingView show];
    }
    
    return [[IVHttpManager shareManager] sendRequestWithMethod:KYHTTPMethodPOST url:path parameters:parameters callBack:^(IVJResponseObject * _Nullable response, NSError * _Nullable error) {
        
        if ([response.head.errCode isEqualToString:@"0000"]) {
            [LoadingView showSuccess];
            !completionHandler ?: completionHandler(response.body, nil);
            
        } else if ([[self errorCodeOfTokenException] containsObject:response.head.errCode]) {
            [LoadingView hide];
            // token过期
            [CNHUB showError:@"登录失效，请重新登录"];
            !completionHandler ?: completionHandler(response.head.errCode, @"登录失效，请重新登录");
            [[CNUserManager shareManager] cleanUserInfo];
            
        } else {
            [LoadingView hide];
            if (error) {
                [CNHUB showError:error.localizedDescription];
                !completionHandler ?: completionHandler(nil, error.localizedDescription);
            } else {
                //一些错误信息不要提示
                if (![path containsString:config_getByCardBin]) {
                    [CNHUB showError:response.head.errMsg];
                }
                !completionHandler ?: completionHandler(response.head.errCode, response.head.errMsg);
            }
        }
    }];
}
@end
 
