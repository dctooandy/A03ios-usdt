//
//  RedPacketsInfoModel.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/17.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "RedPacketsInfoModel.h"

@implementation RedPacketsInfoModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}
- (BOOL)isRainningTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:[self.serverTimestamp intValue]];
    NSString *stringFromDate = [dateFormatter stringFromDate:serverDate];
    NSString *firstStartHour = [self.firstStartAt substringToIndex:2];
    NSString *secondStartHour = [self.secondStartAt substringToIndex:2];
    int isFirstToSecond = ([secondStartHour intValue] - [firstStartHour intValue]) * 3600;
    int isSecondToFirst = (24 - [secondStartHour intValue] + [firstStartHour intValue]) * 3600;
    if ([self.status isEqualToString:@"1"])
    {
        if ([stringFromDate intValue] < [firstStartHour intValue])
        {
            // 目前时间于第一场红包雨之前
            return NO;
        }else if ([stringFromDate intValue] < [secondStartHour intValue])
        {
            // 介于第一场之后跟第二场之间
            // 剩馀时间 大于等于 第一场跟第二场之间的秒数少60 ,亦即下雨期
            return [self.leftTime intValue] >= (isFirstToSecond - 60);
        }else
        {
            // 处于第二场之后到下一个第一场之间
            // 剩馀时间 大于等于 第二场到下一个第一场之间的秒数少60 ,亦即下雨期
            return [self.leftTime intValue] >= (isSecondToFirst - 60);
        }
    }else
    {
        return NO;
    }
}
@end
