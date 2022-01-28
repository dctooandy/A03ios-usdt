//
//  RedPacketsInfoModel.m
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/17.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "RedPacketsInfoModel.h"

@implementation RedPacketsInfoModel
- (BOOL)currentTimeCheckRainningTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:[self.serverTimestamp intValue]];
    NSString *stringFromDate = [dateFormatter stringFromDate:serverDate];
    NSArray * stringFromDateArray = [stringFromDate componentsSeparatedByString:@":"];
    NSArray * firstStartAtArray = [self.firstStartAt componentsSeparatedByString:@":"];
    NSArray * firstEndAtArray = [self.firstEndAt componentsSeparatedByString:@":"];
    NSArray * secondStartAtArray = [self.secondStartAt componentsSeparatedByString:@":"];
    NSArray * secondEndAtArray = [self.secondEndAt componentsSeparatedByString:@":"];
    NSString *serverStartHour = stringFromDateArray.firstObject;
    NSString *serverStartMins = stringFromDateArray[1];
    NSString *serverStartSec = stringFromDateArray.lastObject;
    
    
    NSString *firstStartHour = firstStartAtArray.firstObject;
    NSString *firstStartMins = firstStartAtArray[1];
    NSString *firstStartSec = firstStartAtArray.lastObject;
    
    NSString *firstEndHour = firstEndAtArray.firstObject;
    NSString *firstEndMins = firstEndAtArray[1];
    NSString *firstEndSec = firstEndAtArray.lastObject;
    
    NSString *secondStartHour = secondStartAtArray.firstObject;
    NSString *secondStartMins = secondStartAtArray[1];
    NSString *secondStartSec = secondStartAtArray.lastObject;
    
    NSString *secondEndHour = secondEndAtArray.firstObject;
    NSString *secondEndMins = secondEndAtArray[1];
    NSString *secondEndSec = secondEndAtArray.lastObject;
    
    _nowSeconds = [serverStartHour intValue] * 3600 + [serverStartMins intValue] * 60 + [serverStartSec intValue];
    _firstStartSeconds = [firstStartHour intValue] * 3600 + [firstStartMins intValue] * 60 + [firstStartSec intValue];
    int firstEndSeconds = [firstEndHour intValue] * 3600 + [firstEndMins intValue] * 60 + [firstEndSec intValue];
    
    _secondStartSeconds = [secondStartHour intValue] * 3600 + [secondStartMins intValue] * 60 + [secondStartSec intValue];
    int secondEndSeconds = [secondEndHour intValue] * 3600 + [secondEndMins intValue] * 60 + [secondEndSec intValue];
    
    int isFirstToSecond = _secondStartSeconds - firstEndSeconds;
    _isSecondToFirstSecond = 24 * 3600 - _nowSeconds + _firstStartSeconds;
    if ([self.status isEqualToString:@"1"])
    {
        if (_nowSeconds < _firstStartSeconds)
        {
            // 目前时间于第一场红包雨之前
            return NO;
        }else if (_nowSeconds < _secondStartSeconds)
        {
            if (_nowSeconds < firstEndSeconds)
            {
                //第一场红包雨
                return YES;
            }else
            {
                // 介于第一场之后跟第二场之间
                return NO;
            }
        }else
        {
            if (_nowSeconds < secondEndSeconds)
            {
                //第二场红包雨
                return YES;
            }else
            {
                // 处于第二场之后到下一个第一场之间
                return NO;
            }
        }
    }else
    {
        return NO;
    }
}
- (BOOL)isRainningTime
{
    if (_isDev == YES)
    {
        return [self currentTimeCheckRainningTime];
    }else
    {
        if ([self.firstRainStatus isEqualToString:@"1"] || [self.secondRainStatus isEqualToString:@"1"])
        {
            return YES;
        }else
        {
            return [self currentTimeCheckRainningTime];
        }
    }
}
- (void)setFirstStartAt:(NSString *)firstStartAt
{
    _firstStartAt = firstStartAt;
}
- (void)setFirstEndAt:(NSString *)firstEndAt
{
    _firstEndAt = firstEndAt;
}
- (void)setSecondStartAt:(NSString *)secondStartAt
{
    _secondStartAt = secondStartAt;
}
- (void)setSecondEndAt:(NSString *)secondEndAt
{
    _secondEndAt = secondEndAt;
}

- (NSString *)firstRainStatus
{
    if (_isDev == YES)
    {
        return self.isRainningTime ? @"1":@"2";
    }else
    {
        return _firstRainStatus;
    }
}
- (NSString *)secondRainStatus
{
    if (_isDev == YES)
    {
        return self.isRainningTime ? @"1":@"2";
    }else
    {
        return _secondRainStatus;
    }
}
- (NSString*)leftTime
{
    if (_isDev == YES)
    {
        int firstSecondValue = _nowSeconds - _firstStartSeconds;
        int secondSecondValue = _nowSeconds - _secondStartSeconds;
        return [NSString stringWithFormat:@"%d",firstSecondValue < 0 ? abs(firstSecondValue): (secondSecondValue < 0 ? abs(secondSecondValue): _isSecondToFirstSecond )];
    }else
    {
        return _leftTime;
    }
}
@end
