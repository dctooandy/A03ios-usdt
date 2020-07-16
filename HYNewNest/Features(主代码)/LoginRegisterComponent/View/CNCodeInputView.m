//
//  CNCodeInputView.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/13.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNCodeInputView.h"

int TotalSecond = 10;

@interface CNCodeInputView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLb;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
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
}

- (void)showWrongMsg:(NSString *)msg {
    self.wrongCode = YES;
    self.tipLb.text = msg;
    self.tipLb.textColor = self.wrongColor;
    self.lineView.backgroundColor = self.wrongColor;
}

- (void)setPlaceholder:(NSString *)text {
    self.inputTF.placeholder = text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tipLb.hidden = NO;
    self.tipLb.text = self.phoneLogin ? @"验证码*": @"密码*";
    self.lineView.backgroundColor = _wrongCode ? self.wrongColor: self.hilghtColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.tipLb.hidden = YES;
    self.lineView.backgroundColor = self.normalColor;
}

- (void)textFieldChange:(UITextField *)textField {
    
    NSString *text = textField.text;
    
    self.correct = (text.length >= 1);
    if (text.length >= 16) {
        textField.text = [text substringToIndex:16];
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

- (void)setPhoneLogin:(BOOL)phoneLogin {
    _phoneLogin = phoneLogin;
    self.inputTF.placeholder = phoneLogin ? @"请输入验证码": @"请输入密码";
    self.codeBtn.hidden = !phoneLogin;
    self.eyeBtn.hidden = phoneLogin;
    self.inputTF.secureTextEntry = phoneLogin ? NO: self.eyeBtn.selected;
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
//    if (![self.inputTF.text isValidPhoneNum]) {
//        [CNHUB showError:@"请输入正确的手机号"];
//        return;
//    }
    self.codeBtn.enabled = NO;
    [self.secondTimer setFireDate:[NSDate distantPast]];
    
//    __weak typeof(self) weakSelf = self;
//    [CNLoginRequest getSMSCodeWithType:CNSMSCodeTypeLogin phone:self.inputTF.text completionHandler:^(id responseObj, NSString *errorMsg) {
//        if (errorMsg) {
//            [CNHUB showError:errorMsg];
//        } else {
//            [CNHUB showSuccess:@"验证码已发送"];
//            weakSelf.codeId = [responseObj objectForKey:@"messageId"];
//        }
//    }];
}
@end
