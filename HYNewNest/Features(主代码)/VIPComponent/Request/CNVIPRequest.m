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

+ (void)vipsxhReceiveAwardRecordPageNo:(NSInteger)pageNo
                              pageSize:(NSInteger)pageSize
                                  type:(VIPSxhAwardType)type
                                   day:(NSInteger)days
                               handler:(HandlerBlock)handler{
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"promoCode"] = @"VIPPRIVILEGE";
    param[@"activityKey"] = [CNUserManager shareManager].isUsdtMode?@"VIPPRIVILEGE_ACTIVITY_ID_USDT":@"VIPPRIVILEGE_ACTIVITY_ID_CNY";
    param[@"currency"] = [CNUserManager shareManager].userInfo.currency?:@"USDT";
    param[@"flags"] = @1;
    param[@"defineFlag"] = @(type); // 至尊转盘3 累计身份4
    param[@"pageNo"] = @(pageNo);
    param[@"pageSize"] = @(pageSize);
    param[@"endDate"] = [[NSDate date] jk_formatYMD];
    param[@"beginDate"] = [[NSDate jk_dateWithDaysBeforeNow:days] jk_formatYMD];
    
    [self POST:kGatewayExtraPath(activity_vipSxhReceiveAward) parameters:param completionHandler:handler];
}


@end
