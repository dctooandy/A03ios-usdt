//
//  KYMNetworingWrapper.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/21.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYMWithdrewCheckModel.h"
#import "KYMCreateWithdrewModel.h"
#import "KYMGetWithdrewDetailModel.h"
#import "KYMCheckReceiveModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^KYMCallback)(BOOL status,NSString *msg,id _Nullable body);


extern void kym_sendRequest(NSString * url, id params, KYMCallback callback);
extern void kym_requestBalance(KYMCallback callback);

@interface KYMWithdrewRequest : NSObject
//查询撮合渠道开启状态
+ (void)checkChannelWithParams:(NSDictionary *)params callback:(KYMCallback)callback;
//创建取款提案
+ (void)createWithdrawWithBankNum:(NSString *)bankNum amount:(NSString *)amount pwd:(NSString *)pwd  callback:(KYMCallback)callback ;
//获取取款明细
+ (void)getWithdrawDetailWithParams:(NSDictionary *)params callback:(KYMCallback)callback;
//取款到账/未到账操作
+ (void)checkReceiveStatus:(NSDictionary *)params callback:(KYMCallback)callback;
//取消撮合存款
+ (void)cancelWithdrawWithParams:(NSDictionary *)params callback:(KYMCallback)callback;

+ (void)checkWithdrawWithCallBack:(void(^)(BOOL isMatch,KYMWithdrewCheckModel  * checkModel))callback;

//是否到账
+ (void)checkReceiveStats:(BOOL)isNotRceived transactionId:(NSString *)transactionId   callBack:(void(^)(BOOL status, NSString *msg))callBack;
@end

NS_ASSUME_NONNULL_END
