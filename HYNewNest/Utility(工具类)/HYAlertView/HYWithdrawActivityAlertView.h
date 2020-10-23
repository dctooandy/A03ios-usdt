//
//  HYWithdrawActivityAlertView.h
//  HYNewNest
//
//  Created by zaky on 10/17/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYWithdrawActivityAlertView : HYBaseAlertView

+ (void)showWithAmountPercent:(NSInteger)aPercent
                  giftPercent:(NSInteger)gPercent
                   mostAmount:(NSInteger)mAmount
                      handler:(void(^)(void))handler;

+ (void)showHandedOutGiftUSDTAmount:(NSString *)amount
                            handler:(void(^)(void))handler;

@end

NS_ASSUME_NONNULL_END
