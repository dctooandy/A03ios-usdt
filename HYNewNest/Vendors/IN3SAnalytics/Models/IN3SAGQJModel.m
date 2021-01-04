//
//  IN3SAGQJModel.m
//  IN3SAnalytics
//
//  Created by Key on 2019/2/11.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SAGQJModel.h"

@implementation IN3SAGQJModel
- (IN3SAnalyticsEvent)eventType
{
    return IN3SAnalyticsEventAGQJ;
}
- (NSString *)uuid
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kConstantKeyWebViewUUID];
}
@end
