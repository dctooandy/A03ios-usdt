//
//  IVOtherInfoModel.m
//  SuperSignSupport
//
//  Created by key.l on 17/10/2019.
//  Copyright © 2019 key.l. All rights reserved.
//

#import "IVOtherInfoModel.h"

@implementation IVOtherInfoModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.undefinedKeyDict = @{}.mutableCopy;
        NSDictionary *otherInfoDict = @{};
        NSString *path = [[NSBundle mainBundle] pathForResource:@"otherInfo.json" ofType:nil];
        if (path) {
            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            if (data) {
                id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    otherInfoDict = obj;
                }
            }
        }
        [self setValuesForKeysWithDictionary:otherInfoDict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    self.undefinedKeyDict[key] = value;
}
- (void)setSignParam:(id)signParam
{
    _signParam = signParam;
    if ([signParam isKindOfClass:[NSString class]]) {
        _signParamString = signParam;
    } else if ([signParam isKindOfClass:[NSDictionary class]]) {
        _signParamString = [self dictToJSONString:signParam];
    }
    if (_signParamString) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"=',:@#%^{}\"[]|\\<>"].invertedSet;
        _signParamString = [_signParamString stringByAddingPercentEncodingWithAllowedCharacters:set];
    } else {
        _signParamString = @"";
    }
}
- (NSString *)dictToJSONString:(NSDictionary *)dict
{

    NSString *emptyStr = @"IVEmptyString";
    NSMutableDictionary *tempDict = dict.mutableCopy;
    for (int i = 0; i < dict.allKeys.count; i++) {
        id key = dict.allKeys[i];
        id value = dict[key];
        if ([value isKindOfClass:[NSString class]] && [value containsString:@" "]) {
            tempDict[key] = [tempDict[key] stringByReplacingOccurrencesOfString:@" " withString:emptyStr];
        }
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return @"";
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if ([string containsString:emptyStr]) {
        string = [string stringByReplacingOccurrencesOfString:emptyStr withString:@" "];
    }
    return string;
}
@end
