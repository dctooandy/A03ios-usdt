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
    return [NSNumber numberWithInt:(_depositAmount.intValue * 7)];
}
- (NSNumber*)betCNYAmount
{
    return [NSNumber numberWithInt:(_betAmount.intValue * 7)];
}
@end


@implementation VipScjz
- (NSNumber*)ljscCNY
{
    return [NSNumber numberWithInt:(_ljsc.intValue * 7)];
}
- (NSNumber*)ljsfCNY
{
    return [NSNumber numberWithInt:(_ljsf.intValue * 7)];
}
- (NSNumber*)rhljCNY
{
    return [NSNumber numberWithInt:(_rhlj.intValue * 7)];
}
- (NSNumber*)ydfhCNY
{
    return [NSNumber numberWithInt:(_ydfh.intValue * 7)];
}
@end


@implementation VIPMonthlyModel

- (NSNumber*)totalDepositCNYAmount
{
    return [NSNumber numberWithInt:(_totalDepositAmount.intValue * 7)];
}
- (NSNumber*)totalBetCNYAmount
{
    return [NSNumber numberWithInt:(_totalBetAmount.intValue * 7)];
}
@end
