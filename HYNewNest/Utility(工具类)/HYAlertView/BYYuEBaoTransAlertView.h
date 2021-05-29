//
//  BYYuEBaoTransAlertView.h
//  HYNewNest
//
//  Created by zaky on 5/29/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYYuEBaoTransAlertView : HYBaseAlertView

// 如果没有利息相关的信息那就是转出到余额
+ (void)showTransAlertTransAmount:(NSNumber *)amount
                         interest:(nullable NSString *)interset
                  intersetNexTime:(nullable NSString *)timeStr;
@end

NS_ASSUME_NONNULL_END
