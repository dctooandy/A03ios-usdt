//
//  SCMyBonusModel.m
//  HYNewNest
//
//  Created by zaky on 12/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "SCMyBonusModel.h"
#import "VIPRankConst.h"

@implementation MyBonusResultItem
- (NSString *)upLevelStr {
    if ([self.upType isEqualToString:@"CLUB_LEVEL"]) {
        return VIPRankString[self.upLevel];
    } else {
        return [NSString stringWithFormat:@"VIP%ld", (long)self.upLevel];
    }
}
@end

@implementation SCMyBonusModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"result": [MyBonusResultItem class]};
}

@end
