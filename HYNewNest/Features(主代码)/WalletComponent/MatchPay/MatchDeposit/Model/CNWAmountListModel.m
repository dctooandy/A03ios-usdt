//
//  CNWAmountListModel.m
//  HYNewNest
//
//  Created by cean on 2/26/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNWAmountListModel.h"

@implementation CNWAmountListModel


@end


@implementation CNWFastPayModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"amountList" : [CNWAmountListModel class]
    };
}
@end
