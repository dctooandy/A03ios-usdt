//
//  SocketRocketUtility.h
//  HYNewNest
//
//  Created by zaky on 11/21/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SocketRocketUtility : NSObject

+ (SocketRocketUtility *)instance;
-(void)SRWebSocketOpenWithURLString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
