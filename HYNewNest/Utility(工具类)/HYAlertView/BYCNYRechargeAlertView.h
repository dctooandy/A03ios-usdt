//
//  BYCNYRechargeAlertView.h
//  HYNewNest
//
//  Created by RM04 on 2021/7/14.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYCNYRechargeAlertView : HYBaseAlertView

+ (void)showAlertWithContent:(NSString *)content
                  cancelText:(NSString *)cancelText
                 confirmText:(NSString *)confirmText
              comfirmHandler:(void(^)(BOOL isComfirm))handler;

@end

NS_ASSUME_NONNULL_END
