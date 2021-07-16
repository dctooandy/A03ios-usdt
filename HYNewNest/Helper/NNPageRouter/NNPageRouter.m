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
#import "HYWithdrawViewController.h"
#import "BYDepositUsdtVC.h"
#import "BYTradeEntryVC.h"
#import "HYRechargeCNYViewController.h"
#import "CNLoginRegisterVC.h"
#import "CNBindPhoneVC.h"

#import "HYWithdrawActivityAlertView.h"
#import "HYBuyECoinGuideVC.h"
#import "BYNewbieMissionVC.h"

#import "CNRechargeRequest.h"
#import "CNWithdrawRequest.h"
#import "CNServiceRequest.h"
#import "NSURL+HYLink.h"
#import <CSCustomSerVice/CSCustomSerVice.h>
#import "KeyChain.h"
#import <YJChat.h>

#import "HYXiMaViewController.h"

@implementation NNPageRouter

+ (void)changeRootVc2MainPage {
    HYTabBarViewController *tabVC = [[HYTabBarViewController alloc] init];
    [NNControllerHelper changeRootVc:tabVC];
}

+ (void)changeRootVc2DevPage {

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
        BYTradeEntryVC *tradeVC = [[BYTradeEntryVC alloc] initWithType:TradeEntryTypeDeposit];
        [kCurNavVC pushViewController:tradeVC animated:true];
    } else {
        [kCurNavVC pushViewController:[HYRechargeCNYViewController new] animated:YES];
    }
}

+ (void)jump2DepositWithSuggestAmount:(int)amount {
    if ([CNUserManager shareManager].isUsdtMode) {
        BYDepositUsdtVC *vc = [[BYDepositUsdtVC alloc] init];
        vc.suggestRecharge = amount;
        [kCurNavVC pushViewController:vc animated:true];
    }
    else {
        [kCurNavVC pushViewController:[HYRechargeCNYViewController new] animated:YES];
    }
}

+ (void)jump2Withdraw {
    
    [LoadingView show];
    [CNWithdrawRequest getUserMobileStatusCompletionHandler:^(id responseObj, NSString *errorMsg) {
        [LoadingView hide];
//        CNUserDetailModel *model = [CNUserDetailModel cn_parse:responseObj];
//        if (!model.mobileNoBind) { // 没有绑定手机 -> 跳到手机绑定
//            CNBindPhoneVC *vc = [CNBindPhoneVC new];
//            vc.bindType = CNSMSCodeTypeBindPhone;
//            [kCurNavVC pushViewController:vc animated:YES];
//            return;
//        }
        
        if ([CNUserManager shareManager].isUsdtMode) {
//            [kCurNavVC pushViewController:[HYWithdrawViewController new] animated:YES];
            BYTradeEntryVC *tradeVC = [[BYTradeEntryVC alloc] initWithType:TradeEntryTypeWithdraw];
            [kCurNavVC pushViewController:tradeVC animated:true];
            
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
                urlStr = [urlStr stringByReplacingOccurrencesOfString:@"/list" withString:@""];
                NSURL *url = [NSURL URLWithString:urlStr];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
                    }];
                } else {
                    [CNTOPHUB showError:@"PayURL错误 请联系客服"];
                }
            }
        }
    }];
}

+ (void)presentOCSS_VC {
    // 打开新客服入口
    MyLog(@"新客服版本：%@",[CSVisitChatmanager getVersion]);

    CSChatInfo *info = [[CSChatInfo alloc]init];
    info.productId = [IVHttpManager shareManager].productId;//产品ID
    info.loginName = [IVHttpManager shareManager].loginName?:@"";//网站用户名，你们app的用户名
    info.token = [IVHttpManager shareManager].userToken?:@"";//网站登陆后的token,你们app的token
    info.domainName = [IVHttpManager shareManager].domain;//网站域名
    info.appid = [IVHttpManager shareManager].appId;//AppID
    info.uuid = [KeyChain getKeychainIdentifierUUID];//设备id，不穿 会默认生成
    info.baseUrl = [IVHttpManager shareManager].gateway;//app网关地址

    //导航栏设置
    info.title = @"在线客服";//导航栏标题
    info.backColor = [UIColor lightGrayColor];
    info.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontPFSB18]};
    info.barTintColor = kHexColor(0x1A1A2C);
    
    [CSVisitChatmanager startServiceWithSuperVC:[NNControllerHelper currentTabBarController] chatInfo:info finish:^(CSServiceCode errCode) {
        if (errCode != CSServiceCode_Request_Suc) {
            [CNTOPHUB showError:@"系统错误，请稍后再试"];
        }
    }];

}

+ (void)presentWMQCustomerService {
    [LoadingView show];
    [YJChat connectToUser:[CNUserManager shareManager].printedloginName
                    level:[NSString stringWithFormat:@"%ld",[CNUserManager shareManager].userInfo.starLevel]
               customerId:[CNUserManager shareManager].userInfo.customerId
               complation:^(BOOL success, NSString * _Nonnull message) {
        [LoadingView hide];
        if (!success) {
            [CNTOPHUB showError:message];
        } else {
            [CNTOPHUB showSuccess:message];
        }
    }];
}

+ (void)jump2HTMLWithStrURL:(NSString *)strURL title:(NSString *)title needPubSite:(BOOL)needPubSite{
    void(^jumpHTMLBlock)(NSString*, NSString*) = ^(NSString * url, NSString * title) {
        HYHTMLViewController *vc = [[HYHTMLViewController alloc] initWithTitle:title strUrl:url];
        vc.hidesBottomBarWhenPushed = YES;
        [kCurNavVC pushViewController:vc animated:YES];
    };

    if ([CNUserManager shareManager].isLogin) {
        [self requestH5TicketHandler:^(NSString * ticket, NSString *errorMsg) {
            if (!errorMsg) {
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

+ (void)jump2Xima {
    HYXiMaViewController *vc = [[HYXiMaViewController alloc] init];
    [kCurNavVC pushViewController:vc animated:true];
}

+ (void)jump2VIP {
    [kCurNavVC popToRootViewControllerAnimated:false];
    [[NNControllerHelper currentTabBarController] setSelectedIndex:1];
}

+ (void)jump2NewbieMission {
    [kCurNavVC popToRootViewControllerAnimated:false];
    [kCurNavVC pushViewController:[[BYNewbieMissionVC alloc] init] animated:true];
}

#pragma mark - Request

+ (void)requestH5TicketHandler:(HandlerBlock)handler {
    
    [CNBaseNetworking POST:(config_h5Ticket) parameters:[kNetworkMgr baseParam] completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]] && [[responseObj allKeys] containsObject:@"ticket"]) {
            NSString *ticket = responseObj[@"ticket"];
            handler(ticket, errorMsg);
        } else {
            handler(nil, errorMsg);
        }
    }];
}


@end
