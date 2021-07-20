//
//  BYGloryRequest.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/20.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYGloryRequest.h"

@implementation BYGloryRequest
+ (void)getAgDynamic:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [self POST:kGatewayExtraPath(config_getAGDynamic(param[@"productId"])) parameters:param completionHandler:handler];
}

@end
