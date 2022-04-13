//
//  BYMyBounsModel.m
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "BYMyBounsModel.h"

@implementation BYMyBounsModel
- (NSString *)shortCreatedDate {
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    serverDateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *serverDate = [serverDateFormatter dateFromString:_createdDate];
    
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    localDateFormatter.dateFormat = @"YYYY年MM月dd日";
    
    return [localDateFormatter stringFromDate:serverDate];
}
- (NSString *)shortMaturityDate {
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    serverDateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *serverDate = [serverDateFormatter dateFromString:_maturityDate];
    
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    localDateFormatter.dateFormat = @"YYYY年MM月dd日";
    
    return [localDateFormatter stringFromDate:serverDate];
}
@end
