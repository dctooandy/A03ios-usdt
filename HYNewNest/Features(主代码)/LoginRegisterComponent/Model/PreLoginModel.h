//
//  PreLoginModel.h
//  HYNewNest
//
//  Created by zaky on 10/23/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreLoginModel : CNBaseModel

@property (nonatomic, assign) BOOL needCaptcha;

/// 验证码类型: 1数字；2汉字
@property (nonatomic, assign) NSInteger captchaType;

@end

NS_ASSUME_NONNULL_END
