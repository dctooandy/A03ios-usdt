//
//  IN3SAnalytics.h
//  IN3SAnalytics
//
//  Created by Key on 2019/2/8.
//  Copyright © 2019年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IN3SAnalytics : NSObject

/**
 SDK初始化
 注意: 一定要在application:didFinishLaunchingWithOptions:方法中调用
 @param product 产品ID，如A01
 */
+ (void)configureSDKWithProduct:(NSString *)product;

/**
 设置手机站域名，在获取到手机站后调用
 */
+ (void)setDomain:(NSString *)domain;

/**
 设置登录用户名，在获取到用户名后调用
 注意：每次切换用户都需要调一下该方法，退出登录userName传nil
 */
+ (void)setUserName:(NSString *)userName;

/**
 设置调试模式
 默认为NO
 @param enable ，YES：开启，NO：关闭
 */
+ (void)debugEnable:(BOOL)enable;

/**
 启动App完成，可以在首页第一次显示时调用
 */
+ (void)launchFinished;

/**
 App退出
 */
+ (void)exitApp;

/**
 进入页面

 @param pageName 可传nil使用当前controller类名
 @param timestamp 时间戳，单位秒
 */
+ (void)enterPageWithName:(NSString *)pageName responseTime:(double)resTime timestamp:(NSString *)timestamp;

/**
 加载网页

 @param url 完整url地址
 @param resTime 响应时长，单位:ms
 @param resCode 返回状态码
 @param msg 异常讯息
 @param timestamp 时间戳，单位秒
 */
+ (void)loadWebViewWithUrl:(NSString *)url responseTime:(double)resTime responseCode:(int)resCode msg:(NSString *)msg timestamp:(NSString *)timestamp;

/**
 网络请求

 @param url 完整url地址
 @param resTime 响应时长，单位:ms
 @param resCode 返回状态码
 @param msg 异常讯息
 @param timestamp 时间戳，单位秒
 */
+ (void)requestWithUrl:(NSString *)url responseTime:(double)resTime responseCode:(int)resCode msg:(NSString *)msg timestamp:(NSString *)timestamp;

/**
 进入AGQJ游戏加载时长

 @param resTime 响应时长，单位:ms
 @param loadFinish 游戏当前状态是否加载完成，是:YES,否:NO
 @param msg 异常讯息
 @param timestamp 时间戳，单位秒
 */
+ (void)loadAGQJWithResponseTime:(double)resTime loadFinish:(BOOL)loadFinish msg:(NSString *)msg timestamp:(NSString *)timestamp;
/**
 触发事件
 @param parameter 参数模型 启动:IN3SInitModel,
 */
//+ (void)triggerEventWithParameter:(IN3SParamsModel *)parameter timestamp:(NSString *)timestamp;
@end
