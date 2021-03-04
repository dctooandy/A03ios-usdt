//
//  HYUpdateAlertView.h
//  HYNewNest
//
//  Created by zaky on 8/19/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

/// 更新弹窗, 首充弹窗
@interface HYUpdateAlertView : HYBaseAlertView


+ (void)showWithVersionString:(NSString *)string isForceUpdate:(BOOL)isForce handler:(void(^)(BOOL isComfirm))handler;

+ (void)showFirstDepositHandler:(void(^)(BOOL isComfm))handler;
@end

NS_ASSUME_NONNULL_END
