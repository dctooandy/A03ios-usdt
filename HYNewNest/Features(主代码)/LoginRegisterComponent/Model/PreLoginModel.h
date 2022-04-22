//
//  PreLoginModel.h
//  HYNewNest
//
//  Created by zaky on 10/23/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CNCaptchaType) {
    CNCaptchaTypeNone = 0,
    CNCaptchaTypeDigital = 1,   // 数字验证
    CNCaptchaTypeChinese = 2,   // 汉字验证
    CNCaptchaTypePuzzle = 3,    // 滑块拼图验证
};

@interface PreLoginModel : CNBaseModel

/// 登录是否需要图形验证码
@property (nonatomic, assign) BOOL needCaptcha;

/// 验证码类型: 1数字；2汉字；3滑块拼图
@property (nonatomic, assign) CNCaptchaType captchaType;

@end

NS_ASSUME_NONNULL_END
