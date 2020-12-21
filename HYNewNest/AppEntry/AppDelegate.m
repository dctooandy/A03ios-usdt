//
//  AppDelegate.m
//  HYNewNest
//
//  Created by zaky on 02/07/2020.
//  Copyright © 2020 james. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <IVLoganAnalysis/IVLAManager.h>
#import "CNPushRequest.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@property (strong,nonatomic) NSDictionary *pushNotiUserInfo; // 远程推送 冷启动收到的数据
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoteNotification:) name:BYDidEnterHomePageNoti object:_pushNotiUserInfo];
    
    // 天网埋点
    [IVLAManager setLogEnabled:YES];
    [IVLAManager startWithProductId:@"A03"           //产品ID
                        productName:@"hyyl"          //产品Name
                          channelId:@""     //渠道号
                              appId:@"5308e20b"      //分配的appId
                             appKey:@"5308e20b"      //分配的appKey
                     sessionTimeout:5000             //超时时间，秒
#ifdef DEBUG
                        environment:IVLA_Loacl
#else
                        environment:IVLA_Dis        //环境: 线上
#endif
                          loginName:^NSString *{     //获取登录名
        return [CNUserManager shareManager].printedloginName;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), ^{
        [IVLAManager setPayegisSDKDomain:@"http://115.84.241.53/did/"];
    });
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[SplashViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    [self setupKeyboard];
    
    // 注册 APNs
    [self registerRemoteNotification];
    
    //这个是应用未启动但是通过点击通知的横幅来启动应用的时候
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        //如果有值，说明是通过远程推送来启动的
        self.pushNotiUserInfo = userInfo;
    }
    
    return YES;
}


#pragma mark - 推送回调

/// 推送注册成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    if (@available(iOS 13, *)){
       if (![deviceToken isKindOfClass:[NSData class]]) return;
       const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
       NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                             ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                             ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                             ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        self.token = hexToken;
    }else{
        NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.token = token;
    }

//#ifdef DEBUG
//    [kKeywindow jk_makeToast:[NSString stringWithFormat:@"===didRegisterRemoteNotifications===\ndeviceToken:%@", self.token] duration:8 position:JKToastPositionBottom];
//#endif
        
    // ips透传
    [CNPushRequest GTInterfaceHandler:nil];
    
}

// 接收到推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//#ifdef DEBUG
//    [kKeywindow jk_makeToast:[NSString stringWithFormat:@">>>[Receive RemoteNotification - Background Fetch]:\n%@", userInfo] duration:8 position:JKToastPositionCenter];
//#endif
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    if (userInfo != nil) {
        [self handleRemoteNotification:userInfo];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// 推送注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [CNHUB showError:@"推送服务注册失败 请检查推送证书"];
    MyLog(@"didFailToRegisterForRemoteNotificationsWithError error:%@",error);
//#ifdef DEBUG
//    [kKeywindow jk_makeToast:[NSString stringWithFormat:@"===didFailToRegisterForRemoteNotifications===\nError:%@", error] duration:8 position:JKToastPositionBottom];
//#endif
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    MyLog(@"userNotificationCenter:willPresentNotification:\n%@", notification);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    MyLog(@"userNotificationCenter:didReceiveNotificationResponse:\n%@", response);
}


#pragma mark - Customer
- (void)changeRootViewController:(UIViewController*)viewController {

    if (!self.window.rootViewController) {
        self.window.rootViewController = viewController;
        return;
    }

    UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];
    [viewController.view addSubview:snapShot];

    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];

    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}

- (void)setupKeyboard {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    //点击空白
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //设置为文字
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
        if (granted && !error) {
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
//#ifdef DEBUG
//                        [kKeywindow jk_makeToast:@"Request authorization succeeded!" duration:5 position:JKToastPositionCenter];
//#endif
                    });
                }
            }];
        }
    }];
    
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo) {
        if ([userInfo.allKeys containsObject:@"payload"] && [userInfo.allKeys containsObject:@"aps"]) {
            NSString *payload = userInfo[@"payload"];
            NSDictionary *dict = [payload jk_dictionaryValue];
            NSString *pageTitle = userInfo[@"aps"][@"alert"][@"title"];
            if (dict && [dict.allKeys containsObject:@"jumpUrl"]) {
                NSString *url = dict[@"jumpUrl"];
                [NNPageRouter jump2HTMLWithStrURL:url title:pageTitle needPubSite:NO];
            }
        }
    }
}


#pragma mark - UISceneSession lifecycle
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

@end
