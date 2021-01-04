//
//  IN3SGlobalModel.m
//  IN3SAnalytics
//
//  Created by Key on 2019/2/9.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SGlobalModel.h"
#import "IN3SUtility.h"

@implementation IN3SGlobalModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+(JSONKeyMapper*)keyMapper{
    NSDictionary * map = @{
                           @"sessionId":@"id",
                           @"deviceId":@"device",
                           };
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:map];
}
//唯一约束
+(NSArray *)bg_uniqueKeys{
    return @[@"module"];
}
- (NSString *)sessionId
{
    return [IN3SUtility sessionId];
}
- (NSString *)deviceId
{
    return [IN3SUtility deviceId];
}
- (NSString *)module
{
    return @"app";
}
- (NSString *)domain
{
    return _domain ? : @"";
}
- (NSString *)page
{
    UIViewController *currentVC = [IN3SUtility currentViewController];
    if (currentVC && [currentVC isKindOfClass:[UIViewController class]]) {
        return NSStringFromClass([currentVC class]);
    }
    return @"";
}
- (NSString *)user
{
    return _user ? : @"";
}
@end
