//
//  SmsCodeModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/21.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 短信验证码模型
@interface SmsCodeModel : CNBaseModel

@property(nonatomic,copy) NSString *expire;
@property(nonatomic,copy) NSString *messageId;
@property(nonatomic,copy) NSString *validateId;
@property(nonatomic,copy) NSString *mobileNo;

@property(copy,nonatomic) NSString *loginName; //异地登陆model会回传

@property(nonatomic,copy) NSString *smsCode; //自己填 验证码 用于传递模型

@end

NS_ASSUME_NONNULL_END
