//
//  BYGloryRequest.h
//  HYNewNest
//
//  Created by RM04 on 2021/7/20.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYGloryRequest : CNBaseNetworking
+ (void)getAgDynamic:(HandlerBlock)handler;
@end

NS_ASSUME_NONNULL_END
