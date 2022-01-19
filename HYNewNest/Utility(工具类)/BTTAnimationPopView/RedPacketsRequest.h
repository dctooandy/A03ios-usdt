//
//  RedPacketsRequest.h
//  HYNewNest
//
//  Created by RM03 on 2022/1/18.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketsRequest : CNBaseNetworking
+ (void)getRainInfoTask:(HandlerBlock)handler;
+ (void)getRainIdentifyTask:(HandlerBlock)handler;
+ (void)getRainOpenTask:(HandlerBlock)handler;
+ (void)getRainQueryTask:(HandlerBlock)handler;
+ (void)getRainInKindPrizeTask:(HandlerBlock)handler;
+ (void)getRainGroupTask:(HandlerBlock)handler;
@end

NS_ASSUME_NONNULL_END
