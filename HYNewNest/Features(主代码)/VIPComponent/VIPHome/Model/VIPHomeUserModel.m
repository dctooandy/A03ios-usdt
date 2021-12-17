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
- (NSNumber*)ydfhCnyAmount
{
    return [NSNumber numberWithInt:(_ydfhAmount.intValue * 7)];
}
- (NSNumber*)rhljCnyAmount
{
    return [NSNumber numberWithInt:(_rhljAmount.intValue * 7)];
}
@end


@implementation VIPHomeUserModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"equityData": [EquityDataItem class],
             @"prizeList": [VIPRewardAnocModel class]};
}

@end
