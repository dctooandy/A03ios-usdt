//
//  AgentRecordModel.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/6.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "AgentRecordModel.h"

@implementation ResultItem
@end


@implementation WsQuerySumCount
@end


@implementation AgentCommissionRecord
@end


@implementation AgentRecordModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"result" : [ResultItem class]};
}

@end

