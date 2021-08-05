//
//  AnnounceModel.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/21.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "AnnounceModel.h"

@implementation AnnounceModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"announceID":@"id"};
}

- (BOOL)isRead {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *announceDate = [formatter dateFromString:self.createDate];
    //两天内
    NSDate *currentDate = [[NSDate date] dateByAddingTimeInterval:-60 * 60 * 24 * 2];
    return [announceDate earlierDate:currentDate];
}

@end
