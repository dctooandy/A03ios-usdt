//
//  IN3SGlobalModel.h
//  IN3SAnalytics
//
//  Created by Key on 2019/2/9.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "JSONModel.h"
#import <BGFMDB.h>
@interface IN3SGlobalModel : JSONModel
/**
 uuid
 */
@property(nonatomic, copy)NSString *sessionId;
/**
 设备唯一标识
 */
@property(nonatomic, copy)NSString *deviceId;
/**
 产品id
 */
@property(nonatomic, copy)NSString *product;
/**
 模块
 */
@property(nonatomic, copy)NSString *module;
/**
 手机站域名
 */
@property(nonatomic, copy)NSString *domain;
/**
 用户名
 */
@property(nonatomic, copy)NSString *user;
/**
 当前页面
 */
@property(nonatomic, copy)NSString *page;
@end


