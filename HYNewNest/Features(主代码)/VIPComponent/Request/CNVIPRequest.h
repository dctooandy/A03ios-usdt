//
//  CNVIPRequest.h
//  HYNewNest
//
//  Created by zaky on 8/29/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "VIPLevelData.h"
#import "VIPRewardAnocModel.h"
#import "VIPGuideModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNVIPRequest : CNBaseNetworking

/// 2.0弹窗
+ (void)vipsxhGuideHandler:(HandlerBlock)handler;
/// 月报弹窗
+ (void)vipsxhMonthReportHandler:(HandlerBlock)handler;

+ (void)requestRewardBroadcastHandler:(HandlerBlock)handler;


@end

NS_ASSUME_NONNULL_END
