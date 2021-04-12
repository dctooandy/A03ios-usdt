//
//  NNPageRouter.m
//  HYNewNest
//
//  Created by zaky on 03/07/2020.
//  Copyright © 2020 james. All rights reserved.
//

#import "NNPageRouter.h"
#import "AppDelegate.h"
#import "HYTabBarViewController.h"
#import "HYNavigationController.h"
#import "HYHTMLViewController.h"
#import "GameStartPlayViewController.h"

#import "CNLoginRegisterVC.h"
#import "HYWithdrawViewController.h"
#import "HYRechargeViewController.h"
#import "HYRechargeCNYViewController.h"
#import "HYBuyECoinGuideVC.h"
#import "BYNewUsrMissionVC.h"

#import "HYWithdrawActivityAlertView.h"

#import "CNHomeRequest.h"
#import "CNRechargeRequest.h"
#import "CNWithdrawRequest.h"
#import "NSURL+HYLink.h"

#import "CNBindPhoneVC.h"

@implementation NNPageRouter

+ (void)changeRootVc2MainPage {
    HYTabBarViewController *tabVC = [[HYTabBarViewController alloc] init];
    [NNControllerHelper changeRootVc:tabVC];
}

+ (void)changeRootVc2DevPage {
    BYNewUsrMissionVC *vc = [BYNewUsrMissionVC new];
    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:vc];
    [NNControllerHelper changeRootVc:nav];
}

+ (void)jump2Login {
    [kCurNavVC pushViewController:[CNLoginRegisterVC loginVC] animated:YES];
}

+ (void)jump2Register {
    [kCurNavVC pushViewController:[CNLoginRegisterVC registerVC] animated:YES];
}

+ (void)jump2BuyECoin {
//    NSInteger depositLevel = [CNUserManager shareManager].userDetail.depositLevel;
//    if (depositLevel > 1) {
        [NNPageRouter openExchangeElecCurrencyPage];
//    } else { // 小于一星级
//        HYBuyECoinGuideVC *vc = [HYBuyECoinGuideVC new];
//        [kCurNavVC pushViewController:vc animated:YES];
//    }
    
}

+ (void)jump2Deposit {
    if ([CNUserManager shareManager].isUsdtMode) {
        [kCurNavVC pushViewController:[HYRechargeViewController new] animated:YES];
    } else {
        [kCurNavVC pushViewController:[HYRechargeCNYViewController new] animated:YES];
    }
}

+ (void)jump2Withdraw {
    
    [CNWithdrawRequest getUserMobileStatusCompletionHandler:^(id responseObj, NSString *errorMsg) {
        CNUserDetailModel *model = [CNUserDetailModel cn_parse:responseObj];
        if (!model.mobileNoBind) { // 没有绑定手机 -> 跳到手机绑定
            CNBindPhoneVC *vc = [CNBindPhoneVC new];
            vc.bindType = CNSMSCodeTypeBindPhone;
            [kCurNavVC pushViewController:vc animated:YES];
            return;
        }
        
        if ([CNUserManager shareManager].isUsdtMode) {
            [kCurNavVC pushViewController:[HYWithdrawViewController new] animated:YES];
            
        } else {
            
            __block void(^jumpWithdrawBlock)(WithdrawCalculateModel* ) = ^(WithdrawCalculateModel * model) {
                HYWithdrawViewController *vc = [HYWithdrawViewController new];
                vc.calculatorModel = model;
                [kCurNavVC pushViewController:vc animated:YES];
            };
            
            [CNWithdrawRequest withdrawCalculatorMode:@1 amount:nil accountId:nil handler:^(id responseObj, NSString *errorMsg) {
                
                if (!errorMsg && responseObj ) {
                    WithdrawCalculateModel *model = [WithdrawCalculateModel cn_parse:responseObj];
                    
                    if (![[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowQKFLUserDefaultKey] && model.creditExchangeFlag) {
                        
                        [HYWithdrawActivityAlertView showWithAmountPercent:model.creditExchangeRatio
                                                               giftPercent:model.promoInfo.promoRatio
                                                                mostAmount:model.promoInfo.maxAmount handler:^{
                            jumpWithdrawBlock(model);
                            
                        }];
                    } else {
                        jumpWithdrawBlock(model);
                    }
                }
            }];
        }
    }];
    
}

+ (void)openExchangeElecCurrencyPage {
    [CNRechargeRequest queryUSDTCounterHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSString *urlStr = responseObj[@"payUrl"];
            if (!KIsEmptyString(urlStr)) {
                NSURL *url = [NSURL URLWithString:urlStr];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        [CNHUB showSuccess:@"请在外部浏览器查看"];
                    }];
                } else {
                    [CNHUB showError:@"PayURL错误 请联系客服"];
                }
            }
        }
    }];
}

+ (void)jump2Live800Type:(CNLive800Type)type {
    __block NSString *keyName;
    switch (type) {
        case CNLive800TypeNormal:
            keyName = @"usdt_otherLive800";
            break;
        case CNLive800TypeDeposit:
            keyName = @"usdt_depositLive800";
            break;
        case CNLive800TypeForgot:
            keyName = @"忘记密码";
            break;
        default:
            break;
    }
    [CNHomeRequest requestDynamicLive800AddressCompletionHandler:^(id responseObj, NSString *errorMsg) {

        NSArray *data = responseObj;
        NSMutableString *newUrl;
        for (NSDictionary *body in data) {
            if ([body[@"domian"] isEqualToString:keyName]) {
                newUrl = [[body objectForKey:@"url"] mutableCopy];
                break;
            }
        }
        if ([newUrl hasSuffix:@"&enterurl="]) {
            [newUrl appendString:[IVHttpManager shareManager].domain];
        } else {
            NSString *enterurl = [NSString stringWithFormat:@"&enterurl=%@", [IVHttpManager shareManager].domain];
            [newUrl appendString:enterurl];
        }
        [newUrl appendFormat:@"&loginname=%@&name=%@&timestamp=%ld", [CNUserManager shareManager].userInfo.loginName,  [CNUserManager shareManager].userInfo.loginName, (NSInteger)[[NSDate date] timeIntervalSince1970]*1000];
        
        HYHTMLViewController *vc = [[HYHTMLViewController alloc] initWithTitle:@"客服" strUrl:newUrl];
        vc.hidesBottomBarWhenPushed = YES;
        [kCurNavVC pushViewController:vc animated:YES];
    }];
}


+ (void)jump2HTMLWithStrURL:(NSString *)strURL title:(NSString *)title needPubSite:(BOOL)needPubSite{
    void(^jumpHTMLBlock)(NSString*, NSString*) = ^(NSString * url, NSString * title) {
        HYHTMLViewController *vc = [[HYHTMLViewController alloc] initWithTitle:title strUrl:url];
        vc.hidesBottomBarWhenPushed = YES;
        [kCurNavVC pushViewController:vc animated:YES];
    };

//    if ([CNUserManager shareManager].isLogin && ![CNUserManager shareManager].isTryUser) {
    if ([CNUserManager shareManager].isLogin) {
        [CNHomeRequest requestH5TicketHandler:^(NSString * ticket, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg)) {
                NSString *strUrl = [NSURL getH5StrUrlWithString:strURL ticket:ticket needPubSite:needPubSite];
                jumpHTMLBlock(strUrl, title);
            }
        }];
        
    }else{
        NSString *strUrl = [NSURL getH5StrUrlWithString:strURL ticket:@"" needPubSite:needPubSite];
        jumpHTMLBlock(strUrl, title);
    }
    
}

+ (void)jump2ArticalWithArticalId:(NSString *)articleId title:(NSString *)title {
    NSString *url = [NSURL getFCH5StrUrlWithID:articleId];
    HYHTMLViewController *vc = [[HYHTMLViewController alloc] initWithTitle:@"风采详情" strUrl:url];
    vc.hidesBottomBarWhenPushed = YES;
    [kCurNavVC pushViewController:vc animated:YES];
    
}


@end
