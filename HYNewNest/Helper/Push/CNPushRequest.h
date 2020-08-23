//
//  CNPushRequest.h
//  HYNewNest
//
//  Created by zaky on 8/23/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "IVOtherInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNPushRequest : CNBaseNetworking

+ (void)GetUDIDHandler:(nullable HandlerBlock)completionHandler;

+ (void)GTInterfaceHandler:(nullable HandlerBlock)completionHandler;
@end

NS_ASSUME_NONNULL_END
