//
//  NSDateFormatter+BYDateFormatter.m
//  HYNewNest
//
//  Created by RM04 on 2021/8/11.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "NSDateFormatter+BYDateFormatter.h"

@implementation NSDateFormatter (BYDateFormatter)
- (NSString *)monthOfFirstDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    [components setDay:1];

    return [self stringFromDate:[calendar dateFromComponents:components]];
}
- (NSString *)monthOfEndDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    [components setDay:dayRange.length];

    return [self stringFromDate:[calendar dateFromComponents:components]];
    
}
@end
