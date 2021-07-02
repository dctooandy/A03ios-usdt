//
//  NSURL+HYLink.m
//  HYGEntire
//
//  Created by zaky on 24/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "NSURL+HYLink.h"



@implementation NSURL (HYLink)

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
    
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    if (![strUrl hasPrefix:@"http"]) {
        if (needPubSite && ![strUrl containsString:@"pub_site"]) {
            strUrl = [NSString stringWithFormat:@"%@/pub_site%@",[IVHttpManager shareManager].domain,strUrl];
        } else {
            if (![strUrl hasPrefix:@"/"]) {
                strUrl = [NSString stringWithFormat:@"/%@", strUrl];
            }
            strUrl = [NSString stringWithFormat:@"%@%@",[IVHttpManager shareManager].domain,strUrl];
        }
    }
    
    if ([strUrl containsString:@"?"]) {
        strUrl = [NSString stringWithFormat:@"%@&appid=A03DS02",strUrl];
    }else{
        strUrl = [NSString stringWithFormat:@"%@?appid=A03DS02",strUrl];
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
