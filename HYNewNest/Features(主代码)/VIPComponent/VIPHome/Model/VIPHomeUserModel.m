//
//  VIPHomeUserModel.m
//  HYNewNest
//
//  Created by zaky on 9/10/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPHomeUserModel.h"

@implementation HistoryBet
@end


@implementation EquityDataItem
- (NSNumber*)depositCNYAmount
{
    return [NSNumber numberWithInt:(_depositAmount.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)betCNYAmount
{
    return [NSNumber numberWithInt:(_betAmount.intValue * CnyAndUsdtdDepositRate)];
}
- (NSNumber*)ydfhCnyAmount
{
    return [NSNumber numberWithInt:(_ydfhAmount.intValue * CnyAndUsdtRate)];
}
- (NSNumber*)rhljCnyAmount
{
    return [NSNumber numberWithInt:(_rhljAmount.intValue * CnyAndUsdtRate)];
}
@end


@implementation VIPHomeUserModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"equityData": [EquityDataItem class],
             @"prizeList": [VIPRewardAnocModel class]};
}

@end
