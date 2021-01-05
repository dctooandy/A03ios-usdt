//
//  IN3SLaunchModel.m
//  IN3SAnalytics
//
//  Created by Key on 2019/2/11.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SLaunchModel.h"
#import <sys/utsname.h>


@interface IN3SLaunchModel ()
/**
 手机类型,不用设置，由SDK自动生成
 */
@property(nonatomic, copy, readwrite)NSString *phone;
/**
 手机系统,不用设置，由SDK自动生成
 */
@property(nonatomic, copy, readwrite)NSString *os;
/**
 app版本,不用设置，由SDK自动生成
 */
@property(nonatomic, copy, readwrite)NSString *version;


@end
@implementation IN3SLaunchModel
- (IN3SAnalyticsEvent)eventType
{
    return IN3SAnalyticsEventLaunch;
}
-(NSString *)os
{
    if (!_os) {
        _os = [[UIDevice currentDevice] systemName];
    }
    return _os;
}
- (NSString *)version
{
    if (!_version) {
        _version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    return  _version;
}
- (NSString *)phone {
    if (!_phone) {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [self readPrepertyListFile];
        if (dict && [dict valueForKey:platform]) {
            platform = [dict objectForKey:platform];
        }
        _phone = platform;
    }
    
    return _phone;
}

- (NSDictionary *)readPrepertyListFile {
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"IN3SResource.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString * path = [bundle pathForResource:@"DeviceModelsForIOS" ofType:@"plist"];
    if (path != nil && path.length > 0) {
        NSDictionary * dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        return dictionary;
    }else {
        return nil;
    }
}

@end
