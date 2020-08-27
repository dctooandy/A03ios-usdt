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

/// gameCode对应表
NSString *const InGameTypeString[] = {
    [InGameTypeAGQJ]    = @"A03003",
    [InGameTypeAGIN]    = @"A03026",
    [InGameTypeAGBY]    = @"A03026",
    [InGameTypeSHABA]   = @"A03031",
    [InGameTypeYSB]     = @"A03068",
    [InGameTypeHYTY]    = @"A03062",
    [InGameTypeKENO]    = @"A03004",
    [InGameTypeQG]      = @"A03080",
    [InGameTypeAGSTAR]  = @"A03064"
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

    MyLog(@"===> %@,%@,%@,%@", gameName, gameType, gameId, gameCode);
    
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
            [NNPageRouter jump2GameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:@"CNY"];
        }:nil choseUsdtLineHandler:hasUSDT?^{
            [NNPageRouter jump2GameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:@"USDT"];
        }:nil];
        
        // 容错
    } else {
        [NNPageRouter jump2GameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:nil];
    }
    
}

- (void)inElecGameGameName:(NSString *)gameName
                  gameType:(NSString *)gameType
                    gameId:(NSString *)gameId
                  gameCode:(NSString *)gameCode {
    
    MyLog(@"===> %@,%@,%@,%@", gameName, gameType, gameId, gameCode);
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
            [NNPageRouter jump2ElecGameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:@"CNY"];
        }:nil choseUsdtLineHandler:hasUSDT?^{
            [NNPageRouter jump2ElecGameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:@"USDT"];
        }:nil];
        
        // 容错
    } else {
        [NNPageRouter jump2ElecGameName:gameName gameType:gameType gameId:gameId gameCode:gameCode platformCurrency:nil];
    }
}


@end
