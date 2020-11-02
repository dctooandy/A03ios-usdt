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
    param[@"currency"] = @"USDT";
    
    [self POST:kGatewayExtraPath(activity_vipSxhReport) parameters:param completionHandler:handler];
}

+ (void)vipsxhHomeHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = @"USDT";
    
    [self POST:kGatewayExtraPath(activity_vipSxhHome) parameters:param completionHandler:handler];
}

+ (void)vipsxhBigGodBoardHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = @"USDT";
    
    [self POST:kGatewayExtraPath(activity_vipSxhRank) parameters:param completionHandler:handler];
}

+ (void)vipsxhDrawGiftMoneyLevelStatus:(NSString *)levelStatus handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = @"USDT";
    param[@"promoCode"] = @"VIPSXH";
    param[@"levelStatus"] = levelStatus;
    
    [self POST:kGatewayExtraPath(activity_vipSxhDraw) parameters:param completionHandler:handler];
}


+ (void)vipsxhCumulateIdentityHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = @"USDT";
    
    [self POST:kGatewayExtraPath(activity_vipSxhIdentity) parameters:param completionHandler:handler];
}

+ (void)vipsxhApplyCumulateIdentityPrize:(NSString *)prizeids
                                 handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = @"USDT";
    param[@"prizeids"] = prizeids;
    param[@"defineFlag"] = @(4); // 至尊转盘3 累计身份4
    
    [self POST:kGatewayExtraPath(activity_vipSxhApply) parameters:param completionHandler:handler];
}

+ (void)vipsxhAwardDetailPrizeids:(NSString *)prizeids
                          handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:@"A03" forKey:@"productId"];
    param[@"defineFlag"] = @2; // 至尊转盘1 累计身份2
    param[@"prizeids"] = prizeids;
    param[@"currency"] = @"USDT";
    
    [self POST:kGatewayExtraPath(activity_vipSxhAwardDetail) parameters:param completionHandler:handler];
}

+ (void)vipsxhReceiveAwardRecordType:(VIPSxhAwardType)type
                                 day:(NSInteger)days
                             handler:(HandlerBlock)handler{
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"promoCode"] = @"VIPPRIVILEGE";
    param[@"activityKey"] = [CNUserManager shareManager].isUsdtMode?@"VIPPRIVILEGE_ACTIVITY_ID_USDT":@"VIPPRIVILEGE_ACTIVITY_ID_CNY";
    param[@"currency"] = @"USDT";
    param[@"flags"] = @1;
    param[@"defineFlag"] = @(type); // 至尊转盘3 累计身份4
    param[@"pageSize"] = @(200);
    param[@"endDate"] = [self jk_formatYMD:[NSDate date]];
    param[@"beginDate"] = [self jk_formatYMD:[NSDate jk_dateWithDaysBeforeNow:days]];
    
    [self POST:kGatewayExtraPath(activity_vipSxhReceiveAward) parameters:param completionHandler:handler];
}

+ (NSString *)jk_formatYMD:(NSDate *)date {
    return [NSString stringWithFormat:@"%02zd-%02zd-%02zd",[date jk_year],[date jk_month], [date jk_day]];
}


@end
