//
//  SCMyRebateModel.m
//  HYNewNest
//
//  Created by zaky on 4/20/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "SCMyRebateModel.h"

@implementation MyRebateResultItem
- (NSString *)upLevelStr {
    return [NSString stringWithFormat:@"VIP%ld", (long)self.customerLevel];
}
@end

@implementation SCMyRebateModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"result": [MyRebateResultItem class]};
}

@end
