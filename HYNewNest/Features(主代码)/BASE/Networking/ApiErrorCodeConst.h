//
//  ApiErrorCodeConst.h
//  INTEDSGame
//
//  Created by Robert on 19/04/2018.
//  Copyright © 2018 INTECH. All rights reserved.
//

#ifndef ApiErrorCodeConst_h
#define ApiErrorCodeConst_h
// 密码不能为空,长度必须为32
#define LoginPassNULL_ErrorCode @"WS_202003"

// 会员账号不存在
#define UserNameNotHave_ErrorCode @"WS_202006"

// 密码不正确
#define LoginPassIncorrect_ErrorCode @"WS_202018"

// 原密码已过期
#define LoginPassExpired_ErrorCode @"GW_800404"

// 密码输错超过最大次数,会员账号已被锁住，请五分钟后再试或联系客服
#define LoginPassIncorrectMax_ErrorCode @"WS_202020"

// 您好，该账号已停止使用，请联系客服，谢谢！
#define UserNameNonUse_ErrorCode @"WS_202015"

// 用户名注册时，用户名重复错误码
#define RegisterUserNameRepeat_ErrorCode @"WS_201713"

// 系统繁忙，请稍后再试
#define SystemBusy_ErrorCode @"GW_999999"

// 手机号已注册
#define PhoneRegisterRepeat_ErrorCode @"GW_800518"

//关闭手机号登录的时候 尚未设置密码
#define UnActivePhoneNum_noPassword_errorCode @"WS_307038"

// 手机号已被其他用户绑定
#define PhoneAlreadyBind_ErrorCode @"GW_800503"

/** 验证码错误 */
#define VerifyCodeWrong_ErrorCode @"WS_300027"

// 该手机绑定多账号
#define PhoneBindMoreAccount_ErrorCode @"GW_800507"

// 未发现激活状态账号
#define PhoneNumNotActive_ErrorCode @"GW_800517"

// 单设备登陆
#define SingleDeviceLogin_ErrorCode @"GW_890206"

// 图形验证码不能为空
#define ImageCodeNULL_ErrorCode @"GW_800101"

// 图形验证码输入错误
#define ImageCodeWrong_ErrorCode @"GW_800102"

// 图形验证码不存在
#define ImageCodeNotHave_ErrorCode @"GW_800103"

// 图形验证码已被使用
#define ImageCodeAleradyUse_ErrorCode @"GW_800104"

// 图形验证码已过期
#define ImageCodeExpired_ErrorCode @"GW_800104"

// 访问凭证为空
#define TokenEmpty_ErrorCode @"GW_890201"

// 无效访问凭证
#define TokenInvalid_ErrorCode @"GW_890202"

// 访问凭证过期
#define TokenExpired_ErrorCode @"GW_890203"

// 访问凭证被禁止
#define TokenForbid_ErrorCode @"GW_890204"

// 凭证不匹配
#define TokenNotMatch_ErrorCode @"GW_890205"

// 凭证不匹配
#define TokenFailure_ErrorCode @"GW_890209"

// 多次密码错误 
#define LoginWrongPswMultiTimes_ErroCode @"GW_800408"

// 手机号未绑定
#define LoginPhoneNumberNotBind_ErroCode @"GW_800501"

// 注册--登录名已存在
#define RegistUsernameExits_ErroCode @"GW_890408"

// 获取不到App的版本号
#define NotFound_ErroCode @"GWX_601532"

// 客户使用同一个商户存款10次失败 (您已操作多次未存款，该方式次数已达上限，请联系客服)
#define RechargeOverTry_ErroCode @"GW_801102"

// 非法访问
#define IlleigalAccess_ErroCode @"GW_899998"

// 登录名不匹配
#define Network_LoginName_ErroCode @"GW_890406"

// 超时
#define Network_TimeOut_ErroCode @"-1001"

#endif /* ApiErrorCodeConst_h */
