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
@end
