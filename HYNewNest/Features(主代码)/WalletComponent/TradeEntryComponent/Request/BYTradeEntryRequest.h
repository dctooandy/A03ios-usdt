//
//  BYTradeEntryRequest.h
//  HYNewNest
//
//  Created by RM04 on 2021/6/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TradeEntryType) {
    TradeEntryTypeDeposit = 0,
    TradeEntryTypeWithdraw,
};

@interface BYTradeEntryRequest : CNBaseNetworking

///取得賣/提幣資料
+ (void)fetchTradeHandler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
