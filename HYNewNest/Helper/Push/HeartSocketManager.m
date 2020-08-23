 //
//  UDPSocket.m
//  UDPSocketDemo
//
//  Created by Robert on 11/03/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import "HeartSocketManager.h"
#import <GCDAsyncUdpSocket.h>
#include <netdb.h>
#include <arpa/inet.h>
#import "HeartPacketData.h"
#import "SocketTool.h"
@interface HeartSocketManager()<GCDAsyncUdpSocketDelegate>

@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;

@property (strong, nonatomic) HeartPacketData *heartPacketeData;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSString *ipAddress;

@property (assign, nonatomic) NSInteger port;
@end

@implementation HeartSocketManager

#pragma mark 公共方法
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static HeartSocketManager *shareInstance = nil;
    dispatch_once(&onceToken, ^{
        shareInstance = [[super allocWithZone:NULL] init] ;
    }) ;
    return shareInstance;
}

/**
 初始化心跳包的配置

 @param ipAddress ip地地睛
 @param port      端口号
 @param productId 产品id
 */
+ (void)initHeartSocketConfigWithIpAddress:(NSString *)ipAddress
                                      port:(NSInteger)port
                                 porductId:(NSString *)productId {
    SendHeartSocket.ipAddress = [NSString stringWithFormat:@"%@",ipAddress];
    SendHeartSocket.port = port;
    SendHeartSocket.heartPacketeData.productId = productId;
}

/**
 发送心跳包
 
 @param apnsToken 推送的token (如果为空，将不替换现有的apnsToken数据)
 @param userid    用户id (可以为空)
 */
- (void)sendHeartPacketWithApnsToken:(NSData *)apnsToken
                              userid:(int)userid {
    if (apnsToken && apnsToken.length == 32) {
        self.heartPacketeData.apnsToken = apnsToken;
    }
    self.heartPacketeData.userid = userid;
    NSError *error = nil;
    [self.udpSocket beginReceiving:&error];
    [self stopSendHeartPacket];
    [self startTimer];
}

/** 停止发包 */
- (void)stopSendHeartPacket {
    [self destoryTimer];
}

#pragma mark 私有方法
/** 发送心跳包 */
- (void)sendHeartPacket {
    [self.udpSocket sendData:[self.heartPacketeData spellHeartPacketData] toHost:self.ipAddress port:self.port withTimeout:-1 tag:0];
    NSError *error;
    [self.udpSocket beginReceiving:&error];
}

#pragma mark 处理收到socket包
/**
 处理收到的socket包

 @param data 包数据
 */
- (void)handleReciveSocketPacket:(NSData *)data {
    Byte *byte = (Byte *)[data bytes];
    // 取出byte数组的第1个字节，是标志位,然后再取出标志位字节的位数放到一个数组中
    Byte flagByte = byte[0];
    Byte flagBits [8] = {0};
    for (int i = 7; i >= 0; i -- ) {
        flagBits[i] = (Byte)(flagByte & 1);
        flagByte = (Byte) (flagByte >> 1);
    }
    // 取出标志位字节的第二位用来判断是否是带uuid的包
    Byte *bit = &flagBits[1];
    // 把标志位字节的第二位转成整型
    int bitValue = [SocketTool byteToInt:bit];
    if (bitValue == 1) {
        [self.heartPacketeData handleUUIDPacketWithSocketData:data];
    }
    else{
        [self handleOtherPacket:data];
    }
}

/**
 处理其它包 预留

 @param data 包数据
 */
- (void)handleOtherPacket:(NSData *)data {
    //NSLog(@"接收到其它包:%@",data);
}


#pragma mark Socket回调
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
  //  NSLog(@"didConnectToAddress");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error {
  // NSLog(@"didNotConnect");
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
   // NSLog(@"didSendDataWithTag");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error {
    // NSLog(@"didNotSendDataWithTag");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext {
    [self handleReciveSocketPacket:data];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error {
   // NSLog(@"udpSocketDidClose");
}

#pragma mark GET SET
- (GCDAsyncUdpSocket *)udpSocket {
    if (!_udpSocket) {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _udpSocket;
}

- (HeartPacketData *)heartPacketeData {
    if (!_heartPacketeData) {
        _heartPacketeData = [[HeartPacketData alloc] init];
    }
    return _heartPacketeData;
}

#pragma mark 定时器开启与关闭
/** 开启定时器发送socekt包 */
- (void)startTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(sendHeartPacket) userInfo:nil repeats:YES];
        [_timer fire];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

/** 销毁定时器 */
- (void)destoryTimer {
    if (_timer && [_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    [self setUdpSocket:nil];
}

- (void)dealloc {
    [self destoryTimer];
}
@end
