//
//  CNSplashRequest.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/21.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "WelcomeModel.h"
#import "UpdateVersionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNSplashRequest : CNBaseNetworking

/// 版本升级
+ (void)queryNewVersion:(void(^)(BOOL isHardUpdate))handler;


/// 欢迎页
+ (void)welcome:(HandlerBlock)handler;


/// 获取H5 和 cdn
+ (void)queryCDNH5Domain:(HandlerBlock)handler;


/// 检查是否区域限制
+ (void)checkAreaLimit:(void(^)(BOOL isAllowEntry))handler;

@end

NS_ASSUME_NONNULL_END
