//
//  CNXiMaRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "XmCalcAmountModel.h"
#import "XmPlatformModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNXiMaRequest : CNBaseNetworking

/// 查询所有游戏厅洗码列表
/// @param handler 回调
+ (void)xmQueryXmpPlatformHandler:(HandlerBlock)handler;


/// 查询洗码额度
/// @param xmTypeArr 洗码类型数组 @[XmPlatformListItem.xmType]
/// @param handler 回调
+ (void)xmCalcAmountV3WithXmTypes:(NSArray *)xmTypeArr handler:(HandlerBlock)handler;


/// 创建洗码提案
/// @param xmBeginDate 开始时间
/// @param xmEndDate 结束时间
/// @param xmRequests 洗码item
/// @param handler 回调
+ (void)xmCreateRequestXmBeginDate:(NSString *)xmBeginDate
                         xmEndDate:(NSString *)xmEndDate
                        xmRequests:(NSArray <XmTypesItem *>*)xmRequests
                           handler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
