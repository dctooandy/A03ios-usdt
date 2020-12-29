//
//  HYInGameHelper.m
//  HYNewNest
//
//  Created by zaky on 8/24/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYInGameHelper.h"
#import "CNGameLineView.h"
#import "GameLineModel.h"
#import "CNHomeRequest.h"
#import "GameStartPlayViewController.h"

/// gameCode对应表
NSString *const InGameTypeString[] = {
    [InGameTypeAGQJ]    = @"003",
    [InGameTypeAGIN]    = @"026",
    [InGameTypeAGBY]    = @"026",
    [InGameTypeSHABA]   = @"031",
    [InGameTypeYSB]     = @"068",
    [InGameTypeHYTY]    = @"062",
    [InGameTypeKENO]    = @"004",
    [InGameTypeQG]      = @"080",
    [InGameTypeAGSTAR]  = @"064"
};

@interface HYInGameHelper ()
@property(nonatomic, strong) NSDictionary *inGameDict;
@end

@implementation HYInGameHelper


+ (instancetype)sharedInstance {
    static HYInGameHelper *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HYInGameHelper alloc] init];
    });
    return manager;
}

#pragma mark - Objc Func

- (void)queryHomeInGamesStatus {
    [CNHomeRequest queryGamesHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            self.inGameDict = responseObj;
        }
    }];
}

- (void)inGame:(InGameType)gType {
    if (!self.inGameDict) {
        [CNHUB showError:@"游戏数据为空 正在为您重新加载.."];
        [self queryHomeInGamesStatus];
        return;
    }
    
    NSString *gameCode = InGameTypeString[gType];
    NSString *gameName;
    NSString *gameType;
    NSString *gameId;
    switch (gType) {
        case InGameTypeAGQJ:
            gameName = @"百家乐-旗舰厅";
            gameType = @"BAC";
            gameId = @"";
            break;
        case InGameTypeAGIN:
            gameName = @"百家乐-国际厅";
            gameType = @"BAC";
            gameId = @"";
            break;
        case InGameTypeAGBY:
            gameName = @"捕鱼王";
            gameType = @"6";
            gameId = @"";
            break;
        case InGameTypeSHABA:
            gameName = @"沙巴体育";
            gameType = @"7";
            gameId = @"";
            break;
        case InGameTypeYSB:
            gameName = @"易胜博体育";
            gameType = @"";
            gameId = @"";
            break;
        case InGameTypeHYTY:
            gameName = @"币游体育";
            gameType = @"";
            gameId = @"";
            break;
        case InGameTypeKENO:
            gameName = @"彩票";
            gameType = @"";
            gameId = @"直接进厅";
            break;
        case InGameTypeQG:
            gameName = @"QG刮刮乐";
            gameType = @"12";
            gameId = @"";
            break;
        case InGameTypeAGSTAR:
            gameName = @"AS真人棋牌";
            gameType = @"BAC";
            gameId = @"";
            break;
        default:
            break;
    }

    MyLog(@"===> name:%@, type:%@, gameId:%@, gameCode:%@", gameName, gameType, gameId, gameCode);
    
    // 游戏线路
    if ([self.inGameDict.allKeys containsObject:gameCode]) {
        
        NSArray *gameLines = self.inGameDict[gameCode];
        BOOL hasCNY = NO;
        BOOL hasUSDT = NO;
        for (NSDictionary *dict in gameLines) {
            GameLineModel *model = [GameLineModel cn_parse:dict];
            if ([model.platformCurrency isEqualToString:@"CNY"]) {
                hasCNY = YES;
            } else if ([model.platformCurrency isEqualToString:@"USDT"]) {
                hasUSDT = YES;
            }
        }
        [CNGameLineView choseCnyLineHandler:hasCNY?^{
            [HYInGameHelper jump2GameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:@"CNY"];
        }:nil choseUsdtLineHandler:hasUSDT?^{
            [HYInGameHelper jump2GameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:@"USDT"];
        }:nil];
        
        // 容错
    } else {
        [HYInGameHelper jump2GameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:nil];
    }
    
}

- (void)inElecGameGameName:(NSString *)gameName
                  gameType:(NSString *)gameType
                    gameId:(NSString *)gameId
                  gameCode:(NSString *)gameCode
   platformSupportCurrency:(nullable NSString *)platformSupportCurrency {
    
//    NSString *newGameCode;
//    if ([gameCode hasPrefix:@"A03"]) {
//        newGameCode = gameCode;
//    }else{
//        newGameCode = [NSString stringWithFormat:@"A03%@", gameCode];
//    }
    
    MyLog(@"===> name:%@, type:%@, gameId:%@, gameCode:%@", gameName, gameType, gameId, gameCode);
    
    // 游戏线路
    if ([self.inGameDict.allKeys containsObject:gameCode]) {
        
        NSArray *gameLines = self.inGameDict[gameCode];
        BOOL hasCNY = NO;
        BOOL hasUSDT = NO;
        for (NSDictionary *dict in gameLines) {
            GameLineModel *model = [GameLineModel cn_parse:dict];
            if ([model.platformCurrency isEqualToString:@"CNY"]) {
                if (platformSupportCurrency.length > 0 && ![platformSupportCurrency containsString:@"CNY"]) { // 该游戏不支持CNY
                    hasCNY = NO;
                } else {
                    hasCNY = YES;
                }
            } else if ([model.platformCurrency isEqualToString:@"USDT"]) {
                if (platformSupportCurrency.length > 0 && ![platformSupportCurrency containsString:@"USDT"]) { // 该游戏不支持CNY
                    hasUSDT = NO;
                } else {
                    hasUSDT = YES;
                }
            }
        }
        [CNGameLineView choseCnyLineHandler:hasCNY?^{
            [HYInGameHelper jump2ElecGameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:@"CNY"];
        }:nil choseUsdtLineHandler:hasUSDT?^{
            [HYInGameHelper jump2ElecGameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:@"USDT"];
        }:nil];
        
        // 容错
    } else {
        [HYInGameHelper jump2ElecGameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:nil];
    }
}


#pragma mark - Class Func
/// 首页跳到游戏（该方法内部使用）
/// @param gameName 游戏名
/// @param gameType 游戏类型
/// @param gameId 游戏ID
/// @param gameCode 游戏代码
/// @param platformCurrency 线路（游戏货币）
+ (void)jump2GameName:(NSString *)gameName
             gameType:(NSString *)gameType
               gameId:(NSString *)gameId
             gameCode:(NSString *)gameCode
     platformCurrency:(nullable NSString *)platformCurrency {
    
    [CNHomeRequest requestInGameUrlGameType:gameType
                                     gameId:gameId
                                   gameCode:gameCode
                           platformCurrency:platformCurrency
                                    handler:^(id responseObj, NSString *errorMsg) {
        
        GameModel *gameModel = [GameModel cn_parse:responseObj];
        NSString *gameUrl = gameModel.url;
        if ([gameUrl containsString:@"&callbackUrl="]) {
            gameUrl = [gameUrl stringByReplacingOccurrencesOfString:@"&callbackUrl=" withString:@"&callbackUrl=https://localhost/exit.html"];
        }
        GameStartPlayViewController *vc = [[GameStartPlayViewController alloc] initGameWithGameUrl:gameUrl title:gameName];
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
        
    }];
}

/// 跳到电子游戏
+ (void)jump2ElecGameName:(NSString *)gameName
                 gameType:(NSString *)gameType
                   gameId:(NSString *)gameId
                 gameCode:(NSString *)gameCode
         platformCurrency:(NSString *)platformCurrency {
    
    [CNHomeRequest requestInGameUrlGameType:gameType
                                     gameId:gameId
                                   gameCode:gameCode
                           platformCurrency:platformCurrency handler:^(id responseObj, NSString *errorMsg) {
        
        GameModel *gameModel = [GameModel cn_parse:responseObj];
        NSMutableString *gameUrl = gameModel.url.mutableCopy;
        if (KIsEmptyString(gameUrl)) {
           [kKeywindow jk_makeToast:@"获取游戏数据为空" duration:1.5 position:JKToastPositionCenter];
           return;
        }
        if (gameModel.postMap) {
            if (![gameUrl containsString:@"?"]) {
                [gameUrl appendString:@"?"];
            }
            [gameUrl appendFormat:@"gameID=%@&gameType=%@&username=%@&password=%@", gameModel.postMap.gameID, gameModel.postMap.gameType, gameModel.postMap.username, gameModel.postMap.password];
        }
        GameStartPlayViewController *vc = [[GameStartPlayViewController alloc] initGameWithGameUrl:gameUrl.copy title:gameName];
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];

    }];
}

@end
