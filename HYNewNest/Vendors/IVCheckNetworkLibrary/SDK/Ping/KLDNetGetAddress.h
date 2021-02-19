//
//  KLDNetGetAddress.h
//  KLDNetDiagnoServiceDemo
//
//  Created by ZhangHaiyang on 15-8-5.
//  Copyright (c) 2015年 庞辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KLDNetGetAddress : NSObject

//网络类型
typedef enum {
    KNETWORK_TYPE_NONE = 0,
    KNETWORK_TYPE_2G = 1,
    KNETWORK_TYPE_3G = 2,
    KNETWORK_TYPE_4G = 3,
    KNETWORK_TYPE_5G = 4,  //  5G目前为猜测结果
    KNETWORK_TYPE_WIFI = 5,
} KNETWORK_TYPE;

/*!
 * 获取当前设备ip地址
 */
+ (NSString *)deviceIPAdress;


/*!
 * 获取当前设备网关地址
 */
+ (NSString *)getGatewayIPAddress;


/*!
 * 通过域名获取服务器DNS地址
 */
+ (NSArray *)getDNSsWithDormain:(NSString *)hostName;


/*!
 * 获取本地网络的DNS地址
 */
+ (NSArray *)outPutDNSServers;


/*!
 * 获取当前网络类型
 */
+ (KNETWORK_TYPE)getNetworkTypeFromStatusBar;

/**
 * 格式化IPV6地址
 */
+(NSString *)formatIPV6Address:(struct in6_addr)ipv6Addr;

@end
