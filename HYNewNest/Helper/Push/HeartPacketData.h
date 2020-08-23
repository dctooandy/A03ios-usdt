//
//  HeartPacketData.h
//  A02_iPhone
//
//  Created by Robert on 06/05/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartPacketData : NSObject

/** 心跳包的第一个字段为标志位(1字节)，定义二进制字符串，简单点，最后转成十进制， 其中标志位的1个字节，前三位的位数，第一位为1固定值，第二位，如果为0，新的请求，如果为1带上了服务器返回的UUID 如果服务器返回数据中的这个位数是1代表是uuid的包,第三位0代表未打开客户端，1代表打开客户端，IOS永远为1 */
@property (strong, nonatomic) NSString *flag;

/** 心跳包的第二个字段为包长，也定义二进制字符串，最后转成十进制(1字节) */
@property (strong, nonatomic) NSString *length;

/** 心跳包的第三个字段为包序(1字节)，IOS传1 */
@property (strong, nonatomic) NSString *order;

/** 心跳包的第四个字段，如果没有uuid的话，第四个字段传平台参数(1字节)，IOS传2，如果有uuid的话，不传这个参数，传16字节的uuid */
@property (strong, nonatomic) NSString *platform;

/** 心跳包的第四个字段 服务器返回的uuid (16字节) */
@property (strong, nonatomic) NSData *uuid;

/** 心跳包的第五个字段 anns token (32字节) */
@property (strong, nonatomic) NSData *apnsToken;

/** 心跳包的第六个字段 用户id (4字节) */
@property (assign, nonatomic) int userid;

/** 心跳包的第七个字段 产品id 标志每个产品的唯一标志 如果有uuid的话，该产品id将不传 */
@property (strong, nonatomic) NSString *productId;

/**
 拼接心跳包

 @return 返回拼接好的心跳包 NSData
 */
- (NSData *)spellHeartPacketData;

/**
 处理UUID包 下次发包的时候带上,如果uuid包是全0的话，是错误的uuid包,这个时候把uuid字段置为nil重新请求uuid包，如果不是uuid包的话，就是心跳包，不用处理,
 
 @param data 包数据
 @return YES 正确的UUID包 NO 错误UUID包
 */
- (BOOL)handleUUIDPacketWithSocketData:(NSData *)data;

@end
