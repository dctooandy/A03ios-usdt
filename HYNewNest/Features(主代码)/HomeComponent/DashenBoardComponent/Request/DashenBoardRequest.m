//
//  DashenBoardRequest.m
//  HYNewNest
//
//  Created by zaky on 12/8/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DashenBoardRequest.h"

@implementation DashenBoardRequest

+ (void)requestDashenBoredType:(DashenBoredType)type
                       handler:(HandlerBlock)handler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"pageNo"] = @1;
    paramDic[@"pageSize"] = @10;
    paramDic[@"beginDate"] = [[[NSDate date] jk_startOfMonth] jk_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    paramDic[@"endDate"] = [[[NSDate date] jk_endOfMonth] jk_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    switch (type) {
        case DashenBoredTypeRecharge:
            paramDic[@"action"] = @"recharge";
            break;
        case DashenBoredTypeWithdraw:
            paramDic[@"action"] = @"withdraw";
            break;
        case DashenBoredTypeTotalWeek:
            paramDic[@"action"] = @"totalWeek";
            paramDic[@"pageNo"] = @1;
            paramDic[@"pageSize"] = @6;
            paramDic[@"beginDate"] = [[[NSDate date] jk_startOfWeek] jk_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            paramDic[@"endDate"] = [[[NSDate date] jk_endOfWeek] jk_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        case DashenBoredTypeTotalMonth:
            paramDic[@"action"] = @"totalMonth";
            paramDic[@"pageNo"] = @1;
            paramDic[@"pageSize"] = @6;
            break;
        default: break;
    }
    
    [self POST:kGatewayExtraPath(config_queryDSBRank) parameters:paramDic completionHandler:handler];
}

+ (void)requestProfitPageNo:(NSInteger)pageNo beginDate:(NSString *)beginDate endDate:(NSString *)endDate handler:(HandlerBlock)handler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"pageNo"] = @(pageNo);
    paramDic[@"pageSize"] = @10;
    paramDic[@"beginDate"] = beginDate;
    paramDic[@"endDate"] = endDate;
    paramDic[@"action"] = @"profit";
    [self POST:kGatewayExtraPath(config_queryDSBRank) parameters:paramDic completionHandler:handler];
}

@end
