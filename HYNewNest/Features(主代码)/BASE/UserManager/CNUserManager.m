//
//  CNUserManager.m
//  LCNewApp
//
//  Created by cean.q on 2019/11/27.
//  Copyright © 2019 B01. All rights reserved.
//

#import "CNUserManager.h"
#import <IVHttpManager.h>
#import <WebKit/WebKit.h>

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
        manager.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:manager.modelFile];
        manager.userDetail = [NSKeyedUnarchiver unarchiveObjectWithFile:manager.modelFile2];
    });
    return manager;
}

                            
- (BOOL)saveUserInfo:(NSDictionary *)userInfo {
    if (![userInfo isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    self.userInfo = [CNUserModel cn_parse:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:HYLoginSuccessNotification object:nil];
    return [self saveUerInfoToSandBox];
}

- (BOOL)saveUerInfoToSandBox {
    return [NSKeyedArchiver archiveRootObject:self.userInfo toFile:self.modelFile];
}

- (BOOL)saveUserDetail:(NSDictionary *)userDetail {
    if (![userDetail isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    self.userDetail = [CNUserDetailModel cn_parse:userDetail];
    return [self saveUerDetailToSandBox];
}

- (BOOL)saveUerDetailToSandBox {
    return [NSKeyedArchiver archiveRootObject:self.userDetail toFile:self.modelFile2];
}

- (BOOL)cleanUserInfo {
    [self deleteWebCache];
    [self clearUserDefault];
    
    if (self.userInfo == nil) {
        return YES;
    }
    self.userInfo = nil;
    self.userDetail = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:HYLogoutSuccessNotification object:nil];
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
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HYNotShowCTZNEUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:HYHomeMessageBoxLastimeDate];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HYVIPIsAlreadyShowV2Alert];
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
    [IVHttpManager shareManager].userToken = userInfo.token;
    [IVHttpManager shareManager].loginName = userInfo.loginName;
    //切换 Live800 用户信息
//    if (userInfo == nil) {
//        [IVLive800Wrapper switchUser:nil];
//    } else {
//        LIVUserInfo *livUserInfo = [[LIVUserInfo alloc] init];
//        livUserInfo.userAccount = userInfo.customerId;
//        livUserInfo.name = userInfo.loginName;
//        livUserInfo.loginName = userInfo.loginName;
//        livUserInfo.grade = [NSString stringWithFormat:@"%d", userInfo.starLevel];
//        livUserInfo.gender = userInfo.gender;
//        livUserInfo.mobileNo = userInfo.mobileNo;
//        [IVLive800Wrapper switchUser:livUserInfo];
//    }
}

@end
