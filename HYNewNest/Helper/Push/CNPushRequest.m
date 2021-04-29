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
    __block NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:@"0" forKey:@"operationType"];
    NSString *udid = [KeyChain getKeychainIdentifierUUID];
    param[@"udid"] = udid;
    
    __weak typeof(self) weakSelf = self;
    [self POST:(config_createUdid) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            times = 0;
//#ifdef DEBUG
//        [kKeywindow jk_makeToast:[NSString stringWithFormat:@"UDID接口参数:%@\nresponseObject==%@\nerror==%@",param ,responseObj, errorMsg] duration:8 position:JKToastPositionTop];
//#endif
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
    __block NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"appId"] = [IVHttpManager shareManager].appId;//A03DS02
    param[@"bundleId"] = [[NSBundle mainBundle] bundleIdentifier];//传从签名后的
    param[@"customerId"] = [CNUserManager shareManager].userInfo.customerId;
    if ([kAppDelegate token].length > 0) {
        param[@"deviceToken"] = [kAppDelegate token];//deviceToken
    } else {
//#ifdef DEBUG
//        [kKeywindow jk_makeToast:[NSString stringWithFormat:@"【超签参数校验失败】缺少参数：“deviceToken”：%@",[kAppDelegate token]] duration:5 position:JKToastPositionCenter];
//#endif
        return;
    }
    
    IVOtherInfoModel *model = [[IVOtherInfoModel alloc]init];
    //[GTMBase64 encodeBase64String:@"ozog74@163.com"]
    if (model.developer.length > 0) {  // !!!:  otherInfo.json
       [param setObject:model.developer forKey:@"apnsAccount"];
    } else {
//#ifdef DEBUG
//        [kKeywindow jk_makeToast:@"【超签参数校验失败】缺少参数：“apnsAccount”, 检查超级签名流程是否正确 或者 “otherInfo.json”文件是否完整" duration:5 position:JKToastPositionCenter];
//        return;
//#endif
    }

    __weak typeof(self) weakSelf = self;
    [self POST:(config_superSignSend) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            times = 0;
//#ifdef DEBUG
//        [kKeywindow jk_makeToast:[NSString stringWithFormat:@"超签参数:%@\n超签responseObject==%@\n超签error==%@",param ,responseObj, errorMsg] duration:8 position:JKToastPositionCenter];
//#endif
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
