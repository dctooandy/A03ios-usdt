//
//  BYMyBonusRequest.h
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "BYMyBounsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYMyBonusRequest : CNBaseNetworking

/// 获取我的我的优惠列表  其中分可领 已领 过期  可充值
/// @param handler 回调
+ (void)getMyBonusListHandler:(HandlerBlock)handler;
// 领取我的优惠
+ (void)fetchMyBonusWithRequestID:(NSString*)requestId Handler:(HandlerBlock)handler ;

@end

NS_ASSUME_NONNULL_END
