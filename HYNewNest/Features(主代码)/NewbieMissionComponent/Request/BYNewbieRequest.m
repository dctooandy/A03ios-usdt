//
//  BYNewbieRequest.m
//  HYNewNest
//
//  Created by RM04 on 2021/5/24.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYNewbieRequest.h"

@implementation BYNewbieRequest
+ (void)getNewUsrTask:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"action"] = @"myTask";
    
    [self POST:kGatewayExtraPath(config_newapiTask) parameters:param completionHandler:handler];
}

@end
