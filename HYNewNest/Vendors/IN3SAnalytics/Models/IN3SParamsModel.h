//
//  IN3SParamsModel.h
//  IN3SAnalytics
//
//  Created by Key on 2019/2/9.
//  Copyright © 2019年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"
#import <BGFMDB.h>
#import "IN3SConstants.h"
#import "IN3SUtility.h"

typedef NS_ENUM(NSInteger,IN3SAnalyticsEvent){
    IN3SAnalyticsEventLaunch = 0,// 启动
    IN3SAnalyticsEventPage = 1,// 进入页面
    IN3SAnalyticsEventRequest = 2,// 网络请求
    IN3SAnalyticsEventBrowser = 3,// 加载webView
    IN3SAnalyticsEventAGQJ = 4,// 加载AGQJ
    IN3SAnalyticsEventExit = 5,// 结束App
};


@interface IN3SParamsModel : JSONModel

#pragma mark -------------------公共参数---------------------------------------

/**
 当前时间戳
 */
@property(nonatomic, copy)NSString *time;
/**
 当前页面,默认为当前controller
 */
@property(nonatomic, copy)NSString *page;
/**
 异常讯息
 */
@property(nonatomic, copy)NSString *msg;

/**
 事件类型
 */
@property(nonatomic, assign, readonly)IN3SAnalyticsEvent eventType;

/**
 事件键，不用设置，由SDK自动生成
 */
@property(nonatomic, copy, readonly)NSString *eventKey;

@end
