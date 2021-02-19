//
//  KLDNetConnect.h
//  KLDNetDiagnoServiceDemo
//
//  Created by ZhangHaiyang on 15-8-5.
//  Copyright (c) 2015年 庞辉. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * @protocal KLDNetConnectDelegate监测connect命令的的输出到日志变量；
 *
 */
@protocol KLDNetConnectDelegate <NSObject>
- (void)appendSocketLog:(NSString *)socketLog;
- (void)connectDidEnd:(BOOL)success;
@end


/*
 * @class KLDNetConnect ping监控
 * 主要是通过建立socket连接的过程，监控目标主机是否连通
 * 连续执行五次，因为每次的速度不一致，可以观察其平均速度来判断网络情况
 */
@interface KLDNetConnect : NSObject {
}

@property (nonatomic, weak) id<KLDNetConnectDelegate> delegate;

/**
 * 通过hostaddress和port 进行connect诊断
 */
- (void)runWithHostAddress:(NSString *)hostAddress port:(int)port;

/**
 * 停止connect
 */
- (void)stopConnect;

@end
