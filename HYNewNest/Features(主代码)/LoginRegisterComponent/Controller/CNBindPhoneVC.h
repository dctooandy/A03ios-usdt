//
//  CNBindPhoneVC.h
//  HYNewNest
//
//  Created by Cean on 2020/7/18.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseVC.h"
#import "CNLoginRequest.h"
#import "SmsCodeModel.h"

NS_ASSUME_NONNULL_BEGIN


/// 注册完成绑定手机，安全中心绑定手机，忘记密码来的 绑定新手机
@interface CNBindPhoneVC : CNBaseVC
@property (nonatomic, assign) CNSMSCodeType bindType;

@end

NS_ASSUME_NONNULL_END
