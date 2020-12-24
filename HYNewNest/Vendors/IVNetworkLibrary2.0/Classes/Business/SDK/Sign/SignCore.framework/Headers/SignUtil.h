//
//  SignCore.h
//  SignCore
//
//  Created by kunlun on 21/01/2019.
//  Copyright © 2019 zaky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUtil : NSObject


+ (NSString*)getSign:(NSString*)src qid:(NSString*)qid keyEnum:(NSString*)keyEnum;

+ (NSString*)getSignByAfterSortSrc:(NSString*)src qid:(NSString*)qid keyEnum:(NSString*)keyEnum;


@end

NS_ASSUME_NONNULL_END
