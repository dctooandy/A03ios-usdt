//
//  UIDevice+IVInfo.m
//  HybirdApp
//
//  Created by Robert on 30/06/2017.
//  Copyright © 2017 harden-imac. All rights reserved.
//

#import "UIDevice+IVInfo.h"
#import <sys/utsname.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <mach/mach.h>
#import <FCUUID/FCUUID.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AFNetworking/AFNetworking.h>

@implementation UIDevice (IVInfo)
#pragma mark 获取iphone名称
+ (NSString *)iPhoneName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSDictionary * dict = [self readPrepertyListFile];
    if (dict && [dict valueForKey:platform]) {
        platform = [dict objectForKey:platform];
    }
    return platform;
}

+ (NSDictionary *)readPrepertyListFile {
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"DeviceModelsForIOS" ofType:@"plist"];
    if (path != nil && path.length > 0) {
        NSDictionary * dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        return dictionary;
    }else {
        return nil;
    }
}

#pragma 手机系统版本
+ (NSString *)systemVersion{
    return [UIDevice currentDevice].systemVersion;
}

#pragma mark 手机系统名称
+ (NSString *)systemName{
    return [[UIDevice currentDevice]systemName];
}

#pragma mark mac 地址
+ (NSString*)macAddress{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    mgmtInfoBase[0] = CTL_NET;
    mgmtInfoBase[1] = AF_ROUTE;
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;
    mgmtInfoBase[4] = NET_RT_IFLIST;
    
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) {
        errorFlag = @"if_nametoindex failure";
    }else{
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) {
            errorFlag = @"sysctl mgmtInfoBase failure";
        }else{
            if ((msgBuffer = malloc(length)) == NULL){
                errorFlag = @"buffer allocation failure";
            }else{
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0){
                    errorFlag = @"sysctl msgBuffer failure";
                }
            }
        }
    }
    
    if (errorFlag != NULL){
        free(msgBuffer);
        return errorFlag;
    }
    
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    free(msgBuffer);
    
    return macAddressString;
}

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark uuid
// 每次运行应用都会变
+(NSString *)uuid {
    return [FCUUID uuid];
}

//changes each time (no persistent), but allows to keep in memory more temporary uuids
+(NSString *)uuidForKey:(id<NSCopying>)key {
    return [FCUUID uuidForKey:key];
}

// 每次运行应用都会变
+(NSString *)uuidForSession {
    return [FCUUID uuidForSession];
}

// 重新安装的时候会变
+(NSString *)uuidForInstallation {
    return [FCUUID uuidForInstallation];
}

// 卸载后重装会变
+(NSString *)uuidForVendor {
    return [FCUUID uuidForVendor];
}

// 抹掉iPhone的时候才会变，适合做唯一标识
+(NSString *)uuidForDevice {
    return [FCUUID uuidForDevice];
}

#pragma mark App版本号
+ (NSString *)appVersion{
    return  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
+ (NSString *)buildVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)carrierName {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    return [carrier carrierName];
}

+ (NSString *)networkType {
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"wifi";
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"wan";
        case AFNetworkReachabilityStatusNotReachable:
            return @"notReachable";
        default:
            return @"unkown";
    }
}

+ (double)totalMemorySize {
    return [NSProcessInfo processInfo].physicalMemory / 1024.0 / 1024.0;
}

+ (double)availabaleMemorySize {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count)) / 1024.0 / 1024.0;
}

+ (double)usedMemory {
    
    task_basic_info_data_t taskInfo;
    
    mach_msg_type_number_t infoCount =TASK_BASIC_INFO_COUNT;
    
    kern_return_t kernReturn =task_info(mach_task_self(),
                                        
                                        TASK_BASIC_INFO,
                                        
                                        (task_info_t)&taskInfo,
                                        
                                        &infoCount);
    
    
    
    if (kernReturn != KERN_SUCCESS
        
        ) {
        
        return NSNotFound;
        
    }
    
    
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+ (NSString *)getAppName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}

+ (BOOL)isJailBreak {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
        NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
        NSLog(@"appList = %@", appList);
        return YES;
    }
    NSArray *jailbreak_tool_paths = @[
                                      @"/Applications/Cydia.app",
                                      @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                      @"/bin/bash",
                                      @"/usr/sbin/sshd",
                                      @"/etc/apt"
                                      ];
    for (int i=0; i<jailbreak_tool_paths.count; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreak_tool_paths[i]]) {
            return YES;
        }
    }
    return NO;
}
//获取网速
+ (void)getCurrentBytesCompletion:(void(^)(CGFloat))completion
{
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    long long startFlowValue = [self getDeviceCurrentBytesCount];
    
    //两次流量需要时间差，不然间隔太小获取值一样
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
        long long endFlowValue = [weakSelf getDeviceCurrentBytesCount];
        // 两次差值
        CGFloat value = (endFlowValue - startFlowValue) / (endTime - startTime);
        if (completion) {
            completion(value / 1024);
        }
    });
}

+ (long long)getDeviceCurrentBytesCount
{
    struct ifaddrs* addrs;
    const struct ifaddrs* cursor;
    
    long long currentBytesValue = 0;
    
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        while (cursor != NULL) {
            const struct if_data* ifa_data = (struct if_data*)cursor->ifa_data;
            if (ifa_data) {
                // total number of octets received
                int receivedData = ifa_data->ifi_ibytes;
                
                currentBytesValue += receivedData;
            }
            cursor = cursor->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return currentBytesValue;
}
@end
