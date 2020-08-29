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

NS_ASSUME_NONNULL_BEGIN

@interface CNVIPRequest : CNBaseNetworking

+ (void)requestRewardBroadcastHandler:(HandlerBlock)handler;

+ (void)requestVIPPromotionHandler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
