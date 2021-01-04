//
//  IN3SRequestModel.h
//  IN3SAnalytics
//
//  Created by Key on 2019/2/11.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SParamsModel.h"

@interface IN3SRequestModel : IN3SParamsModel
/**
 请url
 */
@property(nonatomic, copy)NSString *url;
/**
 响应时间，单位:ms
 */
@property(nonatomic, assign)CGFloat rsptime;
/**
 返回状态吗
 */
@property(nonatomic, assign)int rspcode;
@end
