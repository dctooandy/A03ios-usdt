//
//  BaseModel.m
//  MLinkTeacher
//
//  Created by liurg on 17/4/9.
//  Copyright © 2017年 MLink. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

// 所有属性都为可选
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
