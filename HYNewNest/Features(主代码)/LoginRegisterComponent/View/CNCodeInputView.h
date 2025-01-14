//
//  CNCodeInputView.h
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseXibView.h"
#import "SmsCodeModel.h"
#import "CNLoginRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CNCodeType) {
    CNCodeTypePhoneLogin,       //手机登录
    CNCodeTypeAccountLogin,     //账号登录
    CNCodeTypeAccountRegister,  //账号注册
    CNCodeTypeNewPwd,           //修改密码
    CNCodeTypeOldPwd,           //旧密码
    CNCodeTypeBankCard,         //绑定提现地址短信验证码
    CNCodeTypeBindPhone,        //绑定手机
    CNCodeTypeBindPhoneWithPhone,//用LoginName绑定手机
    CNCodeTypeOldFundPwd,       //资金密码旧
    CNCodeTypeNewFundPwd,       //资金密码
    CNCodeTypeFundPwdSMS,       //发送资金密码短信验证码
    CNCodeTypeUnbind,           //修改手机1
    CNCodeTypeChangePhone,     //修改手机2
    CNCodeTypecModifyBankCard   //修正银行卡短信验证码
};

@class CNCodeInputView;
@protocol CNCodeInputViewDelegate
- (void)codeInputViewTextChange:(CNCodeInputView *)view;
@optional
- (void)didReceiveSmsCodeModel:(SmsCodeModel *)model;
@end

@interface CNCodeInputView : CNBaseXibView
/// 验证码/密码
@property (nonatomic, readonly) NSString *code;
/// 密码输入是否符合规则
@property (nonatomic, assign) BOOL correct;
/// 传入的账号/手机号 登录用
@property (nonatomic, copy) NSString *account;
/// 非登录用
@property (nonatomic, copy) NSString *mobileNum;
@property (copy,nonatomic) NSString *validateId; //!<修改手机第二次发送短信需要传这个

@property (nonatomic, strong) SmsCodeModel *smsModel;

@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) CNCodeType codeType;

- (void)showWrongMsg:(NSString *)msg;
- (void)setPlaceholder:(NSString *)text;
- (void)setTipsText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
