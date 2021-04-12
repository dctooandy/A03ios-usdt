//
//  CNTaskRequest.m
//  HYNewNest
//
//  Created by zaky on 4/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNTaskRequest.h"

@implementation CNTaskRequest

+ (void)getNewUsrTask:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"action"] = @"myTask";
    
    [self POST:kGatewayExtraPath(config_newapiTask) parameters:param completionHandler:handler];
}

@end
