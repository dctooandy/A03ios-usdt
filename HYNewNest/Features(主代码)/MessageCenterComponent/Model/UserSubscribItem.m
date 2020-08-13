//
//  UserSubscribItem.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/24.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "UserSubscribItem.h"

@implementation UserSubscribItem

- (NSString *)name {
    NSDictionary *newName = @{@"PROMOTION":@"红利",
                              @"DEPOSIT":@"充值",
                              @"WITHDRAW":@"提现",
                              @"MODIFY_BANKCARD":@"修改收款地址"};
    if ([newName.allKeys containsObject:self.code]) {
        return newName[self.code];
    } else {
        return _name;
    }
}

@end
