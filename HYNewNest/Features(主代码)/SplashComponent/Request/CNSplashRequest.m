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

@implementation CNSplashRequest

+ (void)queryNewVersion:(void(^)(BOOL isHardUpdate))handler {
    [self POST:kGatewayPath(config_upgradeApp) parameters:[kNetworkMgr baseParam] completionHandler:^(id responseObj, NSString *errorMsg) {
        
        UpdateVersionModel *updateVersion = [UpdateVersionModel cn_parse:responseObj];
        if ([updateVersion.flag integerValue ] == 0) {
            // 不更新
            handler(NO);
        }
        else if([updateVersion.flag integerValue] >= 1){
            if (updateVersion.appDownUrl.length < 1) { //没有下载连接地址
                handler(NO);
                return ;
            }
            
            NSString *title = @"";
            NSString *content = updateVersion.upgradeDesc[@"des"] ?: @"";
            NSString *cancelTitle = @"";
            NSString *suretitle = @"";
            if ([updateVersion.flag integerValue ] == 1) {
//                title = [NSString stringWithFormat:@"检测到新版本 V%@",updateVersion.versionCode ] ;
//                cancelTitle = @"暂不更新";
//                suretitle= @"更新";
                
//                [HYAlertView showToastViewWithTitle:title content:content leftTitle:cancelTitle rightTitle:@"更新" isHideMaskviewTip:NO confirmBtnBlock:^(BOOL isConfirm) {
//                    if (isConfirm) {
//                        if (@available(iOS 10.0, *)) {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateVersion.appDownUrl] options:@{} completionHandler:^(BOOL success) {
//
//                            }];
//                        } else {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateVersion.appDownUrl]];
//                        }
//                    }
//                    // 弱更 不管怎样都往下走
//                    hanlder(NO);
//                }];
                
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
                
//                title = [NSString stringWithFormat:@"⚠️请更新到新版本 V%@",updateVersion.versionCode];
//                cancelTitle = @"退出应用";
//                suretitle= @"强制更新";
//                [HYAlertView showToastViewWithTitle:title content:content leftTitle:cancelTitle rightTitle:@"更新" isHideMaskviewTip:YES confirmBtnBlock:^(BOOL isConfirm) {
//                    if (isConfirm) {
//                        if (@available(iOS 10.0, *)) {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateVersion.appDownUrl] options:@{} completionHandler:^(BOOL success) {
//
//                            }];
//                        } else {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateVersion.appDownUrl]];
//                        }
////                        [ManageDataModel exitAapplication];
//                        // 强更 不往下走
//                        hanlder(YES);
//                    }else{
//                        if (([updateVersion.flag integerValue ] == 2)) {
//                            [ManageDataModel exitAapplication];
//                        }
//                    }
//                }];
                handler(YES);
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
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            handler([responseObj[@"data"] firstObject], errorMsg);
        } else {
            handler(responseObj, errorMsg);
        }
    }];
}

+ (void)checkAreaLimit:(void(^)(BOOL isAllowEntry))handler {
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    [paramDic setObject:[FCUUID uuidForDevice] forKey:@"deviceId"];
    [self POST:kGatewayPath(config_areaLimit) parameters:paramDic completionHandler:^(id responseObj, NSString *errorMsg) {
        handler([responseObj boolValue]);
    }];
}

@end
