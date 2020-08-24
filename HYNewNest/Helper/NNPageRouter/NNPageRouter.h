//
//  NNPageRouter.h
//  HYNewNest
//
//  Created by Geralt on 03/07/2020.
//  Copyright © 2020 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NNControllerHelper.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CNLive800Type) {
    CNLive800TypeNormal = 0, //普通问题
    CNLive800TypeDeposit,    //存取款问题
    CNLive800TypeForgot      //忘记密码问题
};

@interface NNPageRouter : NSObject


#pragma mark - MAIN

/// 改变根控制器为首页
+ (void)changeRootVc2MainPage;

/// 跳到登录注册
+ (void)jump2Login;
+ (void)jump2Register;

/// 外部打开 一键买卖币
/// @param isSell 是否卖币
+ (void)openExchangeElecCurrencyPageIsSell:(BOOL)isSell;

/// 跳转到客服
/// @param type 客服类型
+(void)jump2Live800Type:(CNLive800Type)type;

/// 首页跳到游戏
/// @param gameName 游戏名
/// @param gameType 游戏类型
/// @param gameId 游戏ID
/// @param gameCode 游戏代码
/// @param platformCurrency 线路（游戏货币）
+ (void)jump2GameName:(NSString *)gameName
             gameType:(NSString *)gameType
               gameId:(NSString *)gameId
             gameCode:(NSString *)gameCode
     platformCurrency:(nullable NSString *)platformCurrency;

/// 跳转到H5
+(void)jump2HTMLWithStrURL: (NSString *)strURL title:(NSString *)title;



@end

NS_ASSUME_NONNULL_END
