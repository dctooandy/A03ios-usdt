//
//  IVHttpManager.m
//  IVNetworkLibrary2.0
//
//  Created by Key on 13/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//


#import "IVHttpManager.h"
#import "IVCacheWrapper.h"
#import "IVNUtility.h"
@interface IVHttpManager ()
/**
 没有验证的网关列表
 */
@property (nonatomic, strong) NSMutableArray *currentGateways;


@end
@implementation IVHttpManager
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static IVHttpManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[IVHttpManager alloc] init];
    });
    return _manager;
}
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field{
    [[KYHTTPManager manager] setValue:value forHTTPHeaderField:field];
}
- (NSMutableArray *)currentGateways
{
    if (!_currentGateways) {
        _currentGateways = self.gateways.mutableCopy;
    }
    return _currentGateways;
}
- (void)setDomain:(NSString *)domain
{
    _domain = domain;
    [IVCacheWrapper setObject:domain forKey:IVCacheH5DomainKey];
}
- (void)setCdn:(NSString *)cdn
{
    _cdn = cdn;
    [IVCacheWrapper setObject:cdn forKey:IVCacheCDNKey];
}
- (void)setGateway:(NSString *)gateway
{
    _gateway = gateway;
    [IVCacheWrapper setObject:gateway forKey:IVCacheGatewayKey];
}
- (void)setGameDomain:(NSString *)gameDomain
{
    _gameDomain = gameDomain;
    [IVCacheWrapper setObject:gameDomain forKey:IVCacheGameDomainKey];
}
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                       callBack:(nullable KYHTTPCallBack)callBack
{
    return
    [self sendRequestWithMethod:method
                          url:url
                   parameters:@{}
                     progress:nil
                        cache:NO
                 cacheTimeout:0
                 denyRepeated:NO
                     callBack:nil
               originCallBack:callBack
     ];
}

- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                     parameters:(id)parameters
                       callBack:(nullable KYHTTPCallBack)callBack
{
    return
    [self sendRequestWithMethod:method
                          url:url
                   parameters:parameters
                     progress:nil
                        cache:NO
                 cacheTimeout:0
                 denyRepeated:NO
                     callBack:nil
               originCallBack:callBack
     ];
}
- (NSURLSessionTask *)sendRequestWithUrl:(NSString *)url
                                 parameters:(id)parameters
                                   callBack:(nullable KYHTTPCallBack)callBack
{
    return
    [self sendRequestWithMethod:KYHTTPMethodPOST
                            url:url
                     parameters:parameters
                       progress:nil
                          cache:NO
                   cacheTimeout:0
                   denyRepeated:NO
                       callBack:nil
                 originCallBack:callBack
     ];
}
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                     parameters:(id)parameters
                   denyRepeated:(BOOL)denyRepeated
                       callBack:(nullable KYHTTPCallBack)callBack
{
    return
    [self sendRequestWithMethod:method
                          url:url
                   parameters:parameters
                     progress:nil
                        cache:NO
                 cacheTimeout:0
                 denyRepeated:denyRepeated
                     callBack:nil
               originCallBack:callBack
     ];
}

- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                     parameters:(id)parameters
                          cache:(BOOL)cache
                   cacheTimeout:(NSTimeInterval)cacheTimeout
                       callBack:(nullable KYHTTPUseCacheCallBack)callBack
                 originCallBack:(nullable KYHTTPCallBack)originCallBack
{
    return
    [self sendRequestWithMethod:method
                          url:url
                   parameters:parameters
                     progress:nil
                        cache:cache
                 cacheTimeout:cacheTimeout
                 denyRepeated:NO
                     callBack:callBack
               originCallBack:originCallBack
     ];
}

- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                            url:(NSString *)url
                     parameters:(id)parameters cache:(BOOL)cache
                   cacheTimeout:(NSTimeInterval)cacheTimeout
                   denyRepeated:(BOOL)denyRepeated
                       callBack:(KYHTTPUseCacheCallBack)callBack
                 originCallBack:(KYHTTPCallBack)originCallBack
{
    return
    [self sendRequestWithMethod:method
                          url:url
                   parameters:parameters
                     progress:nil
                        cache:cache
                 cacheTimeout:cacheTimeout
                 denyRepeated:denyRepeated
                     callBack:callBack
               originCallBack:originCallBack
     ];
}
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                                      url:(NSString *)url
                               parameters:(id)parameters
                                 progress:(nullable void (^)(NSProgress *))progress
                                    cache:(BOOL)cache
                             cacheTimeout:(NSTimeInterval)cacheTimeout
                             denyRepeated:(BOOL)denyRepeated
                                 callBack:(nullable KYHTTPUseCacheCallBack)callBack
                           originCallBack:(nullable KYHTTPCallBack)originCallBack
{
    return [self sendRequestWithMethod:method
                               url:url
                        parameters:parameters
                           headers:nil
                          progress:progress
                             cache:cache
                      cacheTimeout:cacheTimeout
                      denyRepeated:denyRepeated
                          callBack:callBack
                    originCallBack:originCallBack
          ];
}
- (NSURLSessionTask *)sendRequestWithMethod:(KYHTTPMethod)method
                        url:(NSString *)url
                 parameters:(id)parameters
                    headers:(nullable NSDictionary *)headers
                   progress:(nullable void (^)(NSProgress *))progress
                      cache:(BOOL)cache
               cacheTimeout:(NSTimeInterval)cacheTimeout
               denyRepeated:(BOOL)denyRepeated
                   callBack:(nullable KYHTTPUseCacheCallBack)callBack
             originCallBack:(nullable KYHTTPCallBack)originCallBack
{
    IVHTTPBaseRequest *request = nil;
    if (self.requestClass) {
        request = [[self.requestClass alloc] init];
    } else {
        request = [IVHTTPBaseRequest manager];
    }
    request.appId = self.appId;
    request.token = self.userToken;
    request.loginName = self.loginName;
    request.environment = self.environment;
    request.productId = self.productId;
    request.productCode = self.productCode;
    request.parentId = self.parentId;
    request.method = method;
    NSMutableDictionary *mHeaders = headers ? headers.mutableCopy : @{}.mutableCopy;
    if (self.globalHeaders && [self.globalHeaders isKindOfClass:[NSDictionary class]]) {
        [mHeaders setValuesForKeysWithDictionary:self.globalHeaders];
    }
    request.extendedHeaders = mHeaders.copy;
    request.gateway = self.gateway ? : [self getRandomObject:self.gateways];
    __block NSURLSessionTask * task =
    [request sendRequestWithUrl:url
                     parameters:parameters
                       progress:progress
                          cache:cache
                   cacheTimeout:cacheTimeout
                   denyRepeated:denyRepeated
                       callBack:callBack
                 originCallBack:^(id  _Nullable response, NSError * _Nullable error) {
                     if (error) {
                         //如果是检测网关或者域名接口失败，则不切换网关
                         if ([url isEqualToString:@"version.txt"]) {
                             return;
                         }
                         //其他请求失败，需要切换网关
                         NSString *currentGateway = task.currentRequest.URL.host;
                         for (NSString *gateway in self.gateways) {
                             //如果请求的host在网关列表中，且与当前缓存的网关相同，则开始切换
                             if (currentGateway && [gateway containsString:currentGateway] &&
                                 [request.gateway containsString:currentGateway]) {
                                 [self switchGatewayWithCurrentGatewayUrl:task.currentRequest.URL];
                                 break;
                             }
                         }
                         IVNLog(@"\n地址:%@%@\n错误信息:%@",request.baseURL,url,error);
                     }
                     if (originCallBack) {
                         originCallBack(response, error);
                     }

                 }

     ];
    return task;
}

- (id)getRandomObject:(NSArray *)array
{
    return [array objectAtIndex:(arc4random() % array.count)];
}

- (void)cancelTastWithUrl:(NSString *)url
{
    [IVHTTPBaseRequest cancelTastWithUrl:url];
}
- (void)switchGatewayWithCurrentGatewayUrl:(NSURL *)currentGatewayUrl
{
    NSArray *tempArray = self.gateways.copy;
    for (NSString *gateway in tempArray) {
        NSURL *gatewayURL = [NSURL URLWithString:gateway];
        if ([gatewayURL.host isEqualToString:currentGatewayUrl.host] &&
            [self.gateways containsObject:gateway]) {
            [self.currentGateways removeObject:gateway];
        }
    }
    if (self.currentGateways.count <= 0) {
        self.currentGateways = self.gateways.mutableCopy;
    }
    int index = arc4random() % self.currentGateways.count;
    self.gateway = self.currentGateways[index];
    
    //通知外部
    NSMutableDictionary *eventDict = @{}.mutableCopy;
    [eventDict setValue:currentGatewayUrl.absoluteString forKey:@"from"];
    [eventDict setValue:self.currentGateways[index] forKey:@"to"];
    [[NSNotificationCenter defaultCenter] postNotificationName:IVNGatewaySwitchNotification object:nil userInfo:eventDict.copy];
}

@end
