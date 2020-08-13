//
//  CNBindPhoneVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/18.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNForgotCodeVC.h"
#import "JHVerificationCodeView.h"
#import "CNTwoStatusBtn.h"
#import "CNBaseTF.h"
#import "CNResetPwdVC.h"
#import "CNLoginRequest.h"
#import "SmsCodeModel.h"
#import "CNBindPhoneVC.h"

@interface CNForgotCodeVC () <UITextFieldDelegate>
@property (strong, nonatomic) JHVerificationCodeView *codeView;
@property (weak, nonatomic) IBOutlet UIView *shakingView;
@property (weak, nonatomic) IBOutlet CNBaseTF *inputTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
/// 手机输入提示语
@property (weak, nonatomic) IBOutlet UILabel *phoneInputTip;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
/// 记录对错，用于UI改变风格
@property (assign, nonatomic) BOOL wrongAccout;
@property (nonatomic, strong) UIColor *hilghtColor;
@property (nonatomic, strong) UIColor *wrongColor;
@property (nonatomic, strong) UIColor *normalColor;

/// 验证码定时器
@property (strong, nonatomic) NSTimer *secondTimer;
@property (assign, nonatomic) int second;

@property (nonatomic, strong) SmsCodeModel *smsModel;
@end

@implementation CNForgotCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navBarTransparent = YES;
//    self.makeTranslucent = YES;
    self.view.backgroundColor = kHexColor(0x212137);
    
    [self.inputTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    self.normalColor = kHexColorAlpha(0xFFFFFF, 0.15);
    self.hilghtColor = kHexColor(0x10B4DD);
    self.wrongColor = kHexColor(0xFF5860);
    // 不同来源UI差别
    [self configDifferentUI];
}

- (void)configDifferentUI {
    switch (self.bindType) {
        // 登录来的忘记密码，完成后跳转至密码重设
        case CNSMSCodeTypeForgotPassword:
            break;
        // 安全中心来的，修改绑定手机号，完成后跳转至新绑定手机 CNBindPhoneVC
        case CNSMSCodeTypeChangePhone:
            self.titleLb.hidden = YES;
            self.title = @"手机号修改";
            break;
        default:
            break;
    }
}

- (void)initCodeView {
    if (self.codeView != nil) {
        return;
    }
    
    JHVCConfig *config     = [[JHVCConfig alloc] init];
    config.inputBoxNumber  = 6;
    config.inputBoxSpacing = 15;
    config.inputBoxWidth   = 40;
    config.inputBoxHeight  = 40;
    config.tintColor       = kHexColor(0x10B4DD);
    config.secureTextEntry = NO;
    config.inputBoxColor   = [UIColor clearColor];
    config.font            = [UIFont systemFontOfSize:26 weight:UIFontWeightMedium];
    config.textColor       = kHexColorAlpha(0xFFFFFF, 0.9);
    config.inputType       = JHVCConfigInputType_Number;
    config.keyboardType    = UIKeyboardTypeNumberPad;
    
    config.inputBoxBorderWidth  = 1;
    config.showUnderLine = YES;
    config.underLineSize = CGSizeMake(40, 1);
    config.underLineColor = kHexColorAlpha(0xFFFFFF, 0.15);
    config.underLineHighlightedColor = kHexColor(0x10B4DD);
    config.autoShowKeyboard = YES;
    
    CGRect frame = self.shakingView.bounds;
    frame.size.width = self.view.frame.size.width - 60;
    
    JHVerificationCodeView *view =
    [[JHVerificationCodeView alloc] initWithFrame:frame config:config];
    __weak typeof(self) weakSelf = self;
    view.finishBlock = ^(NSString *code) {
        weakSelf.submitBtn.enabled = YES;
        weakSelf.smsModel.smsCode = code;
    };
    [self.shakingView addSubview:view];
    self.codeView = view;
}

#pragma - mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.phoneInputTip.hidden = NO;
    self.lineView.backgroundColor = _wrongAccout ? self.wrongColor: self.hilghtColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.lineView.backgroundColor = self.normalColor;
}

- (void)textFieldChange:(UITextField *)textField {
    
    NSString *text = textField.text;
    
    if (text.length < 11) {
        self.phoneInputTip.text = @"请输入您的常用手机号码**";
        self.sendCodeBtn.hidden = YES;
        self.lineView.backgroundColor = self.hilghtColor;
        self.phoneInputTip.textColor = self.hilghtColor;
        self.wrongAccout = NO;
        return;
    }
    
    textField.text = [text substringToIndex:11];
    
    // 校验手机号规格
    BOOL inputRight = [textField.text validationType:ValidationTypePhone];
    self.phoneInputTip.text = inputRight ? @"手机号码格式正确**": @"您输入的手机号码不符合规则*";
    self.sendCodeBtn.hidden = !inputRight;
    self.lineView.backgroundColor = inputRight ? self.hilghtColor: self.wrongColor;
    self.phoneInputTip.textColor = self.lineView.backgroundColor;
    self.wrongAccout = !inputRight;
}

/// 发送短信验证码
- (IBAction)sendSmsCode:(UIButton *)sender {
    WEAKSELF_DEFINE
    // 请求短信
    [CNLoginRequest getSMSCodeWithType:self.bindType
                                 phone:self.inputTF.text
                     completionHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        
        strongSelf.smsModel = [SmsCodeModel cn_parse:responseObj];
        // 高亮变化, 界面UI变化
        NSString *lastForth = [self.inputTF.text substringFromIndex:(self.inputTF.text.length-4)];
        strongSelf.phoneInputTip.text = [NSString stringWithFormat:@"短信验证验证码已发送至：\n****%@", lastForth];
        strongSelf.inputTF.hidden = YES;
        strongSelf.lineView.hidden = YES;
        [strongSelf.codeView clear];
        [strongSelf initCodeView];
        strongSelf.submitBtn.enabled = NO;
        sender.enabled = NO;
        [strongSelf.secondTimer setFireDate:[NSDate distantPast]];
    }];
    
}

/// 校验短信验证码
- (IBAction)verfiSmsCode:(UIButton *)sender {
    if (self.smsModel.smsCode.length <= 0) {
        [CNHUB showError:@"请重新输入验证码"];
        return;
    }
    WEAKSELF_DEFINE
    if (self.bindType == CNSMSCodeTypeForgotPassword) {
        [CNLoginRequest forgetPasswordValidateSmsCode:self.smsModel.smsCode
                                            messageId:self.smsModel.messageId
                                             phoneNum:self.inputTF.text
                                    completionHandler:^(id responseObj, NSString *errorMsg) {
            STRONGSELF_DEFINE
            if (KIsEmptyString(errorMsg)) {
                CNResetPwdVC *vc = [CNResetPwdVC new];
                vc.smsCode = strongSelf.smsModel.smsCode;
                vc.fpwdModel = [SamePhoneLoginNameModel cn_parse:responseObj];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        
    } else {
        [CNLoginRequest verifySMSCodeWithType:self.bindType
                                      smsCode:self.smsModel.smsCode
                                    smsCodeId:self.smsModel.messageId
                            completionHandler:^(id responseObj, NSString *errorMsg) {
            STRONGSELF_DEFINE
            if (KIsEmptyString(errorMsg)) {
                CNBindPhoneVC *bindVc = [CNBindPhoneVC new];
                bindVc.bindType = CNSMSCodeTypeBindPhone;
                [strongSelf.navigationController pushViewController:bindVc animated:YES];
            }
        }];
    }
}

#pragma - mark Timer

- (void)timerAciton {
    if (_second == 0) {
        _second = 60;
        [self.secondTimer invalidate];
        self.secondTimer = nil;
        self.sendCodeBtn.enabled = YES;
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"重新发送"] forState:UIControlStateNormal];
    } else {
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%ds", _second] forState:UIControlStateDisabled];
        _second--;
    }
}

- (NSTimer *)secondTimer {
    if (_secondTimer == nil) {
        _secondTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAciton) userInfo:nil repeats:YES];
        [_secondTimer setFireDate:[NSDate distantFuture]];
        self.second = 60;
    }
    return _secondTimer;
}

@end
