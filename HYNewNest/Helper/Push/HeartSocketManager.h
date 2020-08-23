//
//  UDPSocket.h
//  UDPSocketDemo
//
//  Created by Robert on 11/03/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SendHeartSocket  [HeartSocketManager shareInstance]

/** 心跳包管理 */
@interface HeartSocketManager : NSObject

+ (instancetype)shareInstance;

+ (void)initHeartSocketConfigWithIpAddress:(NSString *)ipAddress
                                      port:(NSInteger)port
                                 porductId:(NSString *)productId;
/**
 发送心跳包
 
 @param apnsToken 推送的token (如果为空，将不替换现有的apnsToken数据)
 @param userid    用户id (可以为空)
 */
- (void)sendHeartPacketWithApnsToken:(NSData *)apnsToken
                              userid:(int)userid;


/** 停止发包 */
- (void)stopSendHeartPacket;
@end
