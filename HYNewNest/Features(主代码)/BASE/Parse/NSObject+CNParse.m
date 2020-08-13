//
//  NSObject+CNParse.m
//  LCNewApp
//
//  Created by cean.q on 2019/11/19.
//  Copyright © 2019 B01. All rights reserved.
//

#import "NSObject+CNParse.h"

@implementation NSObject (CNParse)

+ (id)cn_parse:(id)JSON {
    if ([JSON isKindOfClass:[NSArray class]]) {
        return [NSArray yy_modelArrayWithClass:[self class] json:JSON];
    }
    if ([JSON isKindOfClass:[NSData class]] || [JSON isKindOfClass:[NSDictionary class]] || [JSON isKindOfClass:[NSString class]]) {
        return [self yy_modelWithJSON:JSON];
    }
    return JSON;
}
@end
