//
//  BYNewbieRequest.h
//  HYNewNest
//
//  Created by RM04 on 2021/5/24.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYNewbieRequest : CNBaseNetworking

+ (void)getNewUsrTask:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
