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

#import <GTSDK/GeTuiSdk.h>
#import "PushNotificationCenter.h"
#import "HeartSocketManager.h"
#import "CNPushRequest.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret iOS集成文档 http://docs.getui.com/getui/mobile/ios/xcode/
#define kGtAppId           @"TmoECTk0VCAPkK9XzZldf5"
#define kGtAppKey          @"ddJKfPIuo59eh9OTZZuod3"
#define kGtAppSecret       @"w1ZtcruT6F8B3iSiKTYEg4"

@interface AppDelegate () <GeTuiSdkDelegate, UNUserNotificationCenterDelegate>
/** YES 点击通知栏启动app的推送消息, NO 相反 */
@property(nonatomic,assign) BOOL isLaunchPush;
/** 推送的消息 */
@property(nonatomic,strong) NSDictionary *pushUserInfo;

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

    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[SplashViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    [self setupKeyboard];
    
    //通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
    
    return YES;
}


#pragma mark - 推送回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 发送deveiceToken给服务器
    [SendHeartSocket sendHeartPacketWithApnsToken:deviceToken userid:[[CNUserManager shareManager].userInfo.customerId intValue]];
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

    NSLog(@"did register remote token with :%@", self.token);
    [GeTuiSdk registerDeviceTokenData:deviceToken];
    
    [CNPushRequest GTInterfaceHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            MyLog(@"超级签名推送responseObject==%@",responseObj);
        } else {
            MyLog(@"超级签名推送error==%@",errorMsg);
        }
    }];
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (!self.isLaunchPush) {
        [RecivePushInfoCenter receivedNotificationUserInfoWithUserInfo:userInfo isLaunching:self.isLaunchPush];
    }
    
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    MyLog(@"didFailToRegisterForRemoteNotificationsWithError error:%@",error);
}


#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GeTuiSdk ReceivePayload]:%@\n\n", msg);
}

- (void)GeTuiSdkDidAliasAction:(NSString *)action result:(BOOL)isSuccess sequenceNum:(NSString *)aSn error:(NSError *)aError{
    NSLog(@"--zq--function- %s,isSuccess :%@ ,sequenceNum is :%@",__func__,isSuccess?@"yes":@"no",aSn);
}


- (void)checkNeedLaunchPush {
    // 如果通知栏点击消息启动app，切换到主tabbar后再跳转到推送的页面
    if (self.isLaunchPush && self.pushUserInfo) {
        [RecivePushInfoCenter receivedNotificationUserInfoWithUserInfo:self.pushUserInfo isLaunching:YES];
        self.isLaunchPush = NO;
        self.pushUserInfo = nil;
    }
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
