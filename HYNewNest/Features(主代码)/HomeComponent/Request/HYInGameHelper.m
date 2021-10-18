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
    [InGameTypeAGQJ]    = @"A01003",
    [InGameTypeAGIN]    = @"A01026",
    [InGameTypeAGBY]    = @"A01026",
    [InGameTypeSHABA]   = @"A01031",
    [InGameTypeYSB]     = @"A01068",
    [InGameTypeHYTY]    = @"A01062",
    [InGameTypeKENO]    = @"A01004",
    [InGameTypeQG]      = @"A01080",
    [InGameTypeAGSTAR]  = @"A01064",
    [InGameTypeAGEG]    = @"A01026"
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

- (void)inBACGameTableCode:(NSString *)tableCode {
    if (!self.inGameDict) {
        [CNTOPHUB showWaiting:@"游戏数据为空 正在为您重新加载.."];
        [self queryHomeInGamesStatus];
        return;
    }
    if (![CNUserManager shareManager].isLogin) {
        [CNTOPHUB showError:@"请先登录后再进入该游戏"];
        [NNPageRouter jump2Login];
        return;
    }

    [CNHomeRequest requestBACInGameUrlTableCode:tableCode handler:^(id responseObj, NSString *errorMsg) {
        
        GameModel *gameModel = [GameModel cn_parse:responseObj];
        NSString *gameUrl = gameModel.url;
        
        //保存一下游戏URL 用于网络检测
        NSString *gc = [gameUrl componentsSeparatedByString:@"?"].firstObject;
        NSString *gcNeed2Remove = [gc componentsSeparatedByString:@"/"].lastObject;
        gcNeed2Remove = [NSString stringWithFormat:@"/%@", gcNeed2Remove];
        gc = [gc stringByReplacingOccurrencesOfString:gcNeed2Remove withString:@""];
        [IVHttpManager shareManager].gameDomain = gc;
        
        if ([gameUrl containsString:@"&callbackUrl="]) {
            gameUrl = [gameUrl stringByReplacingOccurrencesOfString:@"&callbackUrl=" withString:@"&callbackUrl=https://localhost/exit.html"];
        }
        GameStartPlayViewController *vc = [[GameStartPlayViewController alloc] initGameWithGameUrl:gameUrl title:@"百家乐-旗舰厅"];
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
    }];
    
}

- (void)inGame:(InGameType)gType {
    if (!self.inGameDict) {
        [CNTOPHUB showWaiting:@"游戏数据为空 正在为您重新加载.."];
        [self queryHomeInGamesStatus];
        return;
    }
    if (![CNUserManager shareManager].isLogin) {
        [CNTOPHUB showError:@"请先登录后再进入该游戏"];
        [NNPageRouter jump2Login];
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
            gameId = @"AG_FISH_6";
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
        case InGameTypeAGEG:
            gameName = @"AG电游厅";
            gameType = @"500";
            gameId = @"500";
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
            // 这里AGIN需要区分是真人还是电游
            if ([gameCode isEqualToString:@"A01026"]) {
                if (gameId.length>0 && ([gameType isEqualToString:@"500"] || [gameType isEqualToString:@"6"])) { //捕鱼&电游
                    if ([model.platformCurrency isEqualToString:@"CNY"]) {
                        hasCNY = YES;
                        MyLog(@"捕鱼 - 有CNY");
                    } else if ([model.platformCurrency isEqualToString:@"USDT"]) {
                        hasUSDT = YES;
                        MyLog(@"捕鱼 - 有USDT");
                    }
                } else if (gameId.length==0 && [gameType isEqualToString:@"BAC"]) { // 真人
                    if ([model.platformCurrency isEqualToString:@"CNY"]) {
                        hasCNY = YES;
                        MyLog(@"真人 - 有CNY");
                    } else if ([model.platformCurrency isEqualToString:@"USDT"]) {
                        hasUSDT = YES;
                        MyLog(@"真人 - 有USDT");
                    }
                }
            // 正常判断线路
            } else {
                if ([model.platformCurrency isEqualToString:@"CNY"]) {
                    hasCNY = YES;
                    MyLog(@"其他 - 有CNY");
                } else if ([model.platformCurrency isEqualToString:@"USDT"]) {
                    hasUSDT = YES;
                    MyLog(@"其他 - 有USDT");
                }
            }
        }
        
        // 手动去掉A03
        if ([gameCode hasPrefix:@"A01"]) {
            gameCode = [gameCode stringByReplacingOccurrencesOfString:@"A01" withString:@""];
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
                gameNameEn:(NSString *)gameNameEn
                  gameType:(NSString *)gameType
                    gameId:(NSString *)gameId
                  gameCode:(NSString *)gameCode
              platformCode:(NSString *)platformCode
   platformSupportCurrency:(nullable NSString *)platformSupportCurrency {
    
    if (!self.inGameDict) {
        [CNTOPHUB showWaiting:@"游戏数据为空 正在为您重新加载.."];
        [self queryHomeInGamesStatus];
        return;
    }
    if (![CNUserManager shareManager].isLogin) {
        [CNTOPHUB showError:@"请先登录后再进入该游戏"];
        [NNPageRouter jump2Login];
        return;
    }
    
    // 手动拼接A03 用于匹配查询而已
    NSString *fullGameCode;
    if ([gameCode hasPrefix:@"A01"]) {
        fullGameCode = gameCode;
    }else{
        fullGameCode = [NSString stringWithFormat:@"A01%@", gameCode];
    }
    
    MyLog(@"===> name:%@, type:%@, gameId:%@, gameCode:%@", gameName, gameType, gameId, fullGameCode);
    
    // 游戏线路
    if ([self.inGameDict.allKeys containsObject:fullGameCode]) {
        
        NSArray *gameLines = self.inGameDict[fullGameCode];
        BOOL hasCNY = NO;
        BOOL hasUSDT = NO;
        for (NSDictionary *dict in gameLines) {
            GameLineModel *model = [GameLineModel cn_parse:dict];
            if ([gameCode isEqualToString:@"A01026"]) { //进入的电游是捕鱼
                if ([gameType isEqualToString:@"6"]) { //模型是捕鱼
                    if ([model.platformCurrency isEqualToString:@"CNY"]) {
                        hasCNY = YES;
                        MyLog(@"捕鱼 - 有CNY");
                    } else if ([model.platformCurrency isEqualToString:@"USDT"]) {
                        hasUSDT = YES;
                        MyLog(@"捕鱼 - 有USDT");
                    }
                }
            // 进入的是其他电游
            } else {
                if ([model.platformCurrency isEqualToString:@"CNY"]) {
                    hasCNY = YES;
                    MyLog(@"其他 - 有CNY");
                } else if ([model.platformCurrency isEqualToString:@"USDT"]) {
                    hasUSDT = YES;
                    MyLog(@"其他 - 有USDT");
                }
            }
        }
        
        // 手动去掉A03
        if ([gameCode hasPrefix:@"A01"]) {
            gameCode = [gameCode stringByReplacingOccurrencesOfString:@"A01" withString:@""];
        }
        
        [CNGameLineView choseCnyLineHandler:hasCNY?^{
            [HYInGameHelper jump2ElecGameName:gameName gameNameEn:gameNameEn gameType:gameType gameId:gameId gameCode:gameCode platformCode:platformCode platformCurrency:@"CNY"];
        }:nil choseUsdtLineHandler:hasUSDT?^{
            [HYInGameHelper jump2ElecGameName:gameName gameNameEn:gameNameEn gameType:gameType gameId:gameId gameCode:gameCode platformCode:platformCode platformCurrency:@"USDT"];
        }:nil];
        
        // 容错
    } else {
        [HYInGameHelper jump2ElecGameName:gameName gameNameEn:gameNameEn gameType:gameType gameId:gameId gameCode:gameCode platformCode:platformCode platformCurrency:nil];
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
                                   gameName:nil
                               platformCode:nil
                           platformCurrency:platformCurrency
                                    handler:^(id responseObj, NSString *errorMsg) {
        
        GameModel *gameModel = [GameModel cn_parse:responseObj];
        NSString *gameUrl = gameModel.url;
        
        if ([gameCode isEqualToString:@"003"]) {
            //保存一下游戏URL 用于网络检测
            NSString *gc = [gameUrl componentsSeparatedByString:@"?"].firstObject;
            NSString *gcNeed2Remove = [gc componentsSeparatedByString:@"/"].lastObject;
            gcNeed2Remove = [NSString stringWithFormat:@"/%@", gcNeed2Remove];
            gc = [gc stringByReplacingOccurrencesOfString:gcNeed2Remove withString:@""];
            [IVHttpManager shareManager].gameDomain = gc;
        }
        
        if ([gameUrl containsString:@"&callbackUrl="]) {
            gameUrl = [gameUrl stringByReplacingOccurrencesOfString:@"&callbackUrl=" withString:@"&callbackUrl=https://localhost/exit.html"];
        }
        GameStartPlayViewController *vc = [[GameStartPlayViewController alloc] initGameWithGameUrl:gameUrl title:gameName];
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
        
    }];
}

/// 跳到电子游戏
+ (void)jump2ElecGameName:(NSString *)gameName
               gameNameEn:(NSString *)gameNameEn
                 gameType:(NSString *)gameType
                   gameId:(NSString *)gameId
                 gameCode:(NSString *)gameCode
             platformCode:(NSString *)platformCode
         platformCurrency:(NSString *)platformCurrency {
    
    [CNHomeRequest requestInGameUrlGameType:gameType
                                     gameId:gameId
                                   gameCode:gameCode
                                   gameName:gameNameEn
                               platformCode:(NSString *)platformCode
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
