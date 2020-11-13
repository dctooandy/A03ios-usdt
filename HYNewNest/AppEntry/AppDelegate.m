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

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    
    return YES;
}


#pragma mark - 推送回调
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

#ifdef DEBUG
    [kKeywindow jk_makeToast:[NSString stringWithFormat:@"===didRegisterRemoteNotifications===\ncustomerId:%@\ndeviceToken:%@",[CNUserManager shareManager].userInfo.customerId, self.token] duration:10 position:JKToastPositionBottom];
#endif
        
    // 推送相关
    [CNPushRequest GetUDIDHandler:nil];
    [CNPushRequest GTInterfaceHandler:nil];
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
#ifdef DEBUG
    [kKeywindow jk_makeToast:[NSString stringWithFormat:@">>>[Receive RemoteNotification - Background Fetch]:\n%@", userInfo] duration:10 position:JKToastPositionCenter];
#endif
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    MyLog(@"didFailToRegisterForRemoteNotificationsWithError error:%@",error);
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
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];

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
