//
//  CNYuEBaoRequest.m
//  HYNewNest
//
//  Created by zaky on 5/14/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNYuEBaoRequest.h"

@implementation CNYuEBaoRequest

+ (void)checkYuEBaoInterestLogsSumHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    NSUInteger month = [[NSDate date] jk_month];
    NSUInteger year = [[NSDate date] jk_year];
    switch (month) {
        // 第一季度 以此类推
        case 1:
        case 2:
        case 3:
            param[@"beginTime"] = [NSString stringWithFormat:@"%lu-%@", (unsigned long)year, @"01-01 00:00:00"];
            param[@"endTime"] = [NSString stringWithFormat:@"%lu-%@", (unsigned long)year, @"03-31 23:59:59"];
            break;
        case 4:
        case 5:
        case 6:
            param[@"beginTime"] = [NSString stringWithFormat:@"%lu-%@", (unsigned long)year, @"04-01 00:00:00"];
            param[@"endTime"] = [NSString stringWithFormat:@"%lu-%@", (unsigned long)year, @"06-30 23:59:59"];
            break;
        case 7:
        case 8:
        case 9:
            param[@"beginTime"] = [NSString stringWithFormat:@"%lu-%@", (unsigned long)year, @"07-01 00:00:00"];
            param[@"endTime"] = [NSString stringWithFormat:@"%lu-%@", (unsigned long)year, @"09-30 23:59:59"];
            break;
        case 10:
        case 11:
        case 12:
            param[@"beginTime"] = [NSString stringWithFormat:@"%lu-%@", (unsigned long)year, @"10-01 00:00:00"];
            param[@"endTime"] = [NSString stringWithFormat:@"%lu-%@", (unsigned long)year, @"12-31 23:59:59"];
            break;
        default:
            break;
    }
    [self POST:config_yebInterestLogsSum parameters:param completionHandler:handler];
}

+ (void)transferInYuEBaoAmount:(NSNumber *)amount handler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"clientType"] = @4; //1=PC 2=H5 3=android 4=iOS
    param[@"remarks"] = @"iOS";
    param[@"amount"] = amount;
    [self POST:config_yebTransferIn parameters:param completionHandler:handler];
}

+ (void)transferOutYuEBaoAmount:(NSNumber *)amount handler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"clientType"] = @4; //1=PC 2=H5 3=android 4=iOS
    param[@"remarks"] = @"iOS";
    param[@"amount"] = amount;
    [self POST:config_yebTransferOut parameters:param completionHandler:handler];
}

+ (void)checkYuEBaoConfigHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"currency"] = [CNUserManager shareManager].isUsdtMode?@"USDT":@"CNY";
    [self POST:config_yebConfig parameters:param completionHandler:handler];
}

@end
