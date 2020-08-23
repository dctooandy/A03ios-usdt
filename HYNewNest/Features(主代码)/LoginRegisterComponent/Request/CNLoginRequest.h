//
//  CNLoginRequest.h
//  LCNewApp
//
//  Created by cean.q on 2019/11/25.
//  Copyright © 2019 B01. All rights reserved.
//

#import "CNBaseNetworking.h"
#import "SmsCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CNImageCodeType) {
    CNImageCodeTypeRegister = 1,
    CNImageCodeTypeLogin = 2,
    CNImageCodeTypeForgotPassword = 3,
    CNImageCodeTypeOther = 9,
};

typedef NS_ENUM(NSUInteger, CNSMSCodeType) {
    CNSMSCodeTypeRegister = 1,
    CNSMSCodeTypeLogin = 2,
    CNSMSCodeTypeBindPhone = 3,
    CNSMSCodeTypeForgotPassword = 4, //找回密码
    CNSMSCodeTypeChangePhone = 5, //手机修改
    CNSMSCodeTypeUnbind = 6, //手机解绑
    CNSMSCodeTypeChangeInfo = 7, // 资料修改
    CNSMSCodeTypeChangeBank = 8, // 银行卡修改
    CNSMSCodeTypeNormalVerify = 9,
    CNSMSCodeTypeChangePwd = 10, //密码修改
    CNSMSCodeTypeForgotAccount = 11,
};

@interface CNLoginRequest : CNBaseNetworking

/// 获取图片验证码
/// @param type CNImageCodeType 类型
/// @param completionHandler 完成回调
+ (void)getImageCodeWithType:(CNImageCodeType)type
           completionHandler:(HandlerBlock)completionHandler;


/// 通过手机号码获取短信验证码
/// @param type CNSMSCodeType 类型
/// @param phone 手机号码
/// @param completionHandler 完成回调
+ (void)getSMSCodeWithType:(CNSMSCodeType)type
                     phone:(NSString *)phone
         completionHandler:(HandlerBlock)completionHandler;


/// 通过用户名获取短信验证码
/// @param type 类型
/// @param completionHandler 回调
+ (void)getSMSCodeByLoginNameType:(CNSMSCodeType)type
                completionHandler:(HandlerBlock)completionHandler;


/// 验证手机验证码
/// @param type CNSMSCodeType 类型
/// @param smsCode 短信验证码
/// @param smsCodeId 获取短信验证码接口返回
/// @param completionHandler 完成回调
+ (void)verifySMSCodeWithType:(CNSMSCodeType)type
                      smsCode:(NSString *)smsCode
                    smsCodeId:(NSString *)smsCodeId
            completionHandler:(HandlerBlock)completionHandler;


/// 账号预登录，判断是否需要图形验证码
/// @param account 账户名
/// @param completionHandler 完成回调
//+ (void)accountPreLogin:(NSString *)account
//      completionHandler:(HandlerBlock)completionHandler;


/// 账户登录
/// @param account 账户名或手机号（手机当做账号）
/// @param password 密码或sms验证码
/// @param imageCode 图形验证码
/// @param imageCodeId 图形验证码id
/// @param completionHandler 完成回调
+ (void)accountLogin:(NSString *)account
            password:(NSString *)password
           messageId:(NSString *)messageId
           imageCode:(NSString *)imageCode
         imageCodeId:(NSString *)imageCodeId
   completionHandler:(HandlerBlock)completionHandler ;


/// 多账户登录
/// @param loginName 选中的用户名
/// @param completionHandler 完成回调
+ (void)mulLoginSelectedLoginName:(NSString *)loginName
                        messageId:(NSString *)messageId
                       validateId:(NSString *)validateId
                completionHandler:(HandlerBlock)completionHandler;


/// 创建试玩账号
/// @param completionHandler 回调
//+ (void)creatTryAcountCompletionHandler:(HandlerBlock)completionHandler;

/// 手机登录
/// @param smsCode 短信验证码
/// @param smsCodeId 获取短信验证码接口返回
/// @param validateId 从验证手机验证码接口获取
/// @param completionHandler 完成回调
//+ (void)phoneLoginSmsCode:(NSString *)smsCode
//                smsCodeId:(NSString *)smsCodeId
//               validateId:(NSString *)validateId
//        completionHandler:(HandlerBlock)completionHandler;


/// 账号注册
+ (void)accountRegisterUserName:(NSString *)loginName
                       password:(NSString *)password
              completionHandler:(HandlerBlock)completionHandler;


/// 手机注册
/// @param smsCode 短信验证码
/// @param smsCodeId 获取短信验证码接口返回
/// @param password 注册密码
/// @param validateId 从验证手机验证码接口获取
/// @param completionHandler 完成回调
//+ (void)phoneRegisterSmsCode:(NSString *)smsCode
//                   smsCodeId:(NSString *)smsCodeId
//                    password:(NSString *)password
//                  validateId:(NSString *)validateId
//           completionHandler:(HandlerBlock)completionHandler;

/// 修改临时用户的账号或密码（注册成功使用）
/// @param loginName 旧登录名
/// @param newLoginName 新登录名
/// @param password 登录密码
/// @param completionHandler 完成回调
//+ (void)modifyLoginName:(NSString *)loginName
//           newLoginName:(NSString *)newLoginName
//               password:(NSString *)password
//      completionHandler:(HandlerBlock)completionHandler;


/// 修改登录密码
/// @param oldPassword 旧密码
/// @param newPassword 新密码
/// @param completionHandler 完成回调
+ (void)modifyPassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
     completionHandler:(HandlerBlock)completionHandler;


/// 找回密码（忘记密码）第一步
+ (void)forgetPasswordValidateSmsCode:(NSString *)smsCode
                            messageId:(NSString *)messageId
                             phoneNum:(NSString *)phone
                    completionHandler:(HandlerBlock)completionHandler;

/// 找回密码（忘记密码）第二步
+ (void)modifyPasswordLoginName:(NSString *)loginName
                      smsCode:(NSString *)smsCode
                  newPassword:(NSString *)newPassword
                   validateId:(NSString *)validateId
                    messageId:(NSString *)messageId
            completionHandler:(HandlerBlock)completionHandler;


/*
 ** 手机号绑定
 */
+ (void)requestPhoneBind:(NSString*)smsCode
               messageId:(NSString *)messageId
       completionHandler:(HandlerBlock)completionHandler;

/*
 ** 修改绑定手机号
 */
+ (void)requestRebindPhone:(NSString*)smsCode
                 messageId:(NSString *)messageId
         completionHandler:(HandlerBlock)completionHandler;

/*
** 根据token获取用户信息
*/
+ (void)getUserInfoByTokenCompletionHandler:(nullable HandlerBlock)completionHandler;

/*
 ** 登出
 */
+ (void)logoutHandler:(HandlerBlock)completionHandler;


#pragma mark VIP & Swtich Accoutn
/// 检查是否VIP客户
//+ (void)checkTopDomainSuccessHandler:(nullable HandlerBlock)completionHandler;

/// 切换影子账户
+ (void)switchAccountSuccessHandler:(HandlerBlock)completionHandler;


@end

NS_ASSUME_NONNULL_END
