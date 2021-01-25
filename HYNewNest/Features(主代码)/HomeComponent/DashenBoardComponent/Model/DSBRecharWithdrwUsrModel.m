//
//  DSBRecharWithdrwUsrModel.m
//  HYNewNest
//
//  Created by zaky on 12/8/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBRecharWithdrwUsrModel.h"
#import "VIPRankConst.h"

@implementation DSBRecharWithdrwUsrModel

- (NSString *)writtenLevel {
    if (self.clubLevel > 1) {
        // 返回 私享会等级
        return VIPRankString[self.clubLevel];
    } else {
        // 返回 VIPn
        return [NSString stringWithFormat:@"VIP%ld", self.customerLevel];
    }
}

- (NSString *)writtenTime {
    if (self.lastDepositDate) {
        return [self.lastDepositDate componentsSeparatedByString:@" "].lastObject;
    } else {
        return [self.lastWithdrawalDate componentsSeparatedByString:@" "].lastObject;
    }
}

@end


@implementation DSBWeekMonthModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"xm" : [DSBRecharWithdrwUsrModel class],
         @"dbyl" : [DSBRecharWithdrwUsrModel class],
         @"cz" : [DSBRecharWithdrwUsrModel class],
         @"ljyl" : [DSBRecharWithdrwUsrModel class],
         @"tx" : [DSBRecharWithdrwUsrModel class]
    };
}
@end
