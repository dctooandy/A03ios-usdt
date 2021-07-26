//
//  BYTradeEntryRequest.m
//  HYNewNest
//
//  Created by RM04 on 2021/6/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYTradeEntryRequest.h"

@implementation BYTradeEntryRequest

+ (void)fetchTradeHandler:(HandlerBlock)handler {
    NSDictionary *param = @{@"bizCode" : @"ACCESSED_DATA"};
    [self POST:(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            handler(responseObj[@"data"], errorMsg);
        }
    }];

}

@end
