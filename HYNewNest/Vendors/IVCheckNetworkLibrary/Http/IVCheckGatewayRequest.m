//
//  IVCheckHttpManager.m
//  IVCheckNetworkLibrary
//
//  Created by Key on 25/06/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "IVCheckGatewayRequest.h"

@implementation IVCheckGatewayRequest

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
    IVJResponseObject *obj = [IVJResponseObject new];
    IVJResponseHead *head = [IVJResponseHead new];
    obj.head = head;
    if ((resultStr && [resultStr containsString:@"SUCCESS"])) {
        obj.body = @(YES);
        obj.head.errCode = @"0000";
        obj.head.errMsg = @"success";
    } else {
        obj.body = @(NO);
        obj.head.errCode = @"20000";
        obj.head.errMsg = @"fail";
    }
    
    return obj;
}

- (BOOL)cacheKeyContainsBaseUrl
{
    return NO;
}

@end
