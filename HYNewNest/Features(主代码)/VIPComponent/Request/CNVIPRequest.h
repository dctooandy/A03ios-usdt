//
//  CNVIPRequest.h
//  HYNewNest
//
//  Created by zaky on 8/29/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "VIPRewardAnocModel.h"
#import "VIPGuideModel.h"
#import "VIPMonthlyModel.h"
#import "VIPHomeUserModel.h"
#import "VIPDSBUsrModel.h"
#import "VIPIdentityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNVIPRequest : CNBaseNetworking

/// 2.0弹窗
+ (void)vipsxhGuideHandler:(HandlerBlock)handler;
/// 是否弹出月报
+ (void)vipsxhIsShowReportHandler:(HandlerBlock)handler;
/// 月报弹窗
+ (void)vipsxhMonthReportHandler:(HandlerBlock)handler;
/// 首页
+ (void)vipsxhHomeHandler:(HandlerBlock)handler;
/// 大神榜
+ (void)vipsxhBigGodBoardHandler:(HandlerBlock)handler;
/// 入会礼金
+ (void)vipsxhDrawGiftMoneyLevelStatus:(NSString *)levelStatus
                               handler:(HandlerBlock)handler;

/// 累计身份
+ (void)vipsxhCumulateIdentityHandler:(HandlerBlock)handler;
/// 累计身份 领取奖励
+ (void)vipsxhApplyCumulateIdentityPrize:(NSString *)prizeids
                                 handler:(HandlerBlock)handler;
/// 礼物详情
+ (void)vipsxhAwardDetailPrizeids:(NSString *)prizeids
                          handler:(HandlerBlock)handler;

typedef NS_ENUM(NSInteger, VIPSxhAwardType) {
    // 标识，至尊转盘1,累计身份兑换传2，入会礼金传3，私享金4
//    VIPSxhAwardTypeZZZP = 3,//至尊转盘
//    VIPSxhAwardTypeLJSF = 4,//累计身分
    VIPSxhAwardTypeZZZP = 1,//至尊转盘
    VIPSxhAwardTypeLJSF = 2,//累计身分
    VIPSxhAwardTyperhlj = 3,//入会礼金
    VIPSxhAwardTypesxh = 4,//思想会
};
/// 领取记录
+ (void)vipsxhReceiveAwardRecordType:(VIPSxhAwardType)type
                                 day:(NSInteger)days
                             handler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
