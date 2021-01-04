//
//  IN3SAGQJModel.h
//  IN3SAnalytics
//
//  Created by Key on 2019/2/11.
//  Copyright © 2019年 Key. All rights reserved.
//

#import "IN3SParamsModel.h"

@interface IN3SAGQJModel : IN3SParamsModel
/**
 uuid,
 */
@property(nonatomic, copy)NSString *uuid;
/**
 响应时间，单位:ms
 */
@property(nonatomic, assign)CGFloat rsptime;
/**
 是否预加载，是:YES,否:NO
 */
@property(nonatomic, assign)BOOL preload;
/**
 是否预加载完成，是:YES,否:NO
 */
@property(nonatomic, assign)BOOL load_finish;
@end
