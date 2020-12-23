//
//  HYNetworkConfigManager.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/20.
//  Copyright © 2020 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVHttpManager.h"
#import "IVHTTPBaseRequest.h"
#import "HYHttpPathConst.h"

#define kNetworkMgr [HYNetworkConfigManager shareManager]

NS_ASSUME_NONNULL_BEGIN

@class IVHTTPBaseRequest, IVHttpManager;
@interface HYNetworkConfigManager : NSObject

@property (nonatomic, assign, readonly) IVNEnvironment environment;

+ (instancetype)shareManager;

/// 切换环境
- (void)switchEnvirnment;

/// 每个请求都要带的参数
- (NSMutableDictionary *)baseParam;

@end

NS_ASSUME_NONNULL_END
