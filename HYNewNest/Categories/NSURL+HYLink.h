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

+ (NSURL *)getUrlWithString:(NSString *)strUrl;

+ (NSString *)getStrUrlWithString:(NSString *)strUrl;

+ (NSString *)getH5StrUrlWithString:(NSString *)strUrl ticket:(NSString *)ticket;

//风采
+ (NSString *)getFCH5StrUrlWithID:(NSString *)ID;

@end

NS_ASSUME_NONNULL_END
