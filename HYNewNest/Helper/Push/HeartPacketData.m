//
//  HeartPacketData.m
//  A02_iPhone
//
//  Created by Robert on 06/05/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import "HeartPacketData.h"
#import "SocketTool.h"
@implementation HeartPacketData

- (id)init {
    self = [super init];
    if (self) {
        _flag = @"10100000";
        _length = @"00000001";
        _order = @"00000001";
        _platform = @"00000010";
        _userid = 0;
        _uuid = nil;
        _apnsToken = nil;
    }
    return self;
}

/**
 拼接心跳包
 
 @return 返回拼接好的心跳包 NSData
 */
- (NSData *)spellHeartPacketData {
    
    if (self.uuid) {
        self.flag = @"11100000";
    }
    else{
        self.flag = @"10100000";
    }
    
    Byte  flagByte = [SocketTool toDecimalByteWithBinarySystem:_flag];
    Byte  lengthByte = [SocketTool toDecimalByteWithBinarySystem:_length];
    Byte  orderByte = [SocketTool toDecimalByteWithBinarySystem:_order];
    Byte  platformByte = [SocketTool toDecimalByteWithBinarySystem:_platform];
    
    NSMutableData *sendData = [[NSMutableData alloc] init];
    // 追加标志位数据
    [sendData appendBytes:&flagByte length:1];
    // 追加长度数据
    [sendData appendBytes:&lengthByte length:1];
    // 追加包序数据
    [sendData appendBytes:&orderByte length:1];
    if (!self.uuid){
        // 如果没有uuid追加平台数据
        [sendData appendBytes:&platformByte length:1];
    }
    else{
        // 如果有uuid追加uuid数据
        [sendData appendData:self.uuid];
    }
    // 追加apnsToken数据
    [sendData appendData:self.apnsToken];
    
    // 追加用户id数据
    int userid = self.userid;
    NSData *userData = [NSData dataWithBytes:&userid length: sizeof(userid)];
    [sendData appendData:userData];
    
    // 如果没有uuid的话，一定要带上产品id 如果有uuid的话，就不传产品id
    if (!self.uuid && ![SocketTool isBlankString:self.productId]) {
        NSData *data = [self.productId dataUsingEncoding:NSUTF8StringEncoding];
        [sendData appendData:data];
    }
    
    // 取掉前三位的标志位字节，剩余的是数据长度
    int len = (int)sendData.length - 3;
    lengthByte = (Byte)(0XFF & len);
    
    // 替换包长字节的数据
    [sendData replaceBytesInRange:NSMakeRange(1, 1) withBytes:&lengthByte length:1];
    return sendData;
}

/**
 处理UUID包 下次发包的时候带上,如果uuid包是全0的话，是错误的uuid包,这个时候把uuid字段置为nil重新请求uuid包，如果不是uuid包的话，就是心跳包，不用处理,
 
 @param data 包数据
 @return YES 正确的UUID包 NO 错误UUID包
 */
- (BOOL)handleUUIDPacketWithSocketData:(NSData *)data {
    Byte *byte = (Byte *)[data bytes];
    Byte *uuid = malloc(16);
    // 从第四个字节开始取uuid，因为uuid是第四个字节开始的
    if (data.length == 19) {
        memcpy(uuid, &byte[3], 16);
        self.uuid = [SocketTool byteToString:uuid length:16];
       // DLog(@"接收到uuid包:%@",self.uuid);
        // 判断uuid是不是全0，如果是全0的话，就是错误的uuid要重新请求uuid
        int value = 1;
        for (int i = 0; i < self.uuid.length / 4; i ++) {
            int k = 1;
            [self.uuid getBytes: &k range:NSMakeRange(i * 4, sizeof(k))];
            value = k;
            if (k != 0) {
                break;
            }
        }
        if (value == 0) {
            MyLog(@"错误的uuid,把收到的uuid置为空");
            free(uuid);
            self.uuid = nil;
            return NO;
        }
        else {
            MyLog(@"uuid包已成功接收到:%@",self.uuid);
        }
    }
    free(uuid);
    return YES;
}

@end
