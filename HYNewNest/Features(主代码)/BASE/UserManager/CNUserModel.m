//
//  CNUserModel.m
//  LCNewApp
//
//  Created by cean.q on 2019/11/25.
//  Copyright © 2019 B01. All rights reserved.
//

#import "CNUserModel.h"
@implementation SamePhoneLoginNameItem

@end

@implementation SamePhoneLoginNameModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"samePhoneLoginNames":[SamePhoneLoginNameItem class], @"loginNames":[SamePhoneLoginNameItem class]};
}

@end

@implementation CNUserModel
kHYCodingDesc
+ (BOOL)supportsSecureCoding {
    return true;
}
@end
