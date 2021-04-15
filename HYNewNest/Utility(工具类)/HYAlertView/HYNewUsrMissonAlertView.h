//
//  HYNewUsrMissonAlertView.h
//  HYNewNest
//
//  Created by zaky on 4/15/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYNewUsrMissonAlertView : HYBaseAlertView

// 新手任务
+ (void)showFirstDepositOrTaskEndIsEnd:(BOOL)isTaskEnd handler:(void(^)(BOOL isComfm))handler;

@end

NS_ASSUME_NONNULL_END
