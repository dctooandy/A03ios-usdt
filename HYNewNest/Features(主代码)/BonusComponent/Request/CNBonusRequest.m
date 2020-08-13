//
//  CNBonusRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBonusRequest.h"

@implementation CNBonusRequest

+ (void)getBonusListHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    if ([CNUserManager shareManager].isUsdtMode) {
        param[@"currency"] = @"USDT";
    } else {
        param[@"currency"] = @"CNY";
    }
    [self POST:kGatewayExtraPath(config_new_queryMyBonus) parameters:param completionHandler:handler];
}

@end
