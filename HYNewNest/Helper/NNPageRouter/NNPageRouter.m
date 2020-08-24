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

@implementation NNPageRouter

+ (void)changeRootVc2MainPage {
    HYTabBarViewController *tabVC = [[HYTabBarViewController alloc] init];
    [kAppDelegate changeRootViewController:tabVC];
}

+ (void)jump2Login {
    [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:[CNLoginRegisterVC loginVC] animated:YES];
}

+ (void)jump2Register {
    [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:[CNLoginRegisterVC registerVC] animated:YES];
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
        if (!KIsEmptyString(errorMsg)) {
            [CNHUB showError:errorMsg];
            return;
        }
        NSArray *data = [responseObj objectForKey:@"data"];
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
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
    }];
}

+ (void)jump2GameName:(NSString *)gameName
             gameType:(NSString *)gameType
               gameId:(NSString *)gameId
             gameCode:(NSString *)gameCode
     platformCurrency:(nullable NSString *)platformCurrency {
    
    [CNHomeRequest requestInGameUrlGameType:gameType
                                     gameId:gameId
                                   gameCode:gameCode
                           platformCurrency:platformCurrency
                                    handler:^(id responseObj, NSString *errorMsg) {
        
        GameModel *gameModel = [GameModel cn_parse:responseObj];
        NSString *gameUrl = gameModel.url;
        if ([gameUrl containsString:@"&callbackUrl="]) {
            gameUrl = [gameUrl stringByReplacingOccurrencesOfString:@"&callbackUrl=" withString:@"&callbackUrl=https://localhost/exit.html"];
        }
        GameStartPlayViewController *vc = [[GameStartPlayViewController alloc] initGameWithGameUrl:gameUrl title:gameName];
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
    }];
}

+ (void)jump2HTMLWithStrURL:(NSString *)strURL title:(NSString *)title {
    void(^jumpHTMLBlock)(NSString*, NSString*) = ^(NSString * url, NSString * title) {
        HYHTMLViewController *vc = [[HYHTMLViewController alloc] initWithTitle:title strUrl:url];
        vc.hidesBottomBarWhenPushed = YES;
        [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:vc animated:YES];
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
