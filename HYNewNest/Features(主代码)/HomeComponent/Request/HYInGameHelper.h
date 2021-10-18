//
//  HYInGameHelper.h
//  HYNewNest
//
//  Created by zaky on 8/24/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, InGameType) {
    InGameTypeAGQJ = 0, //旗舰厅A03003
    InGameTypeAGIN,     //国际厅026
    InGameTypeAGBY,     //捕鱼王026
    InGameTypeSHABA,    //沙巴体育031
    InGameTypeYSB,      //易胜博068
    InGameTypeHYTY,     //币游体育062
    InGameTypeKENO,     //彩票004
    InGameTypeQG,       //刮刮乐080
    InGameTypeAGSTAR,   //真人棋牌064
    InGameTypeAGEG,     //国际厅026
};

@interface HYInGameHelper : NSObject

+ (instancetype)sharedInstance;

/// 查询游戏进线(CURRENCY)状态
- (void)queryHomeInGamesStatus;

/// 进入首页游戏 编号
- (void)inGame:(InGameType)gType;

/// 进桌台
- (void)inBACGameTableCode:(NSString *)tableCode;

/// 进入电游
// platformSupportCurrency(支持的货币渠道)可能是：1."";2."CNY";3."USDT";4."CNY,USDT"
- (void)inElecGameGameName:(NSString *)gameName
                gameNameEn:(NSString *)gameNameEn
                  gameType:(NSString *)gameType
                    gameId:(NSString *)gameId
                  gameCode:(NSString *)gameCode
              platformCode:(NSString *)platformCode
   platformSupportCurrency:(nullable NSString *)platformSupportCurrency;

@end

NS_ASSUME_NONNULL_END
