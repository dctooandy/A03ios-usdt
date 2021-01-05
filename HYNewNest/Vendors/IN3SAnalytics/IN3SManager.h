//
//  IN3SManager.h
//  IN3SAnalytics
//
//  Created by Key on 2019/2/8.
//  Copyright © 2019年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IN3SParamsModel.h"

@interface IN3SManager : NSObject
@property(nonatomic, copy)NSString *product;
@property(nonatomic, copy)NSString *domain;
@property(nonatomic, copy)NSString *userName;
+ (instancetype)shareManager;
- (void)configureSDKWithProduct:(NSString *)product;
- (void)triggerEventWithParameter:(IN3SParamsModel *)parameter timestamp:(NSString *)timestamp;
- (void)launchFinished;
- (void)exitApp:(NSString *)timestamp;
- (void)enterPageWithName:(NSString *)pageName responseTime:(double)resTime timestamp:(NSString *)timestamp;
- (void)loadWebViewWithUrl:(NSString *)url responseTime:(double)resTime responseCode:(int)resCode msg:(NSString *)msg timestamp:(NSString *)timestamp;
- (void)requestWithUrl:(NSString *)url responseTime:(double)resTime responseCode:(int)resCode msg:(NSString *)msg timestamp:(NSString *)timestamp;
- (void)loadAGQJWithResponseTime:(double)resTime isPreload:(BOOL)isPreload  isFinishedPreload:(BOOL)isFinishedPreload msg:(NSString *)msg timestamp:(NSString *)timestamp;
@end
