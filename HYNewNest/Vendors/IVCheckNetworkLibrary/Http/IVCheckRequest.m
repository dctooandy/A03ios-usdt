//
//  IVCheckHttpManager.m
//  IVCheckNetworkLibrary
//
//  Created by Key on 25/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "IVCheckRequest.h"

@implementation IVCheckRequest
- (KYRequestSerializerType)requestSerializerType
{
    return KYRequestSerializerTypeHTTP;
}
- (KYResponseSerializerType)responseSerializerType
{
    return KYResponseSerializerTypeHTTP;
}
- (KYHTTPMethod)method
{
    return KYHTTPMethodGET;
}
- (NSString *)baseURL
{
    return self.url;
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
    id params = parameters;
    return params;
}
- (id)analysisObjectFromResponse:(id)response url:(NSString *)url
{
    NSString *resultStr = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    return resultStr;
}

- (BOOL)cacheKeyContainsBaseUrl
{
    return NO;
}
- (NSURLSessionTask *)sendRequestWithUrl:(NSString *)url callBack:(KYHTTPCallBack)callBack
{
    return [super sendRequestWithUrl:url callBack:^(id  _Nullable response, NSError * _Nullable error)
                {
#if DEBUG
//                    NSLog(@"%@,结果:\n%@",url,response);
#endif
                    if (callBack) {
                        callBack(response, error);
                    }
                }
           ];
}

@end
