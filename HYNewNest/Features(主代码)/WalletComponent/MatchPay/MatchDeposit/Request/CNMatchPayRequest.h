//
//  CNMatchPayRequest.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/19/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNMatchPayRequest : CNBaseNetworking

/// 创建撮合订单
/// @param amount 撮合的金额
/// @param finish 完成回调
+ (void)createDepisit:(NSString *)amount finish:(HandlerBlock)finish;

/// 确认撮合订单
/// @param billId  订单号
/// @param imgName  存款回执单图名字
/// @param imgNames  银行流水图名字数组
/// @param finish 完成回调
+ (void)commitDepisit:(NSString *)billId receiptImg:(NSString *)imgName transactionImg:(NSArray *)imgNames finish:(HandlerBlock)finish;

/// 取消撮合订单
/// @param billId  订单号
/// @param finish 完成回调
+ (void)cancelDepisit:(NSString *)billId finish:(HandlerBlock)finish;

/// 查询取款详情
/// @param billId  订单号
/// @param finish 完成回调
+ (void)queryDepisit:(NSString *)billId finish:(HandlerBlock)finish;

/// 上传图片
/// @param image  图片
/// @param finish 完成回调
+ (void)uploadImage:(UIImage *)image finish:(HandlerBlock)finish;
@end

NS_ASSUME_NONNULL_END
