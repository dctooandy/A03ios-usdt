//
//  NSDictionary+KYC.m
//  KYCommon
//
//  Created by Key on 13/05/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import "NSDictionary+IVN.h"

@implementation NSDictionary (IVN)
- (BOOL)IVNIsAvailable
{
    if (self == nil || self == NULL){
        return NO;
    }
    if ([self isKindOfClass:[NSNull class]]){
        return NO;
    }
    if (![self isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if (self.count == 0){
        return NO;
    }
    return YES;
}
- (NSData *)IVNToData
{
    if (![self IVNIsAvailable]) {
        return nil;
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }
    return data;
}
- (NSString *)IVNToJSONString
{
    if (![self IVNIsAvailable]) {
        return nil;
    }
    NSString *emptyStr = @"IVEmptyString";
    NSMutableDictionary *tempDict = self.mutableCopy;
    for (int i = 0; i < self.allKeys.count; i++) {
        id key = self.allKeys[i];
        id value = self[key];
        if ([value isKindOfClass:[NSString class]] && [value containsString:@" "]) {
            tempDict[key] = [tempDict[key] stringByReplacingOccurrencesOfString:@" " withString:emptyStr];
        }
    }
    
    NSData *data = [tempDict IVNToData];
    
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if ([string containsString:emptyStr]) {
        string = [string stringByReplacingOccurrencesOfString:emptyStr withString:@" "];
    }
    return string;
}
@end
