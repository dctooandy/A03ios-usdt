//
//  SocketTool.h
//  A02_iPhone
//
//  Created by Robert on 16/03/2018.
//  Copyright © 2018 robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketTool : NSObject
#pragma mark 二进制字符串转十进制字符串
/**
 二进制字符串转十进制字符串
 
 @param binary 二进制字符串
 @return 十进制整型
 */
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;

#pragma mark 二进制字符串转十进制Byte
/**
 二进制字符串转十进制Byte
 
 @param binary 二进制字符串
 @return 十进制的Byte
 */
+ (Byte)toDecimalByteWithBinarySystem:(NSString *)binary;

#pragma mark byte转NSSData
/**
 byte转NSSData
 
 @param byte byte
 @param length 长度
 @return NSData
 */
+ (NSData *)byteToString:(Byte *)byte length:(int)length;

#pragma mark byte转int
/**
 byte转int
 
 @param byte byte字艺
 @return int
 */
+ (int)byteToInt:(Byte[]) byte;

#pragma mark 判断字符串是否为空
/**
 *  判断字符串是否为空
 *
 *  @param string 原字符串
 *
 *  @return BOOL 返回真字符串为空，否不为空
 */
+ (BOOL)isBlankString:(NSString *)string;
@end
