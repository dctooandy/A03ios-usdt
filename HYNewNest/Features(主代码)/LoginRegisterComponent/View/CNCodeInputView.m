//
//  CNCodeInputView.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNCodeInputView.h"

int TotalSecond = 60;

@interface CNCodeInputView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLb;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTrailing;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;

/// 记录对错，用于UI改变风格
@property (assign, nonatomic) BOOL wrongCode;

@property (nonatomic, strong) UIColor *hilghtColor;
@property (nonatomic, strong) UIColor *wrongColor;
@property (nonatomic, strong) UIColor *normalColor;

/// 验证码定时器
@property (strong, nonatomic) NSTimer *secondTimer;
@property (assign, nonatomic) int second;

@end

@implementation CNCodeInputView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    [self.inputTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.normalColor = kHexColorAlpha(0xFFFFFF, 0.15);
    self.hilghtColor = kHexColor(0x10B4DD);
    self.wrongColor = kHexColor(0xFF5860);
    
    // 第一次不能正常
    self.correct = NO;
}

- (void)showWrongMsg:(NSString *)msg {
    self.wrongCode = YES;
    self.tipLb.hidden = NO;
    self.tipLb.text = msg;
    self.tipLb.textColor = self.wrongColor;
    self.lineView.backgroundColor = self.wrongColor;
}

- (void)setPlaceholder:(NSString *)text {
    self.inputTF.placeholder = text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    switch (_codeType) {
        case CNCodeTypeAccountRegister:
            self.tipLb.text = @"请输入字母与数字组合的密码，8位以上";
            break;
        case CNCodeTypeAccountLogin:
            self.tipLb.text = @"密码/验证码";
            self.inputTF.placeholder = @"请输入密码或手机验证码";
            break;
        case CNCodeTypeBindPhone:
        case CNCodeTypePhoneLogin:
        case CNCodeTypeBankCard:
            self.tipLb.text = @"验证码*";
            break;
        case CNCodeTypeNewPwd:
            self.tipLb.text = @"新密码*";
            break;
        case CNCodeTypeOldPwd:
            self.tipLb.text = @"旧密码*";
            break;
        default:
            break;
    }
    self.tipLb.hidden = NO;
    self.tipLb.textColor = _wrongCode? self.wrongColor :self.hilghtColor;
    self.lineView.backgroundColor = _wrongCode? self.wrongColor :self.hilghtColor;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = textField.text;
    NSString *wrongTip = @"请输入8-16位数字及字母的组合";
    switch (_codeType) {
        case CNCodeTypeBindPhone:
        case CNCodeTypePhoneLogin:
        case CNCodeTypeBankCard:
            self.correct = (text.length >= 6);
            wrongTip = @"请输入6位验证码";
            break;
        case CNCodeTypeAccountLogin:
        case CNCodeTypeAccountRegister:
        case CNCodeTypeNewPwd:
            self.correct = [text validationType:ValidationTypePassword];
            break;
        default:
            self.correct = (text.length >= 8);
            break;
    }
    if (self.correct) {
        self.tipLb.hidden = YES;
        self.lineView.backgroundColor = self.normalColor;
        self.wrongCode = NO;
    } else {
        [self showWrongMsg:wrongTip];
    }

}

- (void)textFieldChange:(UITextField *)textField {
    if (textField.text.length >= 16) {
        textField.text = [textField.text substringToIndex:16];
    }
    NSString *text = textField.text;
    
    self.lineView.backgroundColor = self.hilghtColor;
    self.tipLb.textColor = self.hilghtColor;
    self.tipLb.hidden = NO;
    
    switch (_codeType) {
        // 密码校验
        case CNCodeTypeAccountLogin:
        case CNCodeTypeAccountRegister:
        case CNCodeTypeNewPwd:
            if (text.length >= 8) { // 大于最低开始判断
                self.correct = [text validationType:ValidationTypePassword];
                if (!self.correct) {
                    [self showWrongMsg:@"请输入8-16位数字及字母的组合"];
                }
            } else {
                self.correct = NO;
            }
            break;
        // 验证码校验
        case CNCodeTypeBindPhone:
        case CNCodeTypePhoneLogin:
        case CNCodeTypeBankCard:
            if (textField.text.length >= 6) {
                self.correct = [text validationType:ValidationTypePhoneCode];
                if (!self.correct) {
                    [self showWrongMsg:@"请输入6位数字验证码"];
                }
            } else {
                self.correct = NO;
            }
            
            break;
        default:
            break;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(codeInputViewTextChange:)]) {
        [_delegate codeInputViewTextChange:self];
    }
}

- (NSString *)code {
    return [self.inputTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (IBAction)secretInput:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.inputTF.secureTextEntry = sender.selected;
}

- (void)setAccount:(NSString *)account {
    _account = account;
    if ([account hasPrefix:@"1"]) {
        self.codeType = CNCodeTypePhoneLogin;
        self.codeBtn.hidden = !(account.length > 10);
        self.inputTF.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        self.codeType = CNCodeTypeAccountLogin;
        self.codeBtn.hidden = YES;
        self.inputTF.keyboardType = UIKeyboardTypeDefault;
    }
}

#pragma - mark Timer

- (void)timerAciton {
    if (_second == 0) {
        _second = TotalSecond;
        [self.secondTimer invalidate];
        self.secondTimer = nil;
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
    } else {
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%ds", _second] forState:UIControlStateDisabled];
        _second--;
    }
}

- (NSTimer *)secondTimer {
    if (_secondTimer == nil) {
        _secondTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAciton) userInfo:nil repeats:YES];
        [_secondTimer setFireDate:[NSDate distantFuture]];
        self.second = TotalSecond;
    }
    return _secondTimer;
}

- (IBAction)sendCode:(UIButton *)sender {
    self.codeBtn.enabled = NO;
    [self.secondTimer setFireDate:[NSDate distantPast]];
    
    if (self.codeType==CNCodeTypeBankCard) {
        [CNLoginRequest getSMSCodeByLoginNameType:CNSMSCodeTypeChangeBank completionHandler:^(id responseObj, NSString *errorMsg) {
            [kKeywindow jk_makeToast:[NSString stringWithFormat:@"向手机%@\n发送了一条验证码", [CNUserManager shareManager].userDetail.mobileNo] duration:2 position:JKToastPositionCenter];
            SmsCodeModel *smsModel = [SmsCodeModel cn_parse:responseObj];
            self.smsModel = smsModel;
            if (self->_delegate && [self->_delegate respondsToSelector:@selector(didReceiveSmsCodeModel:)]) {
                [self->_delegate didReceiveSmsCodeModel:smsModel];
            }
        }];
        
    } else {
        // 发送验证码请求
        [CNLoginRequest getSMSCodeWithType:self.codeType == CNCodeTypeBindPhone?CNSMSCodeTypeBindPhone:CNSMSCodeTypeLogin
                                     phone:self.account
                         completionHandler:^(id responseObj, NSString *errorMsg) {
            [kKeywindow jk_makeToast:[NSString stringWithFormat:@"向手机%@\n发送了一条验证码", self.account] duration:2 position:JKToastPositionCenter];
            SmsCodeModel *smsModel = [SmsCodeModel cn_parse:responseObj];
            self.smsModel = smsModel;
            if (self->_delegate && [self->_delegate respondsToSelector:@selector(didReceiveSmsCodeModel:)]) {
                [self->_delegate didReceiveSmsCodeModel:smsModel];
            }
        }];
    }
}

- (void)setCodeType:(CNCodeType)codeType {
    _codeType = codeType;
    self.eyeBtn.hidden = NO;
    self.codeBtn.hidden = YES;
    switch (codeType) {
        case CNCodeTypeAccountRegister:
            self.inputTrailing.constant = 50;
            break;
        case CNCodeTypeBindPhone:
        case CNCodeTypePhoneLogin:
            self.inputTrailing.constant = 100;
            self.inputTF.placeholder = @"请输入验证码";
            self.eyeBtn.hidden = YES;
            self.inputTF.secureTextEntry = NO;
            self.codeBtn.hidden = NO;
            break;
        case CNCodeTypeAccountLogin:
            self.inputTrailing.constant = 50;
            self.inputTF.placeholder = @"请输入密码";
            self.inputTF.secureTextEntry = self.eyeBtn.selected;
            break;
        case CNCodeTypeNewPwd:
            self.inputTrailing.constant = 50;
            self.inputTF.secureTextEntry = self.eyeBtn.selected;
            self.tipLb.text = @"新密码*";
            self.tipLb.hidden = YES;
            break;
        case CNCodeTypeOldPwd:
            self.inputTrailing.constant = 50;
            self.inputTF.secureTextEntry = self.eyeBtn.selected;
            self.tipLb.text = @"旧密码*";
            self.tipLb.hidden = YES;
            break;
        case CNCodeTypeBankCard:
            self.inputTrailing.constant = 100;
            self.inputTF.placeholder = @"请输入验证码";
            self.eyeBtn.hidden = YES;
            self.inputTF.secureTextEntry = NO;
            self.codeBtn.hidden = NO;
            break;
        default:
            break;
    }
}
@end
