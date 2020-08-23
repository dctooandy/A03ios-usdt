//
//  CNPushRequest.m
//  HYNewNest
//
//  Created by zaky on 8/23/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNPushRequest.h"
#import "KeyChain.h"
#import "AppDelegate.h"

@implementation CNPushRequest

+ (void)GetUDIDHandler:(nullable HandlerBlock)completionHandler {
    
    static int times = 0;
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:@"0" forKey:@"operationType"];
    NSString *udid = [KeyChain getKeychainIdentifierUUID];
    param[@"udid"] = udid;
    
    __weak typeof(self) weakSelf = self;
    [self POST:@"/customer/createCustomerUdid" parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            times = 0;
            if (completionHandler) {
                completionHandler(responseObj, errorMsg);
            }
        } else {
            times ++;
            if (times < 3) {
                [weakSelf GetUDIDHandler:completionHandler];
            }else{
                times = 0;
                if (completionHandler) {
                    completionHandler(responseObj, errorMsg);
                }
            }
        }
    }];
   
}

+ (void)GTInterfaceHandler:(nullable HandlerBlock)completionHandler {
    
    static int times = 0;
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"appId"] = [IVHttpManager shareManager].appId;
    param[@"bundleId"] = [[NSBundle mainBundle] bundleIdentifier];//???: 传旧的?
//    param[@"bundleId"] = @"com.zero.hy";
    param[@"deviceToken"] = [kAppDelegate token];
    param[@"customerId"] = [CNUserManager shareManager].userInfo.customerId;
    
    IVOtherInfoModel *model = [[IVOtherInfoModel alloc]init];
    //[GTMBase64 encodeBase64String:@"ozog74@163.com"]
    if (model.developer.length > 0) {  //???: otherInfo.json
       [param setObject:model.developer forKey:@"apnsAccount"];
    }

    // ips/ipsSuperSignSend
    __weak typeof(self) weakSelf = self;
    [self POST:@"/ips/ipsSuperSignSend" parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            times = 0;
            if (completionHandler) {
                completionHandler(responseObj, errorMsg);
            }
        } else {
            times ++;
            if (times < 3) {
                [weakSelf GTInterfaceHandler:completionHandler];
            }else{
                times = 0;
                if (completionHandler) {
                    completionHandler(responseObj, errorMsg);
                }
            }
        }
    }];
    
}

@end
