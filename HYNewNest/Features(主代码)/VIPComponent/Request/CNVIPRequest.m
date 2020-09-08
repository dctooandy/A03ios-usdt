//
//  CNVIPRequest.m
//  HYNewNest
//
//  Created by zaky on 8/29/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNVIPRequest.h"

@implementation CNVIPRequest

+ (void)vipsxhGuideHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"bizCode"] = @"VIPSXH_GUIDE";
    param[@"conditions"] = @[@{@"name":@"currency",@"value":[CNUserManager shareManager].userInfo.currency?:@"USDT"}];
    
    [self POST:kGatewayPath(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            handler(responseObj[@"data"], errorMsg);
        }
    }];
    
}

+ (void)vipsxhMonthReportHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = [CNUserManager shareManager].userInfo.currency?:@"USDT";
    
    [self POST:kGatewayExtraPath(activity_vipSxhReport) parameters:param completionHandler:handler];
}

+ (void)requestRewardBroadcastHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"bizCode"] = @"ZZDZP_DATA";
    
    [self POST:kGatewayPath(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            handler(responseObj[@"data"], errorMsg);
        }
    }];
}

//+ (void)requestVIPPromotionHandler:(HandlerBlock)handler {
//    
//    NSMutableDictionary *param = [kNetworkMgr baseParam];
//    [param setObject:@"VIPPRIVILEGE_ACTIVITY_ID" forKey:@"activityKey"];
//    [param setObject:@"VIPPRIVILEGE" forKey:@"promoCode"];
//    
//    [self POST:kGatewayExtraPath(config_VIPPromotion) parameters:param completionHandler:handler];
//    
//}

@end
