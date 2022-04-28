//
//  CNCaptchaRequest.h
//  HYNewNest
//
//  Created by Kevin on 2022/4/21.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNBaseNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNCaptchaRequest : CNBaseNetworking

/// 获取滑块拼图验证码
/// @param type CNImageCodeType 类型[1:注册;2:登录;3忘记密码]
/// @param completionHandler 完成回调
+ (void)getPuzzleImageCode:(NSUInteger)type
         completionHandler:(HandlerBlock)completionHandler;

/// 校验滑块拼图
/// @param captcha 验证码值 ( { x: 44, y: 55} convert to Base64 )
/// @param captchaId 对应生成验证码接口返回的 captchaId
/// @param completionHandler 完成回调
+ (void)verifyPuzzleImageCode:(NSUInteger)type
                      captcha:(NSString *)captcha
                    captchaId:(NSString *)captchaId
                      handler:(HandlerBlock)completionHandler;
@end

NS_ASSUME_NONNULL_END
