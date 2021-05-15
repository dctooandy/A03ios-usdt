//
//  CNYuEBaoRequest.h
//  HYNewNest
//
//  Created by zaky on 5/14/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YEBQuarterlyInterest) {
    YEBQuarterlyInterestQ1 = 0,
    YEBQuarterlyInterestQ2 = 0,
    YEBQuarterlyInterestQ3 = 0,
    YEBQuarterlyInterestQ4 = 0
};

@interface CNYuEBaoRequest : CNBaseNetworking

+ (void)checkYuEBaoInterestLogsSumHandler:(HandlerBlock)handler;
+ (void)transferInYuEBaoAmount:(NSNumber *)amount
                       handler:(HandlerBlock)handler;
+ (void)transferOutYuEBaoAmount:(NSNumber *)amount
                        handler:(HandlerBlock)handler;
+ (void)checkYuEBaoConfigHandler:(HandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
