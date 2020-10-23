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
#import "NSURL+HYLink.h"
#import "HYHTMLViewController.h"
#import "GameStartPlayViewController.h"
#import "CNLoginRegisterVC.h"

#import "CNHomeRequest.h"
#import "CNRechargeRequest.h"
#import "CNWithdrawRequest.h"
#import "HYWithdrawActivityAlertView.h"
#import "HYWithdrawViewController.h"
#import "HYRechargeViewController.h"
#import "HYRechargeCNYViewController.h"
#import "HYBuyECoinGuideVC.h"

@implementation NNPageRouter

+ (void)changeRootVc2MainPage {
    HYTabBarViewController *tabVC = [[HYTabBarViewController alloc] init];
    [kAppDelegate changeRootViewController:tabVC];
}

+ (void)jump2Login {
    [kCurNavVC pushViewController:[CNLoginRegisterVC loginVC] animated:YES];
}

+ (void)jump2Register {
    [kCurNavVC pushViewController:[CNLoginRegisterVC registerVC] animated:YES];
}

+ (void)jump2BuyECoin {
    NSInteger depositLevel = [CNUserManager shareManager].userDetail.depositLevel;
    MyLog(@"****** 当前用户信用等级 == %ld", depositLevel);
    if (depositLevel > 1 || depositLevel == -15 || depositLevel == -13) {
        [NNPageRouter openExchangeElecCurrencyPageIsSell:NO];
    } else {
        BOOL notshowBitBaseFlag = NO;
        if (depositLevel == -1 || depositLevel == -11) {
            notshowBitBaseFlag = YES;
        }
        HYBuyECoinGuideVC *vc = [HYBuyECoinGuideVC new];
        vc.needNotShowBitbase = notshowBitBaseFlag;
        [kCurNavVC pushViewController:vc animated:YES];
    }
    
}

+ (void)jump2Deposit {
    if ([CNUserManager shareManager].isUsdtMode) {
        [kCurNavVC pushViewController:[HYRechargeViewController new] animated:YES];
    } else {
        [kCurNavVC pushViewController:[HYRechargeCNYViewController new] animated:YES];
    }
}

+ (void)jump2Withdraw {
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
}

+ (void)openExchangeElecCurrencyPageIsSell:(BOOL)isSell {
    [CNRechargeRequest queryUSDTCounterTransferType:isSell?1:0 Handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSString *urlStr = responseObj[@"payUrl"];
            if (!KIsEmptyString(urlStr)) {
                NSURL *url = [NSURL URLWithString:urlStr];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        [CNHUB showSuccess:@"请在外部浏览器查看"];
                    }];
                } else {
                    [CNHUB showError:@"PayURL错误 打开失败"];
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


+ (void)jump2HTMLWithStrURL:(NSString *)strURL title:(NSString *)title {
    void(^jumpHTMLBlock)(NSString*, NSString*) = ^(NSString * url, NSString * title) {
        HYHTMLViewController *vc = [[HYHTMLViewController alloc] initWithTitle:title strUrl:url];
        vc.hidesBottomBarWhenPushed = YES;
        [kCurNavVC pushViewController:vc animated:YES];
    };

//    if ([CNUserManager shareManager].isLogin && ![CNUserManager shareManager].isTryUser) {
    if ([CNUserManager shareManager].isLogin) {
        [CNHomeRequest requestH5TicketHandler:^(NSString * ticket, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg)) {
                NSString *strUrl = [NSURL getH5StrUrlWithString:strURL ticket:ticket];
                jumpHTMLBlock(strUrl, title);
            }
        }];
        
    }else{
        NSString *strUrl = [NSURL getH5StrUrlWithString:strURL ticket:@""];
        jumpHTMLBlock(strUrl, title);
    }
    
}


@end
