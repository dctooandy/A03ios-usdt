//
//  IN3SLaunchModel.h
//  IN3SAnalytics
//
//  Created by Key on 2019/2/11.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SParamsModel.h"

@interface IN3SLaunchModel : IN3SParamsModel

/**
 手机类型,不用设置，由SDK自动生成
 */
@property(nonatomic, copy, readonly)NSString *phone;
/**
 手机系统,不用设置，由SDK自动生成
 */
@property(nonatomic, copy, readonly)NSString *os;
/**
 app版本,不用设置，由SDK自动生成
 */
@property(nonatomic, copy, readonly)NSString *version;
/**
 用户网络类型 4G or wifi
 */
@property(nonatomic, copy)NSString *network;
/**
 从启动到进入首页的耗时，单位ms
 */
@property(nonatomic, assign)CGFloat init_time;
@end
