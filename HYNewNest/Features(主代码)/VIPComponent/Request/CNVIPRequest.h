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

NS_ASSUME_NONNULL_BEGIN

@interface CNVIPRequest : CNBaseNetworking

/// 2.0弹窗
+ (void)vipsxhGuideHandler:(HandlerBlock)handler;
/// 月报弹窗
+ (void)vipsxhMonthReportHandler:(HandlerBlock)handler;
// kill
+ (void)requestRewardBroadcastHandler:(HandlerBlock)handler;
/// 首页
+ (void)vipsxhHomeHandler:(HandlerBlock)handler;
/// 至尊转盘
+ (void)vipsxhZzzpHandler:(HandlerBlock)handler;
/// 大神榜
+ (void)vipsxhBigGodBoardHandler:(HandlerBlock)handler;
/// 入会礼金
+ (void)vipsxhDrawGiftMoneyLevelStatus:(NSString *)levelStatus handler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
