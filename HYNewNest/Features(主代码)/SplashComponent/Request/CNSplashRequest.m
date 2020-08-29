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

@implementation CNSplashRequest

+ (void)queryNewVersion:(void(^)(BOOL isHardUpdate))handler {
    [self POST:kGatewayPath(config_upgradeApp) parameters:[kNetworkMgr baseParam] completionHandler:^(id responseObj, NSString *errorMsg) {
        
        UpdateVersionModel *updateVersion = [UpdateVersionModel cn_parse:responseObj];
        __block NSURL *downURL = [NSURL URLWithString:updateVersion.appDownUrl];

        
        if ([updateVersion.flag integerValue] == 0 || updateVersion.appDownUrl.length < 1) {
            // 不更新 或 没有配置下载链接
            handler(NO);
           return;
        }
        
        if([updateVersion.flag integerValue] >= 1){
            
            NSString *title = @"";
            NSString *content = updateVersion.upgradeDesc[@"des"] ?: @"";
            NSString *cancelTitle = @"";
            NSString *suretitle = @"";
            if ([updateVersion.flag integerValue] == 1) {
                title = [NSString stringWithFormat:@"检测到新版本 V%@",updateVersion.versionCode] ;
                cancelTitle = @"暂不更新";
                suretitle= @"更新";
                
                [HYUpdateAlertView showWithVersionString:updateVersion.versionCode isForceUpdate:NO handler:^(BOOL isComfirm) {
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
                
                title = [NSString stringWithFormat:@"⚠️请更新到新版本 V%@",updateVersion.versionCode];
                cancelTitle = @"退出应用";
                suretitle= @"强制更新";
                [HYUpdateAlertView showWithVersionString:updateVersion.versionCode isForceUpdate:YES handler:^(BOOL isComfirm) {
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
    }];
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
    UIWindow *window = kAppDelegate.window;
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

@end
