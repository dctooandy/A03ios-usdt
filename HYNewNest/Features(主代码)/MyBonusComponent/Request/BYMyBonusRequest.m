//
//  BYMyBonusRequest.m
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "BYMyBonusRequest.h"

@implementation BYMyBonusRequest

+ (void)getMyBonusListHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    if ([CNUserManager shareManager].isUsdtMode) {
        param[@"currency"] = @"USDT";
    } else {
        param[@"currency"] = @"CNY";
    }
    [self POST:kGatewayExtraPath(A03MyBonus) parameters:param completionHandler:handler];
}
+ (void)fetchMyBonusWithRequestID:(NSString*)requestId Handler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"requestId"] = requestId;
    [self POST:kGatewayExtraPath(A03MyApplyBonus) parameters:param completionHandler:handler];
}
+ (void)fetchHasBonusHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [self POST:kGatewayExtraPath(A03HasBonus) parameters:param completionHandler:handler];
}
+ (void)fetchServerTimeHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [self POST:A03ServerTime  parameters:param completionHandler:handler];
}
@end
