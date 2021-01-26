//
//  BYJSONHelper.h
//  HYNewNest
//
//  Created by zaky on 1/26/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BYJSONHelper : NSObject

+ (NSString *)dictOrArrayToJsonString:(NSDictionary *)dict;
+ (id)dictOrArrayWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
