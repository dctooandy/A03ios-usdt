//
//  RedPacketsRequest.m
//  HYNewNest
//
//  Created by RM03 on 2022/1/18.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "RedPacketsRequest.h"

@implementation RedPacketsRequest
+ (void)getRainInfoTask:(HandlerBlock)handler
{
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [self POST:kGatewayExtraPath(A03RainInfo) parameters:params completionHandler:handler];
}
+ (void)getRainIdentifyTask:(HandlerBlock)handler
{
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [self POST:kGatewayExtraPath(A03RainCreate) parameters:params completionHandler:handler];
}
+ (void)getRainOpenTask:(HandlerBlock)handler
{
    NSString *identifyString = [[[NSUserDefaults standardUserDefaults] objectForKey:RedPacketIdentify] stringValue];
    NSString *numString = [[[NSUserDefaults standardUserDefaults] objectForKey:RedPacketNum] stringValue];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"identify"] = identifyString;
    params[@"times"] = numString;
    [self POST:kGatewayExtraPath(A03RainOpen) parameters:params completionHandler:handler];
}
+ (void)getRainQueryTask:(HandlerBlock)handler
{
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [self POST:kGatewayExtraPath(A03RainQuery) parameters:params completionHandler:handler];
}
+ (void)getRainInKindPrizeTask:(HandlerBlock)handler
{
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [self POST:kGatewayExtraPath(A03RainInKindPrize) parameters:params completionHandler:handler];
}
+ (void)getRainGroupTask:(HandlerBlock)handler
{
    NSMutableDictionary *params = @{}.mutableCopy;
    
    [self POST:kGatewayExtraPath(A03RainGroup) parameters:params completionHandler:handler];
}
@end
