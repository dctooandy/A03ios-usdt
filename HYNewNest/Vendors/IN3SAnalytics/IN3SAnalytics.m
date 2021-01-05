//
//  IN3SAnalytics.m
//  IN3SAnalytics
//
//  Created by Key on 2019/2/8.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SAnalytics.h"
#import "IN3SManager.h"

@implementation IN3SAnalytics
+ (void)configureSDKWithProduct:(NSString *)product
{
    [[IN3SManager shareManager] configureSDKWithProduct:product];
}
+ (void)setDomain:(NSString *)domain
{
    [IN3SManager shareManager].domain = domain;
}
+ (void)setUserName:(NSString *)userName
{
    [IN3SManager shareManager].userName = userName;
}
+ (void)debugEnable:(BOOL)enable
{
    extern BOOL IN_3S_debug;
    IN_3S_debug = enable;
}
+ (void)triggerEventWithParameter:(IN3SParamsModel *)parameter timestamp:(NSString *)timestamp
{
    [[IN3SManager shareManager] triggerEventWithParameter:parameter timestamp:timestamp];
}
+ (void)launchFinished
{
    [[IN3SManager shareManager] launchFinished];
}
+ (void)exitApp
{
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    [[IN3SManager shareManager] exitApp:timestamp];
}
+ (void)enterPageWithName:(NSString *)pageName responseTime:(double)resTime timestamp:(NSString *)timestamp
{
    [[IN3SManager shareManager] enterPageWithName:pageName responseTime:resTime timestamp:timestamp];
}
+ (void)loadWebViewWithUrl:(NSString *)url responseTime:(double)resTime responseCode:(int)resCode msg:(NSString *)msg timestamp:(NSString *)timestamp
{
    [[IN3SManager shareManager] loadWebViewWithUrl:url responseTime:resTime responseCode:resCode msg:msg timestamp:timestamp];
}
+ (void)requestWithUrl:(NSString *)url responseTime:(double)resTime responseCode:(int)resCode msg:(NSString *)msg timestamp:(NSString *)timestamp
{
    [[IN3SManager shareManager] requestWithUrl:url responseTime:resTime responseCode:resCode msg:msg timestamp:timestamp];
}
+ (void)loadAGQJWithResponseTime:(double)resTime loadFinish:(BOOL)loadFinish msg:(NSString *)msg timestamp:(NSString *)timestamp
{
    // isFinishedPreload 参数后台废弃了，但是isPreload 代表的是 isFinishedPreload 参数，后台埋的坑
    [[IN3SManager shareManager] loadAGQJWithResponseTime:resTime isPreload:loadFinish isFinishedPreload:NO msg:msg timestamp:timestamp];
}
@end
