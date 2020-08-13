//
//  CNGameLineView.h
//  HYNewNest
//
//  Created by Cean on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNGameLineView : CNBaseXibView

/// 进游戏线路选择
/// @param cnyHandler  cny线路，没有传 nil
/// @param usdtHandler usdt线路，没有传 nil
+ (void)choseCnyLineHandler:(nullable dispatch_block_t)cnyHandler choseUsdtLineHandler:(nullable dispatch_block_t)usdtHandler;
@end

NS_ASSUME_NONNULL_END
