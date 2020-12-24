//
//  IVNUtility.h
//  IVNetworkLibrary2.0
//
//  Created by key.l on 13/09/2019.
//  Copyright © 2019 Key. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define IVNLog(format, ...) [IVNUtility log:(format), ##__VA_ARGS__]

@interface IVNUtility : NSObject
+ (void)log:(NSString *)format, ...;
@end

NS_ASSUME_NONNULL_END
