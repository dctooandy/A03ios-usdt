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

@interface AppDelegate ()

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
    
    return YES;
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
