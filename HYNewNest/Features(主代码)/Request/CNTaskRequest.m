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
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"action"] = @"myTask";
    
    [self POST:kGatewayExtraPath(config_newapiTask) parameters:param completionHandler:handler];
}

+ (void)getNewUsrTaskDetail:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"action"] = @"myTaskDetail";
    
    [self POST:kGatewayExtraPath(config_newapiTask) parameters:param completionHandler:handler];
}

+ (void)applyTaskRewardIds:(NSString *)prizeIds code:(NSString *)prizeCode handler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"action"] = @"apply";
    param[@"prizeIds"] = prizeIds;
    param[@"prizeCode"] = prizeCode;
    
    [self POST:kGatewayExtraPath(config_newapiTask) parameters:param completionHandler:handler];
}

@end
