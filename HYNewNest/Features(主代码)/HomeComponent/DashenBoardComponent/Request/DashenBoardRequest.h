//
//  DashenBoardRequest.h
//  HYNewNest
//
//  Created by zaky on 12/8/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "DSBRecharWithdrwUsrModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DashenBoardRequest : CNBaseNetworking


typedef NS_ENUM(NSUInteger, DashenBoredReqType) {
    DashenBoredReqTypeRecharge,
    DashenBoredReqTypeWithdraw,
    DashenBoredReqTypeTotalWeek,
    DashenBoredReqTypeTotalMonth,
};
/// 大神榜
+ (void)requestDashenBoredType:(DashenBoredReqType)type
                       handler:(HandlerBlock)handler;

/// 盈利榜
+ (void)requestProfitPageNo:(NSInteger)pageNo
                  beginDate:(NSString *)beginDate
                    endDate:(NSString *)endDate
                    handler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
