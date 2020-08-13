//
//  NSObject+CNParse.h
//  LCNewApp
//
//  Created by cean.q on 2019/11/19.
//  Copyright © 2019 B01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

/// 归档
#define kHYCodingDesc \
- (void)encodeWithCoder:(NSCoder *)aCoder {\
[self yy_modelEncodeWithCoder:aCoder];\
}\
- (id)initWithCoder:(NSCoder *)aDecoder {\
self = [super init];\
return [self yy_modelInitWithCoder:aDecoder];\
}\
- (NSString *)description {\
return [self yy_modelDescription];\
}\

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CNParse) <YYModel>
+ (id)cn_parse:(id)JSON;
@end

NS_ASSUME_NONNULL_END
