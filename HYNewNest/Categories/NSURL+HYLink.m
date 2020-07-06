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
//        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Config_DefaultCDNAdress,strUrl]];
    }
    
    return url;
}

+ (NSString *)getStrUrlWithString:(NSString *)strUrl{
    
    if (strUrl.length == 0) {
        return @"";
    }
    
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    if (![strUrl hasPrefix:@"http"]) {
//        strUrl = [NSString stringWithFormat:@"%@%@",Config_DefaultCDNAdress,strUrl];
    }
    
    return strUrl;
}

+ (NSString *)getH5StrUrlWithString:(NSString *)strUrl ticket:(NSString *)ticket{
    
    if (strUrl.length == 0) {
        return @"";
    }
    
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    if (![strUrl hasPrefix:@"http"]) {
//        strUrl = [NSString stringWithFormat:@"%@%@",Confit_H5Adress,strUrl];
    }
    
    if ([strUrl containsString:@"?"]) {
//        strUrl = [NSString stringWithFormat:@"%@&appid=%@",strUrl,config_appId];
    }else{
//        strUrl = [NSString stringWithFormat:@"%@?appid=%@",strUrl,config_appId];
    }
    
//    if ([ManageDataModel shareManage].getLoginUserModel) {
//        strUrl = [NSString stringWithFormat:@"%@&loginName=%@",strUrl,[ManageDataModel shareManage].getLoginUserModel.loginName];
//    }
    
    if (ticket.length > 0) {
        strUrl = [NSString stringWithFormat:@"%@&ticket=%@",strUrl,ticket];
    }
    //dark light
//    if (ThemeType == 0) {
//        strUrl = [NSString stringWithFormat:@"%@&theme=dark",strUrl];
//    }else{
//        strUrl = [NSString stringWithFormat:@"%@&theme=light",strUrl];
//    }
    
    return strUrl;
}

//风采
//+ (NSString *)getFCH5StrUrlWithID:(NSString *)ID{
//
//    if (ID.length == 0) {
//        return @"";
//    }
//    NSString *strUrl = [NSString stringWithFormat:@"%@/detailsPage?id=%@&appid=%@",Confit_H5Adress,ID,config_appId];
//    //dark light
//    if (ThemeType == 0) {
//        strUrl = [NSString stringWithFormat:@"%@&theme=dark",strUrl];
//    }else{
//        strUrl = [NSString stringWithFormat:@"%@&theme=light",strUrl];
//    }
//    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    return strUrl;
//}

@end
