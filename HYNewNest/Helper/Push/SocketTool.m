//
//  SocketTool.m
//  A02_iPhone
//
//  Created by Robert on 16/03/2018.
//  Copyright © 2018 robert. All rights reserved.
//

#import "SocketTool.h"

@implementation SocketTool
#pragma mark 二进制字符串转十进制字符串
/**
 二进制字符串转十进制字符串
 
 @param binary 二进制字符串
 @return 十进制整型
 */
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary {
    int decimal = 0;
    int tempDecimal = 0;
    for (int i = 0; i < binary.length; i ++ ) {
        tempDecimal = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        tempDecimal  = tempDecimal * powf(2, binary.length - i -1);
        decimal += tempDecimal;
    }
    NSString *result = [NSString stringWithFormat:@"%d",tempDecimal];
    return result;
}

#pragma mark 二进制字符串转十进制Byte
/**
 二进制字符串转十进制Byte
 
 @param binary 二进制字符串
 @return 十进制的Byte
 */
+ (Byte)toDecimalByteWithBinarySystem:(NSString *)binary {
    int decimal = 0;
    int tempDecimal = 0;
    for (int i = 0; i < binary.length; i ++ ) {
        tempDecimal = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        tempDecimal  = tempDecimal * powf(2, binary.length - i -1);
        decimal += tempDecimal;
    }
    Byte  byte = (Byte)(0XFF & decimal);
    return byte;
}

#pragma mark byte转NSSData
/**
 byte转NSSData
 
 @param byte byte
 @param length 长度
 @return NSData
 */
+ (NSData *)byteToString:(Byte *)byte length:(int)length {
    NSData *data = [[NSData alloc] initWithBytes:byte length:length];
    return data;
}

#pragma mark byte转int
/**
 byte转int
 
 @param byte byte字艺
 @return int
 */
+ (int)byteToInt:(Byte[]) byte {
    int height = 0;
    NSData * testData =[NSData dataWithBytes:byte length:4];
    for (int i = 0; i < [testData length]; i++) {
        if (byte[[testData length]-i] >= 0) {
            height = height + byte[[testData length]-i];
        }
        else {
            height = height + 256 + byte[[testData length]-i];
        }
        height = height * 256;
    }
    if (byte[0] >= 0) {
        height = height + byte[0];
    }
    else {
        height = height + 256 + byte[0];
    }
    return height;
}

#pragma mark 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

@end
