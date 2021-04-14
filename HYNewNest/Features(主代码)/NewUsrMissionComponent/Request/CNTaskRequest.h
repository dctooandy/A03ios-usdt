//
//  CNTaskRequest.h
//  HYNewNest
//
//  Created by zaky on 4/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNTaskRequest : CNBaseNetworking

+ (void)getNewUsrTask:(HandlerBlock)handler;

+ (void)applyTaskRewardIds:(NSString *)prizeIds code:(NSString *)prizeCode handler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
