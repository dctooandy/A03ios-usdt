//
//  CNRechargeRequest.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNRechargeRequest.h"

@implementation CNRechargeRequest

+ (void)getShortCutsHandler:(HandlerBlock)handler {
    NSDictionary *param = @{@"bizCode" : @"DEPOSIT_DATA"};
    [self POST:(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            handler(responseObj[@"data"], errorMsg);
        }
    }];
}

+ (void)queryPayWaysV3Handler:(HandlerBlock)handler {

    [self POST:(config_queryPayWaysV3) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}

+ (void)queryAmountListPayType:(NSString *)payType
                       handler:(HandlerBlock)handler {

    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"payType"] = payType;

    [self POST:(config_queryAmountList) parameters:param completionHandler:handler];
}

//+ (void)queryBQBanksPayType:(NSString *)payType
//                  depositor:(nullable NSString *)depositor
//                depositorId:(nullable NSString *)depositorId
//                    handler:(HandlerBlock)handler {
//    
//    NSMutableDictionary *param = [kNetworkMgr baseParam];
//    param[@"payType"] = payType;
//    if (!KIsEmptyString(depositor)) {
//        param[@"depositor"] = depositor;
//    }
//    if (!KIsEmptyString(depositorId)) {
//        param[@"depositorId"] = depositorId;
//    }
//    
//    [self POST:(config_queryBQBanks) parameters:param completionHandler:handler];
//}

+ (void)queryUSDTPayWalletsHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"bqpaytype"] = @(5); //0BQ 1微信BQ 2人工转账 3比特币 4微信人工 5USDT
    param[@"flag"] = @(1); //是否可用渠道 不传默认全部渠道
    
    [self POST:(config_queryDepositBankInfos) parameters:param completionHandler:handler];
}

+ (void)queryUSDTCounterHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *parm = [kNetworkMgr baseParam];
    parm[@"transferType"] = @2;
    
    [self POST:(config_queryDepositCounter) parameters:parm completionHandler:handler];
}

+ (void)queryUSDTCounterWithType:(QueryDepositType)type Handler:(HandlerBlock)handler
{
    NSMutableDictionary *parm = [kNetworkMgr baseParam];
    parm[@"transferType"] = [NSString stringWithFormat:@"%ld",(long)type];
    [self POST:(config_queryDepositCounter) parameters:parm completionHandler:handler];
}

+ (void)queryOnlineBanksPayType:(NSString *)payType
                   usdtProtocol:(nullable NSString *)usdtProtocol
                        handler:(HandlerBlock)handler {
    NSMutableDictionary *parm = [kNetworkMgr baseParam];
    // 可变字典加值不要这样写, 这样没有值会崩溃
//    [parm setObject:payType forKey:@"payType"];
    // 要这样写,这样没有值，会过率掉
    parm[@"1"] = @"netEarnPrior"; //网赚优先标志
    parm[@"payType"] = payType;
    if (usdtProtocol) {
        parm[@"usdtProtocol"] = usdtProtocol;
        parm[@"currency"] = @"USDT";
    }
    
    [self POST:(config_queryOnlineBanks) parameters:parm completionHandler:handler];
}

//+ (void)submitOnlinePayOrderAmount:(NSString *)amount
//                          currency:(NSString *)currency
//                      usdtProtocol:(NSString *)usdtProtocol
//                           payType:(NSString *)payType
//                             payid:(NSString *)payid
//                        showQRCode:(NSInteger)showQRCode
//                           handler:(HandlerBlock)handler {
//
//    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
//    paramDic[@"amount"] = amount;
//    paramDic[@"currency"] = currency;
//    paramDic[@"usdtProtocol"] = usdtProtocol;
//    paramDic[@"payType"] = payType;
//    paramDic[@"payid"] = payid;
//    paramDic[@"showQRCode"] = @(showQRCode);
//
//    [self POST:(config_createOnlineOrder) parameters:paramDic completionHandler:handler];
//}

+ (void)submitOnlinePayOrderRMBAmount:(NSString *)amount
                              payType:(NSString *)payType
                                payid:(NSString *)payid
                              handler:(HandlerBlock)handler{
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"amount"] = amount;
    paramDic[@"payid"] = payid;
    paramDic[@"payType"] = payType;
    
    [self POST:(config_createOnlineOrder) parameters:paramDic completionHandler:handler];
}

+ (void)submitOnlinePayOrderV2Amount:(NSString *)amount
                            currency:(NSString *)currency
                        usdtProtocol:(NSString *)usdtProtocol
                             payType:(NSString *)payType
                             handler:(HandlerBlock)handler {
    
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"amount"] = amount;
    paramDic[@"currency"] = currency;
    paramDic[@"payType"] = payType;
    paramDic[@"protocol"] = usdtProtocol;
     
    [self POST:(config_createOnlineOrderV2) parameters:paramDic completionHandler:handler];
    
}

+ (void)submitBQPaymentPayType:(NSString *)payType
                        amount:(NSString *)amount
                     depositor:(NSString *)depositor
                 depositorType:(NSInteger)depositorType
//                      bankCode:(NSString *)bankCode
                       handler:(HandlerBlock)handler{

    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"payType"] = payType;
    paramDic[@"amount"] = amount;
    paramDic[@"depositor"] = depositor;
    paramDic[@"depositorType"] = @(depositorType);
//    paramDic[@"bankCode"] = bankCode;

    [self POST:(config_BQPayment) parameters:paramDic completionHandler:handler];
}

+(void)submitOtherUsdtPayment:(NSString *)protocol
                       amount:(NSString *)amount
                      handler:(HandlerBlock)handler{
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    paramDic[@"payType"] = @"25";
    paramDic[@"tranAmount"] = amount;
    paramDic[@"currency"] = @"USDT";
    paramDic[@"protocol"] = protocol;
    [self POST:(config_rechargeUSDTQrcode) parameters:paramDic completionHandler:handler];
}

@end
