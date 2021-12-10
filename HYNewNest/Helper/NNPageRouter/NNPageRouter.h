//
//  NNPageRouter.h
//  HYNewNest
//
//  Created by Geralt on 03/07/2020.
//  Copyright © 2020 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CNBaseNetworking.h"
#import "NNControllerHelper.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, QueryDepositType) {
    BuyCoin = 0, // 买币
    SellCoin, // 卖币
    SkipOut, // 跳转
};

@interface NNPageRouter : NSObject

/// 改变根控制器为首页
+ (void)changeRootVc2MainPage;


/// 跳到登录注册
+ (void)jump2Login;
+ (void)jump2Register;


/// 去【提】现 (双模式统一入口)
+ (void)jump2Withdraw;

/// 去【充】值(双模式统一入口)
+ (void)jump2Deposit;

+ (void)jump2DepositWithSuggestAmount:(int)amount;

/// 去【买】币 (已和一键买卖币合并)
+ (void)jump2BuyECoin;

/// 一键【买/卖】币（外部跳转dexchange）
+ (void)openExchangeElecCurrencyPage;
/// type : 0：买币,1：卖币,2:跳转支付存款小助手
+ (void)openExchangeElecCurrencyPageWithType:(QueryDepositType)type;


/// 跳转到客服
+ (void)presentOCSS_VC;

+ (void)presentOCSS_VC:(BOOL)hugeAmount;

/// 跳转到微脉圈
+ (void)presentWMQCustomerService;


///进入H5获取ticket
+ (void)requestH5TicketHandler:(HandlerBlock)handler;

/// 跳转到H5
+(void)jump2HTMLWithStrURL: (NSString *)strURL title:(NSString *)title needPubSite:(BOOL)needPubSite;

/// 跳转到(风采)文章详情
+ (void)jump2ArticalWithArticalId:(NSString *)articleId title:(NSString *)title;

///去洗碼
+ (void)jump2Xima;

///去VIP
+ (void)jump2VIP;

+ (void)jump2NewbieMission;

@end

NS_ASSUME_NONNULL_END
