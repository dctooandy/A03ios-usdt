//
//  HYVIPReceiveAlertView.h
//  HYNewNest
//
//  Created by zaky on 9/23/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYVIPReceiveAlertView : HYBaseAlertView

/// 领取礼物
+ (void)showReceiveAlertTimes:(NSInteger)times
                         gift:(NSString *)gift
               comfirmHandler:(void(^)(BOOL isComfirm))handler;

@end

NS_ASSUME_NONNULL_END
