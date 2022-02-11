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
    return [NSNumber numberWithInt:(_depositAmount.intValue * CnyAndUsdtRate)];
}
- (NSNumber*)betCNYAmount
{
    return [NSNumber numberWithInt:(_betAmount.intValue * CnyAndUsdtRate)];
}
@end


@implementation VipScjz
- (NSNumber*)ljscCNY
{
    return [NSNumber numberWithInt:(_ljsc.intValue * CnyAndUsdtRate)];
}
- (NSNumber*)ljsfCNY
{
    return [NSNumber numberWithInt:(_ljsf.intValue * CnyAndUsdtRate)];
}
- (NSNumber*)rhljCNY
{
    return [NSNumber numberWithInt:(_rhlj.intValue * CnyAndUsdtRate)];
}
- (NSNumber*)ydfhCNY
{
    return [NSNumber numberWithInt:(_ydfh.intValue * CnyAndUsdtRate)];
}
@end


@implementation VIPMonthlyModel

- (NSNumber*)totalDepositCNYAmount
{
    return [NSNumber numberWithInt:(_totalDepositAmount.intValue * CnyAndUsdtRate)];
}
- (NSNumber*)totalBetCNYAmount
{
    return [NSNumber numberWithInt:(_totalBetAmount.intValue * CnyAndUsdtRate)];
}
@end
