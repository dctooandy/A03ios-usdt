//
//  CNBonusRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "MyPromoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNBonusRequest : CNBaseNetworking

/// 获取我的红利列表  其中分电游 真人 其它
/// @param handler 回调
+ (void)getBonusListHandler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
