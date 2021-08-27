//
//  BYUSDTRechargeAlertView.h
//  HYNewNest
//
//  Created by RM04 on 2021/8/27.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYUSDTRechargeAlertView : HYBaseAlertView
+ (void)showAlertWithContent:(NSString *)content
                 confirmText:(NSString *)confirmText
              comfirmHandler:(void(^)(BOOL isComfirm))handler;

@end

NS_ASSUME_NONNULL_END
