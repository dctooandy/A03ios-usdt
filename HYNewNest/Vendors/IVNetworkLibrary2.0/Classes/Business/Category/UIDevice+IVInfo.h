//
//  UIDevice+IVInfo.h
//  HybirdApp
//
//  Created by Robert on 30/06/2017.
//  Copyright © 2017 harden-imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (IVInfo)
#pragma mark 获取iphone名称
+ (NSString *)iPhoneName;

#pragma 手机系统版本
+ (NSString *)systemVersion;

#pragma mark 手机系统名称
+ (NSString *)systemName;

#pragma mark mac 地址
+ (NSString*)macAddress;

// 获取设备IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

// 每次运行应用都会变
+(NSString *)uuid;

//changes each time (no persistent), but allows to keep in memory more temporary uuids
+(NSString *)uuidForKey:(id<NSCopying>)key;

// 每次运行应用都会变
+(NSString *)uuidForSession;

// 重新安装的时候会变
+(NSString *)uuidForInstallation;

// 卸载后重装会变
+(NSString *)uuidForVendor;

// 抹掉iPhone的时候才会变，适合做唯一标识
+(NSString *)uuidForDevice;

+ (NSString *)carrierName;

#pragma mark App版本号
+ (NSString *)appVersion;
+ (NSString *)buildVersion;
// app名称
+ (NSString *)getAppName;
//是否越狱
+ (BOOL)isJailBreak;

// 网络类型
+ (NSString *)networkType;

// 总内存
+ (double)totalMemorySize;

// 可用内存
+ (double)availabaleMemorySize;

// APP使用内存
+ (double)usedMemory;
//获取网速,单位kb
+ (void)getCurrentBytesCompletion:(void(^)(CGFloat))completion;
@end
