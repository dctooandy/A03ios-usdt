//
//  BYVoucherRequest.m
//  HYNewNest
//
//  Created by zaky on 3/16/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYVoucherRequest.h"

@implementation BYVoucherRequest

/// 获取优惠券列表
/// status 优惠券状态（数组）[1.待激活... 8.锁定]
/// status 入参状态对应：待激活（传1，2）；使用中（3，8）；已结束（4，5，7）
+ (void)getWalletCouponsList:(BYVocherTagList)list handler:(HandlerBlock)handler {

    NSMutableDictionary *param = @{}.mutableCopy;
    switch (list) {
        case BYVocherTagListInReview:
            param[@"status"] = @[@(BYVocherStatusToActivate),@(BYVocherStatusActivated)];
            break;
        case BYVocherTagListUsing:
            param[@"status"] = @[@(BYVocherStatusUsing),@(BYVocherStatusLock)];
            break;
        case BYVocherTagListEnded:
            param[@"status"] = @[@(BYVocherStatusManualEnd),@(BYVocherStatusRelease),@(BYVocherStatusRunsUp)];
            break;
        default:
            break;
    }
    [self POST:kGatewayExtraPath(config_walletCoupon) parameters:param completionHandler:handler];
}

@end
