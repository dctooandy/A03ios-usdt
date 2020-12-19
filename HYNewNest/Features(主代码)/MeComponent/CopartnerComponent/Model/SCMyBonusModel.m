//
//  SCMyBonusModel.m
//  HYNewNest
//
//  Created by zaky on 12/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "SCMyBonusModel.h"

@implementation MyBonusResultItem

@end

@implementation SCMyBonusModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"result": [MyBonusResultItem class]};
}

@end
