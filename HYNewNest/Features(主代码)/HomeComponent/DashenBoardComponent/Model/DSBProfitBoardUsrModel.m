//
//  DSBProfitBoardUsrModel.m
//  HYNewNest
//
//  Created by zaky on 1/25/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "DSBProfitBoardUsrModel.h"
#import "VIPRankConst.h"

@implementation PrListItem
- (BOOL)isOnTable {
    NSDate *billTime = [NSDate jk_dateWithString:self.billTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval interval = [billTime timeIntervalSinceNow];
    return fabs(interval) < 60*5; //5分钟内在桌
}
@end


@implementation DSBProfitBoardUsrModel
- (NSString *)writtenLevel {
    if (self.clubLevel > 1) {
        // 返回 私享会等级
        return VIPRankString[self.clubLevel];
    } else {
        // 返回 VIPn
        if (self.customerLevel == 5)
        {
            return @"钻石VIP";
        }else if (self.customerLevel == 6)
        {
            return @"至尊VIP";
        }else
        {
            return [NSString stringWithFormat:@"VIP%ld", self.customerLevel];
        }
    }
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"prList": [PrListItem class]};
}

- (BOOL)isOnTable {
    if (!self.prList.count) {
        return NO;
    }
    PrListItem *item = self.prList[0];
    NSDate *billTime = [NSDate jk_dateWithString:item.billTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval interval = [billTime timeIntervalSinceNow];
    return fabs(interval) < 60*10; //5分钟内在桌
}
@end
