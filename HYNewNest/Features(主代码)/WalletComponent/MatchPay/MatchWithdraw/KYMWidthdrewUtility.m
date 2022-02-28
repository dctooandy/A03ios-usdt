//
//  KYMWidthdrewUtility.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWidthdrewUtility.h"
#import "KYMWithdrewRequest.h"
#import "KYMSelectChannelVC.h"
#import "CNMAlertView.h"
#import "LoadingView.h"
//#import "CNMFastPayStatusVC.h"
#import "KYMFastWithdrewVC.h"
#import "MBProgressHUD+Add.h"
#import "BalanceManager.h"
@implementation KYMWidthdrewUtility
/** 转换货币字符串 */
+ (NSString *)getMoneyString:(double)money {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.roundingMode = NSNumberFormatterRoundFloor;
    numberFormatter.maximumFractionDigits = 2;
    // 设置格式
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    return formattedNumberString;
}
+ (void)checkWithdraw:(UIViewController *)viewController callBack:(void(^)(BOOL isMatch,KYMWithdrewCheckModel  * checkModel))callback {
    NSMutableDictionary *parmas = @{}.mutableCopy;
    parmas[@"merchant"] = @"A01";
    //网络库底层自带这两个参数，如果其他产品不带的需要加上
//                        parmas[@"loginName"] = @"xxx";
//                        parmas[@"productId"] = @"xxx";
    parmas[@"type"] = @"2";
    parmas[@"currency"] = @"CNY";
    [LoadingView showLoadingViewWithToView:nil needMask:YES];
    [KYMWithdrewRequest checkChannelWithParams:parmas.copy callback:^(BOOL status, NSString * _Nonnull msg, KYMWithdrewCheckModel  * _Nonnull model) {
        if (!status) {
            [LoadingView hideLoadingViewForView:nil];
            [MBProgressHUD showError:msg toView:nil];
            return;
        }
        kym_requestBalance(^(BOOL status, NSString * _Nonnull msg, NSString  *_Nonnull balance) {
            if (!status) {
                [LoadingView hideLoadingViewForView:nil];
                [MBProgressHUD showError:msg toView:nil];
                return;
            }
            [LoadingView hideLoadingViewForView:nil];
            //移除比余额小的金额
            [model.data removeAmountBiggerThanTotal:balance];
            //如果渠道开启，有金额列表，且金额列表中最小的比余额大才走撮合
            if (model.data.isAvailable && model.data.amountList.count > 0 && [balance doubleValue] >= [model.data.miniAmount doubleValue]) {
                //取款类型选择弹框
                KYMSelectChannelVC *vc = [[KYMSelectChannelVC alloc] init];
                vc.checkModel = model;
                vc.selectedChannelCallback = ^(NSInteger index) {
                    //是否为撮合取款
                    if (index == 0) {
                        //是否已存在存取款提案
                        if (model.data.mmProcessingOrderTransactionId && model.data.mmProcessingOrderTransactionId.length != 0) {
                            if (model.data.mmProcessingOrderType == 1) { // 存款
                                [CNMAlertView showAlertTitle:@"交易提醒" content:@"您当前有正在交易的存款订单\n如需取款，请选择在线取款" desc:nil needRigthTopClose:NO commitTitle:@"查看订单" commitAction:^{
    //                                CNMFastPayStatusVC *statusVC = [[CNMFastPayStatusVC alloc] init];
    //                                statusVC.cancelTime = [model.data.remainCancelDepositTimes integerValue];
    //                                statusVC.transactionId = model.data.mmProcessingOrderTransactionId;
    //                                [viewController.navigationController pushViewController:statusVC animated:YES];
                                    
                                } cancelTitle:@"在线取款" cancelAction:^{
                                    //普通取款
                                    callback(NO,nil);
                                }];
                            } else { // 取款
                                
                                KYMFastWithdrewVC *vc = [[KYMFastWithdrewVC alloc] init];
                                vc.mmProcessingOrderTransactionId = model.data.mmProcessingOrderTransactionId;
                                
                                [CNMAlertView showAlertTitle:@"交易提醒" content:@"老板，如需再次取款，请选择在线取款" desc:nil needRigthTopClose:NO commitTitle:@"关闭" commitAction:^{
                                    
                                } cancelTitle:@"在线取款" cancelAction:^{
                                    [viewController.navigationController popViewControllerAnimated:NO];
                                    [vc stopTimer];
                                    //普通取款
                                    callback(NO,nil);
                                }];
                                
                                [viewController.navigationController pushViewController:vc animated:YES];
                            }
                        } else {
                            //撮合取款
                            callback(YES,model);
                        }
                    } else {
                        //普通取款
                        callback(NO,nil);
                    }
                    
                };
                [viewController presentViewController:vc animated:YES completion:nil];
            } else {
                //普通取款
                callback(NO,nil);
            }
        });
    }];
}


@end
