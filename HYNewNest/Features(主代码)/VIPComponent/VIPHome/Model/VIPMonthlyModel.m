//
//  VIPMonthlyModel.m
//  HYNewNest
//
//  Created by zaky on 9/10/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPMonthlyModel.h"

@implementation VipRhqk
- (NSNumber*)depositCNYAmount
{
    return [NSNumber numberWithInt:(_depositAmount.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)betCNYAmount
{
    return [NSNumber numberWithInt:(_betAmount.intValue * CnyAndUsdtdDepositRate)];
}
@end


@implementation VipScjz
- (NSNumber*)ljscCNY
{
    return [NSNumber numberWithInt:(_ljsc.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)ljsfCNY
{
    return [NSNumber numberWithInt:(_ljsf.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)rhljCNY
{
    return [NSNumber numberWithInt:(_rhlj.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)ydfhCNY
{
    return [NSNumber numberWithInt:(_ydfh.intValue * CnyAndUsdtdDepositRate)];
}
@end


@implementation VIPMonthlyModel

- (NSNumber*)totalDepositCNYAmount
{
    return [NSNumber numberWithInt:(_totalDepositAmount.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)totalBetCNYAmount
{
    return [NSNumber numberWithInt:(_totalBetAmount.intValue * CnyAndUsdtdDepositRate)];
}
@end
