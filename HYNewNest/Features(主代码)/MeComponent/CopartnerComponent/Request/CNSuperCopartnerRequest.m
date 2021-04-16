//
//  CNSuperCopartnerRequest.m
//  HYNewNest
//
//  Created by zaky on 12/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNSuperCopartnerRequest.h"

static NSString *SupCopRequestActionStr[] = {
//    [SuperCopartnerTypeMyBonus] = @"myBonus",
    [SuperCopartnerTypeMyRecommen] = @"myDownline",
//    [SuperCopartnerTypeSXHBonus] = @"赌王",
//    [SuperCopartnerTypeStarGifts] = @"赌圣",
    [SuperCopartnerTypeCumuBetRank] = @"betRank",
//    [SuperCopartnerTypeMyGifts] = @"myPrize",
    [SuperCopartnerTypeMyXimaRebate] = @"???",
};

@implementation CNSuperCopartnerRequest

+ (void)requestSuperCopartnerListType:(SuperCopartnerType)type
                               pageNo:(NSInteger)pageNo
                              handler:(HandlerBlock)handler {
    NSMutableDictionary *parm = [kNetworkMgr baseParam];
    parm[@"pageSize"] = @10;
    parm[@"pageNo"] = @(pageNo);
    parm[@"action"] = SupCopRequestActionStr[type];
    [self POST:kGatewayExtraPath(config_superCopartnerActy) parameters:parm completionHandler:handler];
}

+ (void)requestSuperCopartnerListBetRankHandler:(HandlerBlock)handler {
    NSMutableDictionary *parm = [kNetworkMgr baseParam];
    parm[@"pageSize"] = @10;
    parm[@"pageNo"] = @1;
    parm[@"action"] = SupCopRequestActionStr[SuperCopartnerTypeCumuBetRank];
    [self POST:kGatewayExtraPath(config_superCopartnerActy) parameters:parm completionHandler:handler];
}


+ (void)applyMyGiftBonusHandler:(HandlerBlock)handler {
    NSMutableDictionary *parm = [kNetworkMgr baseParam];
    parm[@"action"] = @"apply";
    [self POST:kGatewayExtraPath(config_superCopartnerActy) parameters:parm completionHandler:handler];
}

@end
