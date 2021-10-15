//
//  NSURL+HYLink.h
//  HYGEntire
//
//  Created by zaky on 24/12/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (HYLink)
//银行卡，付款方式
+ (NSURL *)getBankIconWithString:(NSString *)strUrl;

+ (NSURL *)getUrlWithString:(NSString *)strUrl;

+ (NSString *)getStrUrlWithString:(NSString *)strUrl;

/// /pub_site/   风采跳H5需要拼接这部分
+ (NSString *)getH5StrUrlWithString:(NSString *)strUrl ticket:(NSString *)ticket needPubSite:(BOOL)needPubSite;

//风采
+ (NSString *)getFCH5StrUrlWithID:(NSString *)ID;

@end

NS_ASSUME_NONNULL_END
