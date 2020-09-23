//
//  CNXiMaRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNXiMaRequest.h"

@implementation CNXiMaRequest

+ (void)xmCheckAvaliableHandler:(HandlerBlock)handler {
    [self POST:kGatewayExtraPath(config_xmCheckIsCanXm) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}

+ (void)xmQueryXmpPlatformHandler:(HandlerBlock)handler {
    [self POST:kGatewayPath(config_xmQueryXmpPlatform) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}

+ (void)xmCalcAmountV3WithXmTypes:(NSArray *)xmTypes
                          handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"xmTypes"] = xmTypes;
    [self POST:kGatewayPath(config_xmCalcAmountV3) parameters:param completionHandler:handler];
}

+ (void)xmCreateRequestXmBeginDate:(NSString *)xmBeginDate
                         xmEndDate:(NSString *)xmEndDate
                        xmRequests:(NSArray<XmTypesItem *> *)xmRequests
                           handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    NSMutableArray *xmList = @[].mutableCopy;
    for (XmTypesItem *item in xmRequests) {
        NSMutableDictionary *dict = [item yy_modelToJSONObject];
        dict[@"xmName"] = item.xmType;
        [dict removeObjectForKey:@"reduceBetAmount"];
        [xmList addObject:dict];
    }
    param[@"isXm"] = @"0";
    param[@"xmBeginDate"] = xmBeginDate;
    param[@"xmEndDate"] = xmEndDate;
    param[@"xmRequests"] = xmList;
    
    [self POST:kGatewayPath(config_xmcreateRequest) parameters:param completionHandler:handler];
}

@end
