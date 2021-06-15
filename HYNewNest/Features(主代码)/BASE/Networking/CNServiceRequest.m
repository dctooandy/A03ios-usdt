//
//  CNServiceRequest.m
//  HYNewNest
//
//  Created by zaky on 6/15/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNServiceRequest.h"

@implementation CNServiceRequest

+ (void)queryIsOpenWMQHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"bizCode"] = @"VIP_IM";
    
    [self POST:(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            handler(responseObj[@"data"], errorMsg);
        }
    }];
}

+ (void)requestDynamicLive800AddressCompletionHandler:(HandlerBlock)handler{
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"bizCode"] = @"800_DEPLOY";
    
    [CNBaseNetworking POST:(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            handler(responseObj[@"data"], errorMsg);
        }
    }];
}

+ (void)callCenterCallBackMessageId:(nullable NSString *)messageId
                            smsCode:(nullable NSString *)smsCode
                           mobileNo:(nullable NSString *)mobileNo
                            handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"type"] = mobileNo ? @(0) : @(1);// 是否用户绑定手机，0：否
    param[@"messageId"] = messageId;
    param[@"mobileNo"] = mobileNo;
    param[@"smsCode"] = smsCode;
  
    [self POST:(config_callBackPhone) parameters:param completionHandler:handler];
}

+ (void)call400 {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4001200938"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
        [CNTOPHUB showSuccess:@"正在为您拨通.."];
    }];
}

@end
