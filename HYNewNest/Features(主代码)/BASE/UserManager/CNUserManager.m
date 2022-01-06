//
//  CNUserManager.m
//  LCNewApp
//
//  Created by cean.q on 2019/11/27.
//  Copyright © 2019 B01. All rights reserved.
//

#import "CNUserManager.h"
#import "IVHttpManager.h"
#import <WebKit/WebKit.h>
#import <IN3SAnalytics/CNTimeLog.h>

@interface CNUserManager ()
@property (nonatomic, copy) NSString *modelFile;
@property (nonatomic, copy) NSString *modelFile2;
@end

@implementation CNUserManager

+ (instancetype)shareManager {
    static CNUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CNUserManager alloc] init];
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 12
//        NSMutableData *data = [NSMutableData dataWithContentsOfFile:manager.modelFile];
//        manager.userInfo = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:nil];
//
//        data = [NSMutableData dataWithContentsOfFile:manager.modelFile2];
//        manager.userDetail = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:nil];
//#else
        manager.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:manager.modelFile];
        manager.userDetail = [NSKeyedUnarchiver unarchiveObjectWithFile:manager.modelFile2];
//#endif
    });
    return manager;
}

                            
- (BOOL)saveUserInfo:(NSDictionary *)userInfo {
    if (![userInfo isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    self.userInfo = [CNUserModel cn_parse:userInfo];
    return [self saveUerInfoToSandBox];
}

- (BOOL)saveUerInfoToSandBox {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 12
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userInfo requiringSecureCoding:true error:nil];
//    return [data writeToFile:self.modelFile atomically:true];
//#else
    return [NSKeyedArchiver archiveRootObject:self.userInfo toFile:self.modelFile];
//#endif
}
- (BOOL)saveUserDetailWithoutNoti:(NSDictionary *)userDetail {
    if (![userDetail isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    self.userDetail = [CNUserDetailModel cn_parse:userDetail];
    return [self saveUerDetailToSandBox];
}
- (BOOL)saveUserDetail:(NSDictionary *)userDetail {
    if (![userDetail isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    self.userDetail = [CNUserDetailModel cn_parse:userDetail];
    //确保取得所有资料后才发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:HYLoginSuccessNotification object:nil];
    return [self saveUerDetailToSandBox];
}

- (BOOL)saveUserMobileStatus:(NSDictionary *)mobileStatus {
    if (![mobileStatus isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    self.userDetail.realName = mobileStatus[@"realName"];
    self.userDetail.mobileNo = mobileStatus[@"mobileNo"];
    self.userDetail.mobileNoBind = [mobileStatus[@"mobileNoBind"] integerValue];
    self.userDetail.withdralPwdFlag = [mobileStatus[@"withdralPwdFlag"] integerValue];
    return [self saveUerDetailToSandBox];
}

- (BOOL)saveUerDetailToSandBox {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 12
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userDetail requiringSecureCoding:true error:nil];
//    return [data writeToFile:self.modelFile2 atomically:true];
//#else
    return [NSKeyedArchiver archiveRootObject:self.userDetail toFile:self.modelFile2];
//#endif
}

- (BOOL)cleanUserInfo {
    // 清缓存
    [self deleteWebCache];
    [self clearUserDefault];
    self.userInfo = nil;
    self.userDetail = nil;
    // 给网络框架赋值
    [IVHttpManager shareManager].userToken = nil;
    [IVHttpManager shareManager].loginName = nil;
    // 给3S赋值
    [CNTimeLog setUserName:nil];
    // 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:HYLogoutSuccessNotification object:nil];
    // 清文件
    [[NSFileManager defaultManager] removeItemAtPath:self.modelFile2 error:nil];
    return [[NSFileManager defaultManager] removeItemAtPath:self.modelFile error:nil];
}

/// 清H5缓存
- (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];

    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

/// 清偏好设置
- (void)clearUserDefault {
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HYNotShowCTZNEUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HYHomeMessageBoxLastimeDate];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HYVIPIsAlreadyShowV2Alert];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HYDidShowTJTCUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - GETTER

- (NSString *)modelFile {
    if (!_modelFile) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _modelFile = [documentPath stringByAppendingPathComponent:@"/CNUIJDYJ"];
    }
    return _modelFile;
}

- (NSString *)modelFile2 {
    if (!_modelFile2) {
        NSString *documenPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        _modelFile2 = [documenPath stringByAppendingPathComponent:@"/CNUIJDYJ2"];
    }
    return _modelFile2;
}

- (BOOL)isLogin {
    return self.userInfo.token.length > 0;
}

- (BOOL)isTryUser {
    return !self.userInfo.customerType;
}

- (NSString *)printedloginName {
    NSString *loginName = self.userInfo.loginName;
    if (!KIsEmptyString(loginName)) {
        if ([loginName hasSuffix:@"usdt"]) {
            return [loginName substringToIndex:loginName.length-4];
        } else {
            return loginName;
        }
    } else {
        return @"";
    }
}

- (BOOL)isUsdtMode {
//    return [self.userInfo.loginName hasSuffix:@"usdt"];
    if (self.userInfo) {
        return [self.userInfo.uiMode caseInsensitiveCompare:@"usdt"] == NSOrderedSame;
    } else {
        return YES; //默认是USDT模式的
    }
}

- (BOOL)isUiModeHasOptions {
    if (self.userInfo) {
        return self.userInfo.uiModeOptions.count > 1;
    } else {
        return NO; //默认隐藏切换按钮
    }
}

#pragma mark - SETTER

- (void)setUserInfo:(CNUserModel *)userInfo {
    _userInfo = userInfo;
    // 给网络框架赋值
    [IVHttpManager shareManager].userToken = userInfo.token;
    [IVHttpManager shareManager].loginName = userInfo.loginName;
    // 给3S赋值
    [CNTimeLog setUserName:userInfo.loginName];
}

@end
