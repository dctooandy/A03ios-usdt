//
//  IN3SUtility.m
//  IN3SAnalytics
//
//  Created by Key on 2019/2/8.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SUtility.h"
#import "FCUUID.h"
@implementation IN3SUtility

BOOL IN_3S_debug;

+ (void)log:(NSString *)format, ...
{
    if (!IN_3S_debug) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    printf("\n%s\n",[str UTF8String]);
}
+ (NSString *)sessionId
{
    return [FCUUID uuidForSession];
}
+ (NSString *)deviceId
{
    return [FCUUID uuidForDevice];
}
+ (NSString *)timestamp
{
    return [NSString stringWithFormat:@"%.3lf",[[NSDate date] timeIntervalSince1970]];
}
+ (UIViewController*)topMostWindowController
{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    UIViewController *topController = [win rootViewController];
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    while ([topController presentedViewController])  topController = [topController presentedViewController];
    return topController;
}
//获取当前显示的controller
+ (UIViewController*)currentViewController;
{
    UIViewController *currentViewController = [self topMostWindowController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}
@end
