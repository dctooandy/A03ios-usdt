//
//  NSURL+HYLink.m
//  HYGEntire
//
//  Created by zaky on 24/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "NSURL+HYLink.h"



@implementation NSURL (HYLink)
+(NSURL *)getProfileIconWithString:(NSString *)strUrl {
    if (strUrl.length == 0) {
        return nil;
    }
    
    NSURL *url;
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    if ([strUrl hasPrefix:@"http"]) {
        url = [NSURL URLWithString:strUrl];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cdn/1e3c3bM/externals/img/_wms/icon/%@",[IVHttpManager shareManager].cdn,strUrl]];
    }
    
    return url;
}

+(NSURL *)getBankIconWithString:(NSString *)strUrl {
    if (strUrl.length == 0) {
        return nil;
    }
    
    NSURL *url;
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    if ([strUrl hasPrefix:@"http"]) {
        url = [NSURL URLWithString:strUrl];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cdn/1e3c3bM/externals/img/_wms/H5_new/%@",[IVHttpManager shareManager].cdn,strUrl]];
    }
    
    return url;
}
+ (NSURL *)getUrlWithString:(NSString *)strUrl{
    
    if (strUrl.length == 0) {
        return nil;
    }
    
    NSURL *url;
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    if ([strUrl hasPrefix:@"http"]) {
        url = [NSURL URLWithString:strUrl];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[IVHttpManager shareManager].cdn,strUrl]];
    }
    
    return url;
}

+ (NSString *)getStrUrlWithString:(NSString *)strUrl{
    
    if (strUrl.length == 0) {
        return @"";
    }
    
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    if (![strUrl hasPrefix:@"http"]) {
        strUrl = [NSString stringWithFormat:@"%@%@",[IVHttpManager shareManager].cdn,strUrl];
    }
    
    return strUrl;
}

+ (NSString *)getH5StrUrlWithString:(NSString *)strUrl ticket:(NSString *)ticket needPubSite:(BOOL)needPubSite{
    
    if (strUrl.length == 0) {
        return @"";
    }
    NSString * newDomainString = [IVHttpManager shareManager].domain;
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (newDomainString)
    {
        NSString *lastChar = [newDomainString substringFromIndex:[newDomainString length] - 1];
        if ([lastChar isEqualToString:@"/"])
        {
            newDomainString = [newDomainString substringToIndex:[newDomainString length] - 1];
        }
    }
    
    if (![strUrl hasPrefix:@"http"]) {
        if (needPubSite && ![strUrl containsString:@"pub_site"]) {
            strUrl = [NSString stringWithFormat:@"%@/pub_site%@",newDomainString,strUrl];
        } else {
            if (![strUrl hasPrefix:@"/"]) {
                strUrl = [NSString stringWithFormat:@"/%@", strUrl];
            }
            if ([strUrl containsString:@"/share"])
            {
                strUrl = [NSString stringWithFormat:@"%@/share",newDomainString];
            }else
            {
                strUrl = [NSString stringWithFormat:@"%@%@",newDomainString,strUrl];
            }
        }
    }
    
    if ([strUrl containsString:@"?"]) {
        //appid = A03DS02
        strUrl = [NSString stringWithFormat:@"%@&appid=A01NEWAPP02",strUrl];
    }else{
        strUrl = [NSString stringWithFormat:@"%@?appid=A01NEWAPP02",strUrl];
    }
    
    if ([CNUserManager shareManager].isLogin) {
        strUrl = [NSString stringWithFormat:@"%@&loginName=%@",strUrl,[CNUserManager shareManager].userInfo.loginName];
    }
    
    if (ticket.length > 0) {
        strUrl = [NSString stringWithFormat:@"%@&ticket=%@",strUrl,ticket];
    }
    //dark light
//    if ([CNSkinManager currSkinType] == SKinTypeBlack) {
//        strUrl = [NSString stringWithFormat:@"%@&theme=dark",strUrl];
//    }else{
//        strUrl = [NSString stringWithFormat:@"%@&theme=light",strUrl];
//    }
    
    return strUrl;
}

//风采
+ (NSString *)getFCH5StrUrlWithID:(NSString *)ID{

    if (ID.length == 0) {
        return @"";
    }
    NSString *strUrl = [NSString stringWithFormat:@"%@/detailsPage?id=%@&appid=%@",[IVHttpManager shareManager].domain, ID, [IVHttpManager shareManager].appId];
    //dark light
//    if ([CNSkinManager currSkinType] == SKinTypeBlack) {
//        strUrl = [NSString stringWithFormat:@"%@&theme=dark",strUrl];
//    }else{
//        strUrl = [NSString stringWithFormat:@"%@&theme=light",strUrl];
//    }
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return strUrl;
}

@end
