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
@end


@implementation VIPHomeUserModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"equityData": [EquityDataItem class],
             @"prizeList": [VIPRewardAnocModel class]};
}

@end
