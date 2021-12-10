//
//  AppSettingRequest.h
//  HYNewNest
//
//  Created by RM03 on 2021/12/8.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppSettingRequest : CNBaseNetworking
+ (void)getAppSettingTask:(HandlerBlock)handler;
@end

NS_ASSUME_NONNULL_END
