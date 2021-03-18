//
//  BYVoucherRequest.h
//  HYNewNest
//
//  Created by zaky on 3/16/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "BYVocherModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 优惠券状态
typedef NS_ENUM(NSUInteger, BYVocherStatus) {
    // 待激活
    BYVocherStatusToActivate = 1,     //待激活
    BYVocherStatusActivated = 2,      //已激活
    // 使用中
    BYVocherStatusUsing = 3,          //使用中
    BYVocherStatusLock = 8,            //锁定
    // 已结束
    BYVocherStatusRelease = 4,        //已释放
    BYVocherStatusRunsUp = 5,         //已输光，前端显示已用光
    BYVocherStatusManualEnd = 7,      //手动结束
    
    BYVocherStatusExpired = 6,        //已失效
};

static NSString * _Nonnull VocherStatusString[] = {
    [BYVocherStatusToActivate] = @"待激活",
    [BYVocherStatusActivated] = @"使用中",
    [BYVocherStatusUsing] = @"使用中",
    [BYVocherStatusRelease] = @"已释放",
    [BYVocherStatusRunsUp] = @"已用光",
    [BYVocherStatusExpired] = @"已失效",
    [BYVocherStatusManualEnd] = @"人工结束",
    [BYVocherStatusLock] = @"人工锁定",
};

/// 优惠券三大状态
typedef NS_ENUM(NSInteger, BYVocherTagList) {
    BYVocherTagListInReview = 0,
    BYVocherTagListUsing,
    BYVocherTagListEnded
};

@interface BYVoucherRequest : CNBaseNetworking
+ (void)getWalletCouponsList:(BYVocherTagList)list handler:(HandlerBlock)handler;
@end

NS_ASSUME_NONNULL_END
