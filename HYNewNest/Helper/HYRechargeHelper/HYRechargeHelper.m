//
//  HYRechargeHelper.m
//  HYGEntire
//
//  Created by zaky on 08/05/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "HYRechargeHelper.h"

@implementation HYRechargeHelper


+ (BOOL)isOnlinePayWayDCBox:(DepositsBankModel *)item {
    if ([item.payType isEqualToString:@"43"]) {
        return YES;
    }
    return NO;
}

/**
 90 91 92 是转账类
*/
+ (BOOL)isOnlinePayWay:(PayWayV3PayTypeItem *)item {
    if ([item.payType isEqualToString:@"90"] ||
        [item.payType isEqualToString:@"91"] ||
        [item.payType isEqualToString:@"92"]) {
        return NO;
    }
    return YES;
}

/// 限额提示字符串
+ (NSString *)amountTip:(PayWayV3PayTypeItem *)item{
    
    NSString *amongStr = @"";
    NSString *minStr;
    NSString *maxStr;
    if (item.minAmount > 0) {
        minStr = [self getAmountByStr: [NSString stringWithFormat:@"%ld", item.minAmount]];
        maxStr = [self getAmountByStr: [NSString stringWithFormat:@"%ld", item.maxAmount]];
        amongStr = [NSString stringWithFormat:@"限额 %@~%@",minStr,maxStr];
    }else{
        amongStr = @"最少充值50";
    }
    return amongStr;
}

/// 限额提示字符串
+ (NSString *)amountTipUSDT:(DepositsBankModel *)bank {
    NSString *amongStr = @"";
    NSString *minStr;
    NSString *maxStr;
    if (bank.minAmount > 0) {
        minStr = [self getAmountByStr: [NSString stringWithFormat:@"%ld", bank.minAmount]];
        maxStr = [self getAmountByStr: [NSString stringWithFormat:@"%ld", bank.maxAmount]];
        amongStr = [NSString stringWithFormat:@"限额 %@~%@ USDT",minStr,maxStr];
    }else{
        amongStr = @"最少充值10USDT";
    }
    return amongStr;
}

+ (NSString *)getAmountByStr:(NSString *)amount{
    
    NSInteger amountInteger = [amount integerValue];
    NSString *showStrAmount = @"";
    
    if (amountInteger >0) {

        if (amountInteger >= 10000) {
            NSNumber *amoutFloat = @(amountInteger/10000.0);
//            showStrAmount = [NSString stringWithFormat:@"%.4lf万",amoutFloat];
            showStrAmount = [[self toDisplayNumber:amoutFloat] stringByAppendingString:@"万"];
        }else{
            showStrAmount = [NSString stringWithFormat:@"%ld",amountInteger];
        }
    }
    return showStrAmount;
}

// 有小数显示最多四位小数 没有则不显示
+ (NSString*)toDisplayNumber:(NSNumber *)number
{
    NSString *result = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundFloor];
    [formatter setMinimumFractionDigits:0];
    [formatter setMaximumFractionDigits:4];
    result = [formatter stringFromNumber:number];
    if (result == nil)
        return @"";
    return result;
    
}

+ (BOOL)isUSDTBankModelPublicChain:(DepositsBankModel *)bank {
    if ([bank.payCategory isEqualToString:@"2"] ||
        [bank.payCategory isEqualToString:@"4"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isUSDTOtherBankModel:(DepositsBankModel *)item {
    if ([item.payType isEqualToString:@"25"] && [item.bankcode isEqualToString:@"others"]) {
        return YES;
    }
    return NO;
}

@end
