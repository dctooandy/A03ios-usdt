//
//  CNNotificationName.h
//  HYNewNest
//
//  Created by Cean on 2020/7/20.
//  Copyright © 2020 james. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSNotificationName
UIKIT_EXTERN NSNotificationName const HYLoginSuccessNotification;
UIKIT_EXTERN NSNotificationName const HYLogoutSuccessNotification;
UIKIT_EXTERN NSNotificationName const HYSwitchAcoutSuccNotification;
UIKIT_EXTERN NSNotificationName const BYWebSocketDidOpenNoti;
UIKIT_EXTERN NSNotificationName const BYWebSocketDidReceivedNoti;
UIKIT_EXTERN NSNotificationName const BYDidEnterHomePageNoti;
UIKIT_EXTERN NSNotificationName const BYDidUpdateUserProfileNoti;

#pragma mark - UserDefaultKey
/// 充提指南
UIKIT_EXTERN NSString * const HYNotShowCTZNEUserDefaultKey;
/// CNY取款拆分弹窗
UIKIT_EXTERN NSString * const HYNotShowQKFLUserDefaultKey;
/// 首页弹窗盒子
UIKIT_EXTERN NSString * const HYHomeMessageBoxLastimeDate;
/// vip2.0
UIKIT_EXTERN NSString * const HYVIPIsAlreadyShowV2Alert;

/// 提幣教學
UIKIT_EXTERN NSString * const HYNotShowWithdrawUserDefaultKey;
/// 賣幣指南
UIKIT_EXTERN NSString * const HYNotShowSellUserDefaultKey;
/// 人民幣直充指南
UIKIT_EXTERN NSString * const HYNotShowRMBRechrageUserDefaultKey;
/// 數字貨幣充值指南
UIKIT_EXTERN NSString * const HYNotShowDigitRechargeUserDefaultKey;
