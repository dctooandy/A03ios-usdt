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
/// status 入参状态对应：审核中（不传）；使用中（2，3，8）；已结束（4，5，7）
+ (void)getWalletCouponsList:(BYVocherTagList)list handler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    switch (list) {
        case BYVocherTagListInReview:
            param[@"status"] = @[@(BYVocherStatusInReview), @(BYVocherStatusInReview2), @(BYVocherStatusToActivate)];
            break;
        case BYVocherTagListUsing:
            param[@"status"] = @[@(BYVocherStatusUsing),@(BYVocherStatusActivated),@(BYVocherStatusLock)];
            break;
        case BYVocherTagListEnded:
            param[@"status"] = @[@(BYVocherStatusManualEnd),@(BYVocherStatusRelease),@(BYVocherStatusRunsUp)];
            break;
        default:
            break;
    }
    [self POST:kGatewayPath(config_walletCoupon) parameters:param completionHandler:handler];
}

@end
