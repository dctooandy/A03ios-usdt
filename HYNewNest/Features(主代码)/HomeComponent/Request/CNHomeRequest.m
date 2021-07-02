//
//  CNHomeRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/21.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNHomeRequest.h"

@implementation CNHomeRequest

//+ (void)test{
//    
//    [self POST:kGatewayExtraPath(@"test") parameters:@{} completionHandler:^(id responseObj, NSString *errorMsg) {
//        
//    }];
//}

+ (void)queryMessageBoxHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"bizCode"] = @"MESSAGE_BOX";
    
    [self POST:(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            handler(responseObj[@"data"], errorMsg);
        }
    }];
}

+ (void)requestBannerWhere:(BannerWhere)where Handler:(HandlerBlock)handler{
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    if (where == BannerWhereHome) {
        paramDic[@"imageGroups"] = @"TOP_BANNER";
    } else if (where == BannerWhereGame) {
        paramDic[@"imageGroups"] = @"ZR_APP_SLOT_BANNER";
    } else {
        paramDic[@"imageGroups"] = @"SHARING_SET";
        paramDic[@"flag"] = @1;
    }
    [self POST:kGatewayExtraPath(config_new_queryImageList) parameters:paramDic completionHandler:handler];
}

+ (void)requestGetAnnouncesHandler:(HandlerBlock)handler {
    [self POST:(config_queryAnnoumces) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}


#pragma mark - 游戏

+ (void)requestInGameUrlGameType:(NSString *)gameType
                          gameId:(NSString *)gameId
                        gameCode:(NSString *)gameCode
                platformCurrency:(nullable NSString *)platformCurrency
                         handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"gameCode"] = gameCode;
    param[@"gameType"] = gameType;
    param[@"gameId"] = gameId.length > 0 ? gameId : @"";
    param[@"platformCurrency"] = platformCurrency;
    
    [self POST:(config_inGame) parameters:param completionHandler:handler];
}

+ (void)requestBACInGameUrlTableCode:(NSString *)tableCode handler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"gameCode"] = @"003";
    param[@"gameType"] = @"BAC";
    param[@"gameId"] = @"";
    param[@"additionalParams"] = [NSString stringWithFormat:@"videoID=%@",tableCode];//additionalParams: "videoID=D051"
    
    [self POST:(config_inGame) parameters:param completionHandler:handler];
}

+ (void)queryGamesHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = [CNUserManager shareManager].userInfo.currency;
    
    [self POST:(config_queryGames) parameters:param completionHandler:handler];
}


#pragma mark - 电游

+ (void)queryElecGamePlayLogHandler:(HandlerBlock)handler {
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:@"1" forKey:@"type"];
    
    [self POST:kGatewayExtraPath(config_queryPlayLog) parameters:paramDic completionHandler:handler];
}

+ (void)queryFavoriteElecHandler:(HandlerBlock)handler {
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:@"1" forKey:@"flag"];
    
    [self POST:(config_queryFavoriteGame) parameters:paramDic completionHandler:handler];
}

+ (void)updateFavoriteElecGameId:(NSString *)gameId
                    platformCode:(NSString *)platformCode
                            flag:(ElecGameFavoriteFlag)flag
                         handler:(HandlerBlock)handler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"gameId"] = gameId;
    paramDic[@"platformCode"] = platformCode;
    paramDic[@"flag"] = @(flag);
    
    [self POST:(config_updateFavorite) parameters:paramDic completionHandler:handler];
}

+ (void)queryElecGamesOneOfThreeType:(ElecGame3Type)type
                             handler:(HandlerBlock)handler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:@"1" forKey:@"pageNo"];
    [paramDic setObject:@"10" forKey:@"pageSize"];
    paramDic[@"currency"] = [CNUserManager shareManager].userInfo.currency;
    switch (type) {
        case ElecGame3TypePayout:{
            [paramDic setObject:@"1" forKey:@"payoutFlag"];
            [paramDic setObject:@"0" forKey:@"poolFlag"];
            [paramDic setObject:@"0" forKey:@"highFlag"];
            break;
        }
        case ElecGame3TypeHigh: {
            [paramDic setObject:@"0" forKey:@"payoutFlag"];
            [paramDic setObject:@"0" forKey:@"poolFlag"];
            [paramDic setObject:@"1" forKey:@"highFlag"];
            break;
        }
        case ElecGame3TypePool: {
            [paramDic setObject:@"0" forKey:@"payoutFlag"];
            [paramDic setObject:@"1" forKey:@"poolFlag"];
            [paramDic setObject:@"0" forKey:@"highFlag"];
            break;
        }
        default:
            break;
    }
    [self POST:(config_queryElecGame) parameters:paramDic completionHandler:handler];
}

+ (void)searchElecGameName:(NSString *)gameName
                    pageNo:(NSInteger)pageNo
                   handler:(HandlerBlock)handler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"currency"] = [CNUserManager shareManager].userInfo.currency;
    paramDic[@"pageNo"] = @(pageNo);
    paramDic[@"pageSize"] = @(100);
    paramDic[@"gameName"] = [gameName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self POST:(config_queryElecGame) parameters:paramDic completionHandler:handler];
}

/**{
    "pageNo": "1",
    "pageSize": "20",
    "loginName": "fzoe88usdt",
    "productId": "A03",
    "platformNames": ["AG", "PNG", "PP", "TTG"],
    "payLines": [{
        "low": "1",
        "high": "4"
    }, {
        "low": "5",
        "high": "9"
    }],
    "gameType": "1,2,6"
}*/
+ (void)queryElecGamesWithPageNo:(NSInteger)pageNo
                        gemeType:(NSString *)gameType
                   platformNames:(NSArray<NSString *> *)platformNames
                        payLines:(NSArray<NSDictionary *> *)payLines
                         handler:(HandlerBlock)handler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"pageSize"] = @(20);
    paramDic[@"pageNo"] = @(pageNo);
    if (gameType.length > 0) {
        paramDic[@"gameTypes"] = gameType;//游戏类型
    }
    if (platformNames.count > 0) {
        paramDic[@"platformNames"] = platformNames;//平台名
    }
    if (payLines.count > 0) {
        paramDic[@"payLines"] = payLines;//赔付线
    }
    
    [self POST:(config_queryElecGame) parameters:paramDic completionHandler:handler];
}


@end
