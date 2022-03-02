//
//  KYMWidthdrewUtility.m
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "KYMWidthdrewUtility.h"

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
+ (BOOL)isValidateWithdrawPwdNumber:(NSString *)number{
    NSString *numberRegex = @"^\\d{6,6}$";
    NSPredicate *num = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [num evaluateWithObject:number];
}



@end
