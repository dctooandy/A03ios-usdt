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
#import <IN3SAnalytics/CNTimeLog.h>
#import <YJChat.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@property (strong,nonatomic) NSDictionary *pushNotiUserInfo; // 远程推送 冷启动收到的数据
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // URLCache
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoteNotification) name:BYDidEnterHomePageNoti object:nil];
    
    // 3S 统计
#if DEBUG
    [CNTimeLog debugEnable:YES];
#endif
    [CNTimeLog debugEnable:NO];
    [CNTimeLog configProduct:@"A03"];
    
    // 天网埋点
    [IVLAManager setLogEnabled:YES];
    [IVLAManager needUploadWithNewDomain:YES];
    [IVLAManager setPayegisSDKDomain:@"http://115.84.241.53/did/"];
    [IVLAManager startWithProductId:@"A03"           //产品ID
                        productName:@"hyyl"          //产品Name
                          channelId:@""     //渠道号
                              appId:@"5308e20b"      //分配的appId
                             appKey:@"5308e20b"      //分配的appKey
                     sessionTimeout:5000             //超时时间，秒
#ifdef DEBUG
                        environment:IVLA_Dev
#else
                        environment:IVLA_Dis        //环境: 线上
#endif
                          loginName:^NSString *{     //获取登录名
        return [CNUserManager shareManager].userInfo.loginName;
    }];
    
    // pages
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[SplashViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    // Keyboard
    [self setupKeyboard];
    
    // 注册 APNs
    [self registerRemoteNotification];
    
    // 微脉圈
//#ifdef DEBUG
//    [YJChat initChatWithProductId:@"A03" env:1];
//#else
//    [YJChat initChatWithProductId:@"A03" env:2];
//#endif
    
    //这个是应用未启动但是通过点击通知的横幅来启动应用的时候
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        //如果有值，说明是通过远程推送来启动的
        self.pushNotiUserInfo = userInfo;
    }
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [IN3SAnalytics exitApp];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}


#pragma mark - 推送回调

/**
 *  推送注册成功
 */
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
    
    if (!userInfo) {
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }
    
    self.pushNotiUserInfo = userInfo;
    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1;
    AudioServicesPlaySystemSound(1007);
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        //应用在前台，接收远程推送，会进入这个状态
    }
    else if (state == UIApplicationStateInactive) {
        //应用在后台，通过点击远程推送通知，进入这个状态
        [self handleRemoteNotification];
    }
    else if (state == UIApplicationStateBackground) {
        //应用在后台，收到静默推送，进入这个状态
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

/**
 * 推送注册失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [CNTOPHUB showError:@"推送服务注册失败 请检查推送证书"];
    
//#ifdef DEBUG
//    [kKeywindow jk_makeToast:[NSString stringWithFormat:@"===didFailToRegisterForRemoteNotifications===\nError:%@", error] duration:8 position:JKToastPositionBottom];
//#endif
    MyLog(@"didFailToRegisterForRemoteNotificationsWithError error:%@",error);
}


#pragma mark - UNUserNotificationCenterDelegate
/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    MyLog(@"Receive a notification in foregound --- userNotificationCenter:willPresentNotification:\n%@", notification);
    // 通知不弹出
//    completionHandler(UNNotificationPresentationOptionNone);
    // 通知弹出，且带有声音、内容和角标（App处于前台时不建议弹出通知）
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    MyLog(@"userNotificationCenter:didReceiveNotificationResponse:\n%@", response);
    completionHandler();
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

/**
 * 注册 APNs
 */
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

/**
 * 处理推送点击
 */
- (void)handleRemoteNotification {
    NSDictionary *userInfo = self.pushNotiUserInfo;
    if (userInfo) {
        if ([userInfo.allKeys containsObject:@"payload"] && [userInfo.allKeys containsObject:@"aps"]) {
            NSString *payload = userInfo[@"payload"];
            NSDictionary *dict = [payload jk_dictionaryValue];
            NSString *pageTitle = userInfo[@"aps"][@"alert"][@"title"] ?: @"";
            if (dict && [dict.allKeys containsObject:@"jumpUrl"]) {
                NSString *url = dict[@"jumpUrl"];
                [NNPageRouter jump2HTMLWithStrURL:url title:pageTitle needPubSite:NO];
                _pushNotiUserInfo = nil;
            }
        }
    }
}



@end
