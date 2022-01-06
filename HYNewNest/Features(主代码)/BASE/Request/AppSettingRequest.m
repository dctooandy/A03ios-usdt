//
//  AppSettingRequest.m
//  HYNewNest
//
//  Created by RM03 on 2021/12/8.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "AppSettingRequest.h"
#import "AppdelegateManager.h"

@implementation AppSettingRequest
+ (void)getAppSettingTask:(HandlerBlock)handler
{
    NSMutableDictionary *params = @{}.mutableCopy;
    [IVHttpManager shareManager].appId = @"dzqAQAGPCjn1kUqzeiHsUTy57sFVTNQs";//A01NEWAPP02
    [IVHttpManager shareManager].productId = @"1682d3a2ee0c4ee8acbe58a5c39bb888";//A01
    [IVHttpManager shareManager].isSensitive = YES;
    [IVHttpManager shareManager].gateways = [[AppdelegateManager shareManager] gateways];  // 网关列表
    params[@"productId"] = [IVHttpManager shareManager].productId;
    params[@"productCodeExt"] = @"FM";
    params[@"productCode"] = @"";
    [self POST:kGatewayExtraPath(A03AppSetting) parameters:params completionHandler:handler];
}
@end
