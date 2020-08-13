//
//  XmPlatformModel.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "XmPlatformModel.h"

@implementation XmPlatformListItem


@end

@implementation XmPlatformModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"xmPlatformList":[XmPlatformListItem class]};
}

@end
