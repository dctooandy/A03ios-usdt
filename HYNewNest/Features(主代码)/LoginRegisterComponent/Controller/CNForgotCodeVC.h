//
//  CNBindPhoneVC.h
//  HYNewNest
//
//  Created by Cean on 2020/7/18.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseVC.h"
#import "CNLoginRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNForgotCodeVC : CNBaseVC
@property (nonatomic, assign) CNSMSCodeType bindType;
@end

NS_ASSUME_NONNULL_END
