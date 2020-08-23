//
//  PushNotificationCenter.m
//  A02_iPhone
//
//  Created by Robert on 11/04/2017.
//  Copyright © 2017 Robert. All rights reserved.
//

#import "PushNotificationCenter.h"
#import "AlertViewHelp.h"
#import "HYNavigationController.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation PushNotificationCenter
singleton_implementation(PushNotificationCenter)

/**
 注册推送通知

 @param application application
 @param launchOptions launchOptions
 */
- (void)registerPushService:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
    [UIApplication.sharedApplication registerUserNotificationSettings:settings];
}

/**
 接收消息推送进行处理
 
 @param userInfo        推送消息数据
 @param isLaunching     YES 点击通知栏启动app
 */
- (void)receivedNotificationUserInfoWithUserInfo:(NSDictionary *)userInfo isLaunching:(BOOL)isLaunching {
    ReceiveRemotePushComeType pushComeType = LaunchingComeType;
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    if(application.applicationState == UIApplicationStateActive && !isLaunching) {
        pushComeType = ActiveStateComeType;
    }
    else if (application.applicationState == UIApplicationStateInactive && !isLaunching) {
        pushComeType = BackgroundComeType;
    }
    else if (application.applicationState == UIApplicationStateBackground) {
        pushComeType = BackgroundComeType;
    }
  
    if (isLaunching) {
        pushComeType = LaunchingComeType;
    }
    NSDictionary *userInfoDict = [userInfo copy];
    if ((!userInfoDict)) {
        return;
    }
    if (pushComeType == ActiveStateComeType) {
        AudioServicesPlaySystemSound(1007);
        [[AlertViewHelp sharedAlertViewHelp] alertMessageWithTitle:@"提示" message:userInfo[@"aps"][@"alert"] cancelTitle:@"取消"  okTitle:@"确定" finish:^(AlertMessageButtonType buttonIndex) {
            if (HelpOKButtonTag == buttonIndex) {
                [self loadDifferentControllersByTypeWithUserInfo:userInfoDict];
            }
        }];
    }
    else{
        [self loadDifferentControllersByTypeWithUserInfo:userInfoDict];
    }
}

/** 根据推送类型加载不同的页面 */
- (void)loadDifferentControllersByTypeWithUserInfo:(NSDictionary *)userInfo {
    if (userInfo && [userInfo isKindOfClass:[NSDictionary class]] && [userInfo.allKeys containsObject:@"data"]) {
        NSDictionary *data = userInfo[@"data"];
        if ([data.allKeys containsObject:@"type"]) {
            RecivePushMsgType type = [data[@"type"] integerValue];
            switch (type) {
                case ActivityMsgType:{
                    //[self loadPromoViewControllerWithUserInfo:userInfo];
                    break;
                }
                case SystemMsgType:{
                    [self loadSystemNoticeViewControllerWithUserInfo:userInfo];
                    break;
                }
                default:
                    break;
            }
        }
    }
}



/** 加载系统通知 */
- (void)loadSystemNoticeViewControllerWithUserInfo:(NSDictionary *)userinfo {
    
}

@end
