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
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:[self.serverTimestamp intValue]];
    NSString *stringFromDate = [dateFormatter stringFromDate:serverDate];
    NSString *serverStartHour = [stringFromDate substringToIndex:2];
    NSString *serverStartMins = [stringFromDate substringWithRange:NSMakeRange(3, 2)];
    NSString *serverStartSec = [stringFromDate substringWithRange:NSMakeRange(6, 2)];
    
    NSString *firstStartHour = [self.firstStartAt substringToIndex:2];
    NSString *firstStartMins = [self.firstStartAt substringWithRange:NSMakeRange(3, 2)];
    NSString *firstStartSec = [self.firstStartAt substringWithRange:NSMakeRange(6, 2)];
    
    NSString *firstEndHour = [self.firstEndAt substringToIndex:2];
    NSString *firstEndMins = [self.firstEndAt substringWithRange:NSMakeRange(3, 2)];
    NSString *firstEndSec = [self.firstEndAt substringWithRange:NSMakeRange(6, 2)];
    
    NSString *secondStartHour = [self.secondStartAt substringToIndex:2];
    NSString *secondStartMins = [self.secondStartAt substringWithRange:NSMakeRange(3, 2)];
    NSString *secondStartSec = [self.secondStartAt substringWithRange:NSMakeRange(6, 2)];
    
    NSString *secondEndHour = [self.secondEndAt substringToIndex:2];
    NSString *secondEndMins = [self.secondEndAt substringWithRange:NSMakeRange(3, 2)];
    NSString *secondEndSec = [self.secondEndAt substringWithRange:NSMakeRange(6, 2)];
    
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
//        if (([self.leftTime intValue] <= _firstStartSeconds) && _nowSeconds < _firstStartSeconds)
//        {
//            // 目前时间于第一场红包雨之前
//            if ([self.leftTime intValue] == _firstStartSeconds)
//            {
//                return YES;
//            }else
//            {
//                return NO;
//            }
//        }else if ([self.leftTime intValue] <= firstEndSeconds)
//        {
//            //第一场红包雨
//            return YES;
//        }else if ([self.leftTime intValue] <= _secondStartSeconds)
//        {
//            // 介于第一场之后跟第二场之间
//            if ([self.leftTime intValue] == _secondStartSeconds)
//            {
//                return YES;
//            }else
//            {
//                return NO;
//            }
//        }else if ([self.leftTime intValue] <= secondEndSeconds)
//        {
//            //第二场红包雨
//            return YES;
//        }else
//        {
//            // 处于第二场之后到下一个第一场之间
//            return NO;
//        }
    }else
    {
        return NO;
    }
}
- (NSString*)leftTime
{
    if (_isDev)
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
