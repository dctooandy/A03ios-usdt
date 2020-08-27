//
//  CNUserManager.h
//  LCNewApp
//
//  Created by cean.q on 2019/11/27.
//  Copyright © 2019 B01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNUserModel.h"
#import "CNUserDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNUserManager : NSObject
/// 用户信息
@property (nonatomic, strong, nullable) CNUserModel *userInfo;
/// 用户信息
@property (nonatomic, strong, nullable) CNUserDetailModel *userDetail;

/// 是否登录
@property (nonatomic, readonly, assign, getter=isLogin) BOOL login;
/// 是否试玩 ：废弃
//@property (nonatomic, readonly, getter=isTryUser) BOOL tryUser;
/// 去掉“usdt”后缀的登录名
@property (nonatomic, readonly, copy) NSString *printedloginName;

/// 当前是USDT模式还是RMB模式
@property (nonatomic, readonly, assign, getter=isUsdtMode) BOOL usdtMode;
/// 是否双模式用户
@property (nonatomic, readonly, assign, getter=isUiModeHasOptions) BOOL uiModeHasOptions;

+ (instancetype)shareManager;

/// 登录注册成功用户信息存储，内存和沙盒各一份
/// @param userInfo  NSDictionary 用户信息
- (BOOL)saveUserInfo:(NSDictionary *)userInfo;

/// 存储根据token获取到的用户详细信息
/// @param userDetail 用户详细信息
- (BOOL)saveUserDetail:(NSDictionary *)userDetail;

/// 清除用户数据，内存和沙盒都清除
- (BOOL)cleanUserInfo;

/// 清浏览器缓存
- (void)deleteWebCache;

@end

NS_ASSUME_NONNULL_END
