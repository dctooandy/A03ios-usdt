//
//  DSBGameRoundResModel.m
//  HYNewNest
//
//  Created by zaky on 1/26/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "DSBGameRoundResModel.h"

@implementation RoundResItem

@end


@implementation RoundPushModel
- (RoundResItem *)makeRoundResItem {
    RoundResItem *item = [RoundResItem new];
    item.player_val = self.player_val;
    item.banker_val = self.banker_val;
    item.timestamp = self.timestamp;
    item.pair = self.pair;
    item.card_num = self.card_num;
    return item;
}
@end


NSString *DBName_DSBGameRoundResults = @"DSBGameRoundResults";

@implementation DSBGameRoundResModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"roundRes" : [RoundResItem class]};
}

+ (NSArray *)bg_unionPrimaryKeys {
    return @[@"vid"];
}

- (NSString *)bg_tableName {
    return DBName_DSBGameRoundResults;
}

@end
