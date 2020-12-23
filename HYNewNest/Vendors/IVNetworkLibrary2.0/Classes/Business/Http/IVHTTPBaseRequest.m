//
//  IVBaseRequest.m
//  IVNetworkLibrary2.0
//
//  Created by Key on 14/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "IVHTTPBaseRequest.h"
#import "SignCore/SignUtil.h"
#import "IVNConstant.h"
#import "IVNUtility.h"


@interface IVHTTPBaseRequest ()

@end
@implementation IVHTTPBaseRequest


- (NSString *)baseURL
{
    return self.gateway;
}
- (NSString *)qid
{
    if (!_qid) {
        _qid = [self createQid];
    }
    return _qid;
}

- (KYRequestSerializerType)requestSerializerType
{
    return KYRequestSerializerTypeJSON;
}
- (KYResponseSerializerType)responseSerializerType
{
    return KYResponseSerializerTypeHTTP;
}
- (NSTimeInterval)requestTimeout
{
    return 20.0;
}
- (BOOL)allowInvalidCertificates
{
    return NO;
}
- (BOOL)validatesDomainName
{
    return YES;
}

- (id)extendedParameters:(id)parameters url:(nonnull NSString *)url
{
    NSMutableDictionary *mParams = parameters ? ((NSDictionary *)parameters).mutableCopy : @{}.mutableCopy;
    
    mParams[@"productId"] = self.productId;
//    mParams[@"productCode"] = self.productCode;
    NSString *loginName = mParams[@"loginName"];
    //如果参数中有loginName(如登录注册等)，则使用参数中的，否则使用内存中的
    if (!loginName || ![loginName isKindOfClass:[NSString class]]) {
        mParams[@"loginName"] = self.loginName;
    }
    //参数签名
    NSString *bodyJsonStr = [mParams IVNToJSONString];
    bodyJsonStr = [bodyJsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    bodyJsonStr = [bodyJsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *token = self.token ? : @"";
    NSURL *gatewayUrl = [NSURL URLWithString:self.gateway];
//    NSString *domainName = [NSString stringWithFormat:@"%@://%@",gatewayUrl.scheme,gatewayUrl.host];
    NSString *domainName = [NSString stringWithFormat:@"%@", gatewayUrl.host]; //A03不带scheme头部
    NSString *version = [UIDevice appVersion];
    NSString *deviceId = [UIDevice uuidForDevice];
    if (self.extendedHeaders) {
        if ([self.extendedHeaders valueForKey:@"domainName"]) {
            domainName = [self.extendedHeaders valueForKey:@"domainName"];
        }
        if ([self.extendedHeaders valueForKey:@"v"]) {
            version = [self.extendedHeaders valueForKey:@"v"];
        }
        if ([self.extendedHeaders valueForKey:@"deviceId"]) {
            deviceId = [self.extendedHeaders valueForKey:@"deviceId"];
        }
    }
    
    NSString *parentId = self.parentId ? : @"";
    NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",bodyJsonStr,self.qid,self.appId,version,domainName,token,parentId,deviceId];
    NSMutableArray *array = @[].mutableCopy;
    for (int i = 0; i < signStr.length; i++) {
        NSString *str = [signStr substringWithRange:NSMakeRange(i, 1)];
        [array addObject:str];
    }
    [array sortUsingSelector:@selector(compare:)];
    signStr = [array componentsJoinedByString:@""];
    NSString *keyEnum = @"0";
//    switch (self.environment) {
//        case IVNEnvironmentDevelop:
//            keyEnum = @"1";
//            break;
//        default:
//            keyEnum = @"0";
//            break;
//    }
    NSString *signResultStr = [SignUtil getSign:signStr qid:self.qid keyEnum:keyEnum];
    
    //header处理
    NSMutableDictionary *headers = @{}.mutableCopy;
    headers[@"qid"] = self.qid;
    headers[@"appId"] = self.appId;
    headers[@"v"] = version;
    headers[@"domainName"] = domainName;
    headers[@"token"] = token;
    headers[@"parentId"] = parentId;
    headers[@"deviceId"] = deviceId;
    headers[@"Content-Type"] = @"application/json";
    headers[@"sign"] = signResultStr;
    if (self.extendedHeaders) {
        [headers setValuesForKeysWithDictionary:self.extendedHeaders];
    }
    for (NSString *key in headers.allKeys) {
        [self setValue:headers[key] forHTTPHeaderField:key];
    }
    
    
//    IVNLog(@"\n开始请求，地址:%@%@\n请求header:\n%@\n参数:\n%@\n",self.baseURL,url,headers,mParams);
    _parameters = mParams.copy;
    return _parameters;
}

- (NSString*)createQid {
    //随机数从这里边产生
//    NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s", nil];
//    NSString *timeStr = [NSString stringWithFormat:@"%.0lf",[[NSDate date] timeIntervalSince1970] * 1000];
//    NSString *qid = @"";
//    for (int i = 0; i < timeStr.length; i++) {
//        int t = arc4random()%startArray.count;
//        NSString *randomStr = startArray[t];
//        qid = [NSString stringWithFormat:@"%@%@%@",qid,[timeStr substringWithRange:NSMakeRange(i, 1)],randomStr];
//    }
//    return qid;
    
    // A03旧环亚 随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", @"a",@"b",@"c",@"d",@"e",@"f", nil];
    //随机数产生结果
    NSString *resultStr = @"";
    NSInteger m=32;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultStr = [resultStr stringByAppendingString:startArray[t]];
    }
    return resultStr;
}

- (BOOL)shouldSaveResponseToCache:(id)response
{
    if ([response isKindOfClass:[IVJResponseObject class]]) {
        IVJResponseObject *obj = (IVJResponseObject *)response;
        if (obj.body) {
            return YES;
        }
    }
    return NO;
}
- (id)analysisObjectFromResponse:(id)response url:(NSString *)url
{
    IVJResponseObject *obj = [[IVJResponseObject alloc] init];
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        result = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        IVNLog(@"\n地址:%@%@\n结果:%@",self.baseURL,url,result);
        IVNLog(@"\n地址:%@%@\n错误信息:%@",self.baseURL,url,error);
        obj.head.errMsg = [NSString stringWithFormat:@"数据解析失败"];
        obj.head.errCode = [@(error.code) stringValue];
        return obj;
    }
    if (result && [result isKindOfClass:[NSDictionary class]]) {
        obj.body = [result valueForKey:@"body"];
        obj.head = [[IVJResponseHead alloc] initWithDictionary:[result valueForKey:@"head"] error:&error];
        if (error) {
            obj.head.errMsg = error.description;
            obj.head.errCode = [@(error.code) stringValue];
            return obj;
        }
    } else {
        obj.head.errMsg = [NSString stringWithFormat:@"数据解析失败1"];
        obj.head.errCode = @"20000";
    }
    
    return obj;
}
- (NSString *)getCacheKeyWithUrl:(NSString *)url parameters:(id)parameters
{
    NSMutableDictionary *params = ((NSDictionary *)parameters).mutableCopy;
//    if ([url isEqualToString:@"user/login"]) {
//        params[@"timestamp"] = nil;
//    }
    return [super getCacheKeyWithUrl:url parameters:params.copy];
}
- (BOOL)cacheKeyContainsBaseUrl
{
    return NO;
}
- (NSURLSessionTask *)sendRequestWithUrl:(NSString *)url
                              parameters:(id)parameters
                                progress:(void (^)(NSProgress * _Nonnull))progress
                                   cache:(BOOL)cache
                            cacheTimeout:(NSTimeInterval)cacheTimeout
                            denyRepeated:(BOOL)denyRepeated
                                callBack:(KYHTTPUseCacheCallBack)callBack
                          originCallBack:(KYHTTPCallBack)originCallBack
{
    NSString *subUrl = url.length > 0 ? url.copy : @"";
    NSString *productId = [self.productId lowercaseString];
//    IVNLog(@"\n开始请求，地址:%@%@\n",self.baseURL,url);
    __weak typeof(self)weakSelf = self;
    __block NSURLSessionTask *task = nil;
    task = [super sendRequestWithUrl:subUrl
                          parameters:parameters
                            progress:progress
                               cache:cache
                        cacheTimeout:cacheTimeout
                        denyRepeated:denyRepeated
                            callBack:^(BOOL isCache, IVJResponseObject *  _Nullable response, NSError * _Nullable error)
            {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                NSURLRequest *request = task.currentRequest;
//                IVNLog(@"\n请求完成，地址:%@%\n请求header:\n%@\n参数:\n%@\n",request.URL,request.allHTTPHeaderFields,strongSelf->_parameters);
            IVNLog(@"\n请求完成，地址:%@%\n\n参数:\n%@\n",request.URL,strongSelf->_parameters);
                if (error) {
                    response = [[IVJResponseObject alloc] init];
                    response.head.errMsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
                    response.head.errCode = [@(error.code) stringValue];
                }
                if (cache) {
                    if (isCache) {
//                        IVNLog(@"\n从缓存返回,地址:%@%@\n结果:%@\n",strongSelf.baseURL,url,response.body);
                    } else {
//                        IVNLog(@"\n无缓存，从远程返回,地址:%@%@\n head-errMsg:%@\n head-errCode:%@\n body:%@",strongSelf.baseURL,url,response.head.errMsg,response.head.errCode,response.body);
                    }
                    if (callBack) {
                        callBack(isCache, response, error);
                    }
                } else {
                    if (callBack) {
                        callBack(NO, response, error);
                    }
                }
            }
                      originCallBack:^(IVJResponseObject *  _Nullable response, NSError * _Nullable error)
            {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if (error) {
                    response = [[IVJResponseObject alloc] init];
                    response.head.errMsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
                    response.head.errCode = [@(error.code) stringValue];
                    IVNLog(@"\n请求失败,从远程返回,地址:%@%@\n head-errMsg:%@\n head-errCode:%@\n body:%@",strongSelf.baseURL,url,response.head.errMsg,response.head.errCode,response.body);
                } else {
                    NSDictionary *dict = @{
                                           @"GW_890206" : @"",
                                           @"GW_890209" : @"",
                                           @"GW_880103" : @"",
                                           @"GW_890203" : @"",
                                           @"GW_899998" : @"",
                                           };
                    if (response.head.errCode && [dict valueForKey:response.head.errCode] != nil) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:IVNUserTokenExpiredNotification object:nil];
                    }
                    IVNLog(@"\n从远程返回,地址:%@%@\n head-errMsg:%@\n headR-errCode:%@\n body:%@",strongSelf.baseURL,url,response.head.errMsg,response.head.errCode,response.body);
                }
                if (originCallBack) {
                    originCallBack(response, error);
                }
            }];
    return task;
}
@end
