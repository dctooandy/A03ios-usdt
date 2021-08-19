//
//  CNServiceRequest.h
//  HYNewNest
//
//  Created by zaky on 6/15/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNServiceRequest : CNBaseNetworking


+ (void)liveChatAddressOCSSHandler:(HandlerBlock)handler;

/// 是否开启微脉圈
+ (void)queryIsOpenWMQHandler:(HandlerBlock)handler;

/// 客服回拨
+ (void)callCenterCallBackMessageId:(nullable NSString *)messageId
                            smsCode:(nullable NSString *)smsCode
                           mobileNo:(nullable NSString*)mobileNo
                            handler:(HandlerBlock)handler;

/// 拨打客服电话
+ (void)call400;

/**
 *取得OCSSDomain
 */
+ (void)queryOCSSDomainHandler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
