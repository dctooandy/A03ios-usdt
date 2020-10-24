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

@property(nonatomic,copy) NSString *smsCode; //自己填 验证码

@end

NS_ASSUME_NONNULL_END
