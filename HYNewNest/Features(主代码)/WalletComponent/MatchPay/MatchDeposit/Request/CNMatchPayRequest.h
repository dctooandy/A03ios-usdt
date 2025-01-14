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

/// 查询是否开启急存款速通道
/// @param finish 完成回调
+ (void)queryFastPayOpenFinish:(HandlerBlock)finish;

/// 创建撮合订单
/// @param amount 撮合的金额
/// @param realName  存款人真实名字
/// @param finish 完成回调
+ (void)createDepisit:(NSString *)amount realName:(NSString *)realName finish:(HandlerBlock)finish;

/// 确认撮合订单
/// @param billId  订单号
/// @param imgName  存款回执单图名字
/// @param imgNames  银行流水图名字数组
/// @param finish 完成回调
+ (void)commitDepisit:(NSString *)billId receiptImg:(nullable NSString *)imgName transactionImg:(nullable NSArray *)imgNames finish:(HandlerBlock)finish;

/// 取消撮合订单
/// @param billId  订单号
/// @param finish 完成回调
+ (void)cancelDepisit:(NSString *)billId finish:(HandlerBlock)finish;

/// 查询存款详情
/// @param billId  订单号
/// @param finish 完成回调
+ (void)queryDepisit:(NSString *)billId finish:(HandlerBlock)finish;

/// 上传图片
/// @param receiptImages  回执单图片组
/// @param recordImages  流水图片数组
/// @param billId  订单号
/// @param finish 完成回调
+ (void)uploadReceiptImages:(NSArray *)receiptImages recordImages:(NSArray *)recordImages billId:(NSString *)billId finish:(HandlerBlock)finish;
@end

NS_ASSUME_NONNULL_END
