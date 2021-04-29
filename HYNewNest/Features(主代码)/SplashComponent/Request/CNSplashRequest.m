//
//  CNSplashRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/21.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNSplashRequest.h"
#import "UpdateVersionModel.h"
#import "FCUUID.h"
#import "HYUpdateAlertView.h"
#import "AppDelegate.h"
#import "NXPingManager.h"

@implementation CNSplashRequest

+ (void)queryNewVersion:(void(^)(BOOL isHardUpdate))handler {
    [self POST:kGatewayPath(config_upgradeApp) parameters:[kNetworkMgr baseParam] completionHandler:^(id responseObj, NSString *errorMsg) {
        
        UpdateVersionModel *updateVersion = [UpdateVersionModel cn_parse:responseObj];
        if ([updateVersion.flag integerValue] == 0 || updateVersion.appDownUrl.length < 1) {
            // 不更新 或 没有配置下载链接
            handler(NO);
            
        } else {
            // ping 域名获取最快的
            NSArray *domains = updateVersion.domains;
            [NXPingManager pingFastestHost:domains progress:^(CGFloat progress) {

            } handler:^(NSString * _Nonnull host) {
                if (!KIsEmptyString(host)) {
                    [self downloadWithModel:updateVersion fastHost:host handler:handler];
                } else {
                    [self downloadWithModel:updateVersion fastHost:nil handler:handler];
                }
            }];
        }
    }];
}

+ (void)downloadWithModel:(UpdateVersionModel *)updateVersion fastHost:(nullable NSString *)host handler:(void(^)(BOOL isHardUpdate))handler{
    NSString *content = updateVersion.upgradeDesc[@"des"] ?: updateVersion.versionCode;
    NSString *downURLStr = updateVersion.appDownUrl; // 原下载链接
    NSURL *downURL = [NSURL URLWithString:downURLStr];
    if (host) {
        NSString *orgHost = downURL.host; // 原host
        NSString *path = [downURLStr componentsSeparatedByString:orgHost].lastObject;
        downURLStr = host ? [host stringByAppendingString:path] : updateVersion.appDownUrl; // 如果host有值则替换掉host并拼接
        downURL = [NSURL URLWithString:downURLStr];
    }
    
    if ([updateVersion.flag integerValue] == 1) {
        [HYUpdateAlertView showWithVersionString:content isForceUpdate:NO handler:^(BOOL isComfirm) {
            if (isComfirm && [[UIApplication sharedApplication] canOpenURL:downURL]) {
                [[UIApplication sharedApplication] openURL:downURL options:@{} completionHandler:^(BOOL success) {
                    [CNHUB showSuccess:@"正在为您打开下载链接.."];
                }];
            }
            // 弱更 不管怎样都往下走
            handler(NO);
        }];
        
    }else if([updateVersion.flag integerValue ] == 2){
        
        // 手动校验版本号
        NSString *curV = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSArray *curVArr = [curV componentsSeparatedByString:@"."];
        NSArray *newVArr = [updateVersion.versionCode componentsSeparatedByString:@"."];
        for (int i=0; i<newVArr.count; i++) {
            if (i != 2 && [newVArr[i] intValue] > [curVArr[i] intValue]) {
                break; // 前面版本大，升级
            }
            if (i == 2 && [newVArr[i] intValue] <= [curVArr[i] intValue]) {
                handler(NO);
                return; // 不升级
            }
        }
        
        [HYUpdateAlertView showWithVersionString:content isForceUpdate:YES handler:^(BOOL isComfirm) {
            if (isComfirm && [[UIApplication sharedApplication] canOpenURL:downURL]) {
                [[UIApplication sharedApplication] openURL:downURL options:@{} completionHandler:^(BOOL success) {
                    [CNHUB showSuccess:@"正在为您打开下载链接.."];
                    handler(YES);
                }];
            } else {
                [self exitAapplication];
            }
        }];
        
    }
}

+ (void)welcome:(HandlerBlock)handler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:[[UIDevice currentDevice]systemVersion] forKey:@"deviceSystemVersion"];
    [paramDic setObject:[UIDevice jk_deviceModel] forKey:@"deviceModel"];
    [paramDic setObject:@"iOS" forKey:@"deviceType"];
    [paramDic setObject:@"Apple" forKey:@"deviceBrand"];
    
    [self POST:kGatewayPath(config_welcome) parameters:paramDic completionHandler:handler];
}

+ (void)queryCDNH5Domain:(HandlerBlock)handler {
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:@"APP_ADDRESS_MANAGER" forKey:@"bizCode"];
    [self POST:kGatewayPath(config_dynamicQuery) parameters:paramDic completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            handler([responseObj[@"data"] firstObject], errorMsg);
        }
    }];
}

+ (void)checkAreaLimit:(void(^)(BOOL isAllowEntry))handler {
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"deviceId"] = [FCUUID uuidForDevice];
    [self POST:kGatewayPath(config_areaLimit) parameters:paramDic completionHandler:^(id responseObj, NSString *errorMsg) {
        handler([responseObj boolValue]);
    }];
}

+ (void)exitAapplication {
    UIWindow *window = (UIWindow *)kAppDelegate.window;
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

@end
