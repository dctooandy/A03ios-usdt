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

+ (void)vipsxhIsShowReportHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *parm = [kNetworkMgr baseParam];
    [self POST:kGatewayExtraPath(activity_vipSxhFrame) parameters:parm completionHandler:handler];
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

+ (void)vipsxhHomeHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = [CNUserManager shareManager].userInfo.currency?:@"USDT";
    
    [self POST:kGatewayExtraPath(activity_vipSxhHome) parameters:param completionHandler:handler];
}

+ (void)vipsxhBigGodBoardHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = [CNUserManager shareManager].userInfo.currency?:@"USDT";
    
    [self POST:kGatewayExtraPath(activity_vipSxhRank) parameters:param completionHandler:handler];
}

+ (void)vipsxhDrawGiftMoneyLevelStatus:(NSString *)levelStatus handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = [CNUserManager shareManager].userInfo.currency?:@"USDT";
    param[@"promoCode"] = @"VIPSXH";
    param[@"levelStatus"] = levelStatus;
    
    [self POST:kGatewayExtraPath(activity_vipSxhDraw) parameters:param completionHandler:handler];
}


+ (void)vipsxhCumulateIdentityHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = [CNUserManager shareManager].userInfo.currency?:@"USDT";
    
    [self POST:kGatewayExtraPath(activity_vipSxhIdentity) parameters:param completionHandler:handler];
}

+ (void)vipsxhApplyCumulateIdentityPrize:(NSNumber *)prizeids
                                 handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = [CNUserManager shareManager].userInfo.currency?:@"USDT";
    param[@"prizeids"] = prizeids;
    param[@"defineFlag"] = @(4); // 至尊转盘3 累计身份4
    
    [self POST:kGatewayExtraPath(activity_vipSxhApply) parameters:param completionHandler:handler];
}


@end
