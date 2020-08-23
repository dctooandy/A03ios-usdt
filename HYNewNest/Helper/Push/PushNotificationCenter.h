//
//  PushNotificationCenter.h
//  A02_iPhone
//
//  Created by Robert on 11/04/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 推送消息进入的类型（启动进入，前台运行进入，后台点击进入） */
typedef NS_ENUM(NSInteger, ReceiveRemotePushComeType){
    /**  启动进入推送界面 */
    LaunchingComeType = 0,
    /** 前台运行进入推送界面 */
    ActiveStateComeType = 1,
    /** 后台点击进入推送界面 */
    BackgroundComeType = 2
};

/** 收到推送消息的类型 */
typedef NS_ENUM(NSInteger, RecivePushMsgType){
    /** 优惠消息(活动精选)类型 */
    ActivityMsgType = 1,
    
    /** 系统消息类型 */
    SystemMsgType = 2
};

#define RecivePushInfoCenter [PushNotificationCenter sharedPushNotificationCenter]

@interface PushNotificationCenter : NSObject

singleton_interface(PushNotificationCenter)

/**
 注册推送通知
 
 @param application application
 @param launchOptions launchOptions
 */
- (void)registerPushService:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 接收消息推送进行处理
 
 @param userInfo        推送消息数据
 @param isLaunching     YES 点击通知栏启动app
 */
- (void)receivedNotificationUserInfoWithUserInfo:(NSDictionary *)userInfo isLaunching:(BOOL)isLaunching;
@end
