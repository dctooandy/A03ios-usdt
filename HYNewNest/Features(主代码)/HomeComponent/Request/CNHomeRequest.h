//
//  CNHomeRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/21.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"

#import "ElecGameModel.h"
#import "GameModel.h"
#import "AdBannerGroupModel.h"
#import "AnnounceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNHomeRequest : CNBaseNetworking

/**
 白名单 存取款客服  vip_depositLive800
 白名单 其他客服    vip_otheLive800
 数字站 存取款客服  usdt_depositLive800
 数字站 其他客服    usdt_otheLive800
 忘记密码
 */
///动态表单获取5个客服链接
+ (void)requestDynamicLive800AddressCompletionHandler:(HandlerBlock)handler;

/// 客服回拨
+ (void)callCenterCallBackMessageId:(nullable NSString *)messageId
                            smsCode:(nullable NSString *)smsCode
                           mobileNo:(nullable NSString*)mobileNo
                            handler:(HandlerBlock)handler;

///进入H5获取ticket
+ (void)requestH5TicketHandler:(HandlerBlock)handler;


typedef NS_ENUM(NSInteger, BannerWhere) {
    BannerWhereHome, //首页
    BannerWhereGame, //电游
    BannerWhereFriend //好友推荐
};
///获取Banner
+ (void)requestBannerWhere:(BannerWhere)where
                   Handler:(HandlerBlock)handler;

///获取公告
+ (void)requestGetAnnouncesHandler:(HandlerBlock)handler;

/// 进游戏
+(void)requestInGameUrlGameType:(NSString *)gameType
                         gameId:(NSString *)gameId
                       gameCode:(NSString *)gameCode
               platformCurrency:(nullable NSString *)platformCurrency
                        handler:(HandlerBlock)handler;

/// 查询游戏线路
+ (void)queryGamesHandler:(HandlerBlock)handler;

 
#pragma mark 电游

///电游--获取最近玩过的游戏
+ (void)queryElecGamePlayLogHandler:(HandlerBlock)handler;

///电游--获取收藏电子游戏列表
+ (void)queryFavoriteElecHandler:(HandlerBlock)handler;

typedef NS_ENUM(NSInteger, ElecGameFavoriteFlag) {
    ElecGameFavoriteFlagDel = -1,
    ElecGameFavoriteFlagAdd = 1
};

/// 电游--修改是否收藏
/// @param gameId 模型中取
/// @param platformCode 模型中取
/// @param flag 删除还是添加
/// @param handler 回调
+ (void)updateFavoriteElecGameId:(NSString *)gameId
                    platformCode:(NSString *)platformCode
                            flag:(ElecGameFavoriteFlag)flag
                         handler:(HandlerBlock)handler;

///电游--获取电子游戏列表

/// 游戏特性
typedef NS_ENUM(NSInteger, ElecGame3Type) {
    ElecGame3TypePayout = 0, //高派彩
    ElecGame3TypePool,       //高奖池
    ElecGame3TypeHigh        //高爆奖
};

/// 获取电游列表 -- 三个特性
/// @param type 种类
/// @param handler 回调
+ (void)queryElecGamesOneOfThreeType:(ElecGame3Type)type
                             handler:(HandlerBlock)handler;

/// 获取电游列表 -- 搜索
/// @param gameName 游戏名
/// @param handler 回调
+ (void)searchElecGameName:(NSString *)gameName
                    pageNo:(NSInteger)pageNo
                   handler:(HandlerBlock)handler;


/// 获取电游列表 -- 筛选
/// @param pageNo 页码（默认每次查询20个）
/// @param gameType 游戏类型，如所有类型传“@""”，如有多个用“,”分隔
/// @param platformNames 平台名，如所有平台传“@""”，如有多个用“,”分隔*/
/// @param payLines 赔付线，字典数组，如所有赔付线传“@[]”，如有多个用字典分隔
/// @param handler 回调
+ (void)queryElecGamesWithPageNo:(NSInteger)pageNo
                        gemeType:(NSString *)gameType
                   platformNames:(NSArray<NSString *> *)platformNames
                        payLines:(NSArray<NSDictionary *> *)payLines
                         handler:(HandlerBlock)handler;


@end

NS_ASSUME_NONNULL_END
