//
//  WithdrawCalculateModel.m
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "WithdrawCalculateModel.h"

@implementation CanWithdrawInfoItem
@end


@implementation PromoInfo
@end


@implementation WithdrawCalculateModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"canWithdrawInfo":[CanWithdrawInfoItem class]};
}

@end
