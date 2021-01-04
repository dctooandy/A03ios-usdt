//
//  IN3SUtility.h
//  IN3SAnalytics
//
//  Created by Key on 2019/2/8.
//  Copyright © 2019年 Key. All rights reserved.
//

#define INLog(format, ...) [IN3SUtility log:(format), ##__VA_ARGS__]

#import <UIKit/UIKit.h>

@interface IN3SUtility : NSObject
+ (void)log:(NSString *)format, ...;
+ (NSString *)sessionId;
+ (NSString *)deviceId;
+ (NSString *)timestamp;
//获取当前显示的controller
+ (UIViewController*)currentViewController;
@end

