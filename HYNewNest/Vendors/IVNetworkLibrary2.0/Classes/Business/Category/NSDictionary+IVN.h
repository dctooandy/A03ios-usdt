//
//  NSDictionary+KYC.h
//  KYCommon
//
//  Created by Key on 13/05/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (IVN)
/**
 是否为可用的NSDictionary，即不为空且count大于0
 */
- (BOOL)IVNIsAvailable;
/**
 转NSData
 */
- (NSData *)IVNToData;
/**
 转JSON字符串
 */
- (NSString *)IVNToJSONString;
@end

NS_ASSUME_NONNULL_END
