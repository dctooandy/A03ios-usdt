//
//  XmCalcAmountModel.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "XmCalcAmountModel.h"

@implementation XmTypesItem
@end


@implementation XmListItem
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"xmTypes": [XmTypesItem class]};
}
@end


@implementation XmCalcAmountModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"xmList": [XmListItem class]};
}
@end
