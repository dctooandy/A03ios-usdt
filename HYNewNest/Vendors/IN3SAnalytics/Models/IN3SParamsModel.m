//
//  IN3SParamsModel.m
//  IN3SAnalytics
//
//  Created by Key on 2019/2/9.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SParamsModel.h"

@interface IN3SParamsModel()

@end
@implementation IN3SParamsModel

//唯一约束
//+(NSArray *)bg_uniqueKeys{
//    return @[@"eventKey"];
//}

/**
 忽略存储的键
 */
+ (NSArray *)bg_ignoreKeys
{
    return @[@"eventType",@"description"];
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
- (NSString *)eventKey
{
    NSString *key = nil;
    switch (self.eventType) {
        case IN3SAnalyticsEventLaunch:
            key = kConstantEventTypeLaunch;
            break;
        case IN3SAnalyticsEventPage:
            key = kConstantEventTypePage;
            break;
        case IN3SAnalyticsEventRequest:
            key = kConstantEventTypeRequest;
            break;
        case IN3SAnalyticsEventBrowser:
            key = kConstantEventTypeBrowser;
            break;
        case IN3SAnalyticsEventAGQJ:
            key = kConstantEventTypeAGQJ;
            break;
        case IN3SAnalyticsEventExit:
            key = kConstantEventTypeExit;
            break;
        default:
            break;
    }
    return key;
}

@end
