//
//  BetAmountModel.m
//  HYGEntire
//
//  Created by zaky on 04/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "BetAmountModel.h"

@implementation PromoteRebateModel

@end


@implementation BetAmountModel

@end


@implementation platformBalancesItem

@end


NSString * DBName_AccountBalance = @"UserBalances";

@implementation AccountMoneyDetailModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"platformBalances" : [platformBalancesItem class]};
}

- (NSString *)bg_tableName {
    return DBName_AccountBalance;
}

+ (NSArray *)bg_uniqueKeys {
    return @[@"primaryKey"];
}

@end
