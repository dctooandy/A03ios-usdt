//
//  IVCheckNetworkWrapper.h
//  IVCheckNetworkLibrary
//
//  Created by Key on 25/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IVCheckNetworkModel.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kCheckTypeNameKey;
extern NSString * const kCheckUrlKey;
extern NSString * const kCheckTimeKey;
extern NSString * const kCheckLogKey;
extern NSString * const kIVCNetworkStatusKey;

UIKIT_EXTERN NSNotificationName const IVGetOptimizeGatewayNotification;   //获取最优网关成功通知
UIKIT_EXTERN NSNotificationName const IVGetOptimizeGCNotification;         //获取最优GC成功通知
UIKIT_EXTERN NSNotificationName const IVGetOptimizeDomainNotification;     //获取最优手机站成功通知
UIKIT_EXTERN NSNotificationName const IVNetworkStatusChangedNotification;  //网络状态发生改变通知

typedef void (^IVCheckProgressBlock)(IVCheckDetailModel *respone);
typedef void (^IVCheckCompletionBlock)(IVCheckDetailModel *model);

@interface IVCheckNetworkWrapper : NSObject

/**
 从一组地址中获取响应速度最快的地址
 异步
 @param array 地址数组
 @param isAuto 是否为自动检测，自动检测不会记录日志
 @param type 检测的类型
 @param progress 进度详情
 @param completion 完成回调,model:最快的地址model
 */
+ (void)getOptimizeUrlWithArray:(NSArray<NSString *> *)array
                         isAuto:(BOOL)isAuto
                           type:(IVKCheckNetworkType)type
                       progress:(nullable void (^)(IVCheckDetailModel *respone))progress
                     completion:(nullable void (^)(IVCheckDetailModel *model))completion;
/**
 从一组地址中获取响应速度最快的地址
 同步
 @param array 地址数组
 @param isAuto 是否为自动检测，自动检测不会记录日志
 @param type 检测的类型
 @param progress 进度详情
 @param completion 完成回调,model:最快的地址model
 */
+ (void)getOptimizeUrlSynWithArray:(NSArray<NSString *> *)array isAuto:(BOOL)isAuto type:(IVKCheckNetworkType)type progress:(nullable void (^)(IVCheckDetailModel *respone))progress completion:(nullable void (^)(IVCheckDetailModel *model))completion;
/**
 检测某个网址的速度

 @param url 网址
 @param isAuto 是否为自动检测，自动检测不会记录日志
 @param type 检测的类型
 @param completion 完成回调,time耗时
 */
+ (void)startCheckWithUrl:(NSString *)url
                   isAuto:(BOOL)isAuto
                     type:(IVKCheckNetworkType)type
               completion:(nullable void (^)(NSTimeInterval time))completion;

/**
 检查三方域名，如百度，主要是判定设备网络是否正常

 */
+ (void)checkTripartiteDomainWithCompletion:(void(^)(void))completion;
/**
 开始ping网关

 */
+ (void)startPingGatewayWithCompletion:(void(^)(void))completion;
/**
 开始网关socket连接

 */
+ (void)startConnectGatewaySocketWithCompletion:(void(^)(void))completion;
/**
 开始网关nginx检测

 */
+ (void)startHttpRequestGatewayWithCompletion:(void(^)(void))completion;
/**
 开始网关domain status检测

 */
+ (void)startCheckGatewayStatusWithCompletion:(void(^)(void))completion;
/**
 向天网发送日志

 */
+ (void)sendCheckLog;
/**
 安全处理
 将url进行模糊处理
 @param url 网址
 */
+ (NSString *)replaceSecurityUrl:(NSString *)url;

/**
 将日志写入本地

 @param log log
 @param isAuto 是否为自动检测，自动检测不会记录日志
 */
+ (void)writeCheckLog:(NSString *)log isAuto:(BOOL)isAuto;
+ (void)setPrintLogBlock:(void (^)(NSString *log))printLogBlock;
@end

NS_ASSUME_NONNULL_END
