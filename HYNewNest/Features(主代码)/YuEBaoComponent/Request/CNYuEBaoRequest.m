//
//  CNYuEBaoRequest.m
//  HYNewNest
//
//  Created by zaky on 5/14/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNYuEBaoRequest.h"

@implementation CNYuEBaoRequest

+ (void)checkYuEBaoInterestLogsSumHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"action"] = @"yebBalance";
    [self POST:kGatewayExtraPath(config_yebPromo) parameters:param completionHandler:handler];
}

+ (void)checkYuEBaoTicketsHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"action"] = @"yebView";
    [self POST:kGatewayExtraPath(config_yebPromo) parameters:param completionHandler:handler];
}

+ (void)transferInYuEBaoAmount:(NSNumber *)amount handler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"clientType"] = @4; //1=PC 2=H5 3=android 4=iOS
    param[@"remarks"] = @"iOS";
    param[@"amount"] = amount;
    [self POST:config_yebTransferIn parameters:param completionHandler:handler];
}

+ (void)transferOutYuEBaoAmount:(NSNumber *)amount handler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"clientType"] = @4; //1=PC 2=H5 3=android 4=iOS
    param[@"remarks"] = @"iOS";
    param[@"amount"] = amount;
    [self POST:config_yebTransferOut parameters:param completionHandler:handler];
}

+ (void)checkYuEBaoConfigHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"currency"] = [CNUserManager shareManager].isUsdtMode?@"USDT":@"CNY";
    [self POST:config_yebConfig parameters:param completionHandler:handler];
}

@end
