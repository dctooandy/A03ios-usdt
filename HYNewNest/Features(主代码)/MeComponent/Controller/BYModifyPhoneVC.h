//
//  BYModifyPhoneVC.h
//  HYNewNest
//
//  Created by zaky on 6/17/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNLoginRequest.h"
#import "SmsCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYModifyPhoneVC : UIViewController
+ (void)modalVcWithSMSCodeType:(CNSMSCodeType)type;
@end

NS_ASSUME_NONNULL_END
