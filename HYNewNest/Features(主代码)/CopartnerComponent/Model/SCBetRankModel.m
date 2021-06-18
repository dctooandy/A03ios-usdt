//
//  SCBetRankModel.m
//  HYNewNest
//
//  Created by zaky on 12/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "SCBetRankModel.h"

@implementation BetRankResultItem
@end


@implementation SCBetRankModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"result" : [BetRankResultItem class]};
}
@end
