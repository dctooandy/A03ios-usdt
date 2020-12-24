//
//  IVHttpManager.h
//  IVNetworkLibrary2.0
//
//  Created by Key on 13/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVHTTPBaseRequest.h"
#import "IVNConstant.h"
NS_ASSUME_NONNULL_BEGIN

@interface IVHttpManager : NSObject

/**
 运行环境
 */
@property (nonatomic, assign) IVNEnvironment environment;

/**
 appid
 */
@property (nonatomic, copy) NSString *appId;
/**
所有网关列表
 */
@property (nonatomic, copy, nullable) NSArray *gateways;
/**
 当前网关
 */
@property (nonatomic, copy, nullable) NSString *gateway;

/**
 手机站域名列表
 */
@property (nonatomic, copy, nullable) NSArray *domains;
/**
 当前手机站域名
 */
@property (nonatomic, copy, nullable) NSString *domain;
/**
 当前cdn
 */
@property (nonatomic, copy, nullable) NSString *cdn;
/**
 当前游戏站
 */
@property (nonatomic, copy, nullable) NSString *gameDomain;
/**
 用户登录后获取的token
 */
@property (nonatomic, copy, nullable) NSString *userToken;
/**
 用户名
 */
@property (nonatomic, copy, nullable) NSString *loginName;;
/**
 产品标识
 */
@property (nonatomic, copy) NSString *productId;
/**
 产品标识
 */
@property (nonatomic, copy) NSString *productCode;
/**
 渠道标识
 */
@property (nonatomic, copy) NSString *parentId;

/**
 全局扩展header，所有请求都会添加
 如果原header中存在已有字段，使用globalHeaders中的值
 会替换IVHTTPBaseRequest的extendedHeaders中的值
 */
@property (nonatomic, copy) NSDictionary *globalHeaders;

/**
 默认为IVHttpBaseRequest，可以新建，但是必须继承IVHttpBaseRequest
 */
@property (nonatomic, strong) Class requestClass;

+ (instancetype)shareManager;

/**
 发送请求,可扩展Header,有进度,可使用缓存,可设置禁止重复请求
 @param method method 默认get
 @param url path
 @param parameters 参数
 @param progress 进度
 @param cache 是否使用缓存
 @param cacheTimeout 缓存超时时间
 @param denyRepeated 是否禁止重复请求
 @param callBack 如果使用缓存且缓存存在，则回调中isCache为真，此时数据来自缓存，否则为假，数据来自远程
 @param originCallBack 数据来自远程服务端的回调
 */
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                                      url:(NSString *)url
                               parameters:(nullable id)parameters
                                  headers:(nullable NSDictionary *)headers
                                 progress:(nullable void (^)(NSProgress *))progress
                                    cache:(BOOL)cache
                             cacheTimeout:(NSTimeInterval)cacheTimeout
                             denyRepeated:(BOOL)denyRepeated
                                 callBack:(nullable KYHTTPUseCacheCallBack)callBack
                           originCallBack:(nullable KYHTTPCallBack)originCallBack;

/**
 发送请求,有进度,可使用缓存,可设置禁止重复请求
 @param method method 默认get
 @param url path
 @param parameters 参数
 @param progress 进度
 @param cache 是否使用缓存
 @param cacheTimeout 缓存超时时间
 @param denyRepeated 是否禁止重复请求
 @param callBack 如果使用缓存且缓存存在，则回调中isCache为真，此时数据来自缓存，否则为假，数据来自远程
 @param originCallBack 数据来自远程服务端的回调
 */
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                        url:(NSString *)url
                parameters:(nullable id)parameters
                  progress:(nullable void (^)(NSProgress *))progress
                     cache:(BOOL)cache
              cacheTimeout:(NSTimeInterval)cacheTimeout
              denyRepeated:(BOOL)denyRepeated
                  callBack:(nullable KYHTTPUseCacheCallBack)callBack
            originCallBack:(nullable KYHTTPCallBack)originCallBack;

/**
 发送请求,，不传参数，不做其他操作
 @param method method 默认get
 @param url path
 @param callBack 回调
 */
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                       callBack:(nullable KYHTTPCallBack)callBack;

/**
 发送请求,只传参数,不做其他操作
 @param method method 默认get
 @param url path
 @param parameters 参数
 @param callBack 回调
 */
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                     parameters:(nullable id)parameters
                       callBack:(nullable KYHTTPCallBack)callBack;
/**
 发送请求,POST,只传参数,不做其他操作
 @param url path
 @param parameters 参数
 @param callBack 回调
 */
- (NSURLSessionTask *)sendRequestWithUrl:(NSString *)url
                                 parameters:(nullable id)parameters
                                   callBack:(nullable KYHTTPCallBack)callBack;

/**
 发送请求,可禁止重复请求,不做其他操作
 @param method method 默认get
 @param url path
 @param parameters 参数
 @param denyRepeated YES禁止，NO不禁止
 @param callBack 回调
 */
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                     parameters:(nullable id)parameters
                   denyRepeated:(BOOL)denyRepeated
                       callBack:(nullable KYHTTPCallBack)callBack;

/**
 发送请求,可以使用缓存,不做其他操作
 @param method method 默认get
 @param url path
 @param parameters 参数
 @param cache 是否使用缓存
 @param cacheTimeout 缓存超时时间
 @param callBack 如果使用缓存且缓存存在，则回调中isCache为真，此时数据来自缓存，否则为假，数据来自远程
 @param originCallBack 数据来自远程服务端的回调
 */
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                     parameters:(nullable id)parameters
                     cache:(BOOL)cache
                   cacheTimeout:(NSTimeInterval)cacheTimeout
                       callBack:(nullable KYHTTPUseCacheCallBack)callBack
                 originCallBack:(nullable KYHTTPCallBack)originCallBack;
/**
 发送请求,可以使用缓存,可禁止重复请求
 @param method method 默认get
 @param url path
 @param parameters 参数
 @param cache 是否使用缓存
 @param cacheTimeout 缓存超时时间
 @param denyRepeated YES禁止，NO不禁止
 @param callBack 如果使用缓存且缓存存在，则回调中isCache为真，此时数据来自缓存，否则为假，数据来自远程
 @param originCallBack 数据来自远程服务端的回调
 */
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                     parameters:(nullable id)parameters cache:(BOOL)cache
                   cacheTimeout:(NSTimeInterval)cacheTimeout
                   denyRepeated:(BOOL)denyRepeated
                       callBack:(KYHTTPUseCacheCallBack)callBack
                 originCallBack:(KYHTTPCallBack)originCallBack;

/**
 取消正在执行的请求
 
 @param url path
 */
- (void)cancelTastWithUrl:(NSString *)url;


@end

NS_ASSUME_NONNULL_END
