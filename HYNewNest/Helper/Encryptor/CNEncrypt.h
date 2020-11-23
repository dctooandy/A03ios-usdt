//
//  CNEncrypt.h
//  LCNewApp
//
//  Created by cean.q on 2019/11/25.
//  Copyright © 2019 B01. All rights reserved.
//  加密类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNEncrypt : NSObject
/// RSA加密
/// @param string 需要加密的字符串
+ (NSString *)encryptString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
