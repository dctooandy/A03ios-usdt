//
//  CNBaseNetworking.h
//  LCNewApp
//
//  Created by cean.q on 2019/11/19.
//  Copyright © 2019 B01. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HandlerBlock)(id responseObj, NSString *errorMsg);

@interface CNBaseNetworking : NSObject

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HandlerBlock)completionHandler;

+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(HandlerBlock)completionHandler;

@end

