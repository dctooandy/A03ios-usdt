//
//  CNBindPhoneVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/18.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBindPhoneVC.h"
#import "JHVerificationCodeView.h"
#import "CNTwoStatusBtn.h"
#import "CNBaseTF.h"
#import "BYRegisterSuccADVC.h"

@interface CNBindPhoneVC () <UITextFieldDelegate>
@property (strong, nonatomic) JHVerificationCodeView *codeView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgv;

@property (weak, nonatomic) IBOutlet UIView *shakingView;
@property (weak, nonatomic) IBOutlet CNBaseTF *inputTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *jumbBtn;
/// 手机输入提示语
@property (weak, nonatomic) IBOutlet UILabel *phoneInputTip;
/// 验证码提示输入标签
@property (weak, nonatomic) IBOutlet UILabel *codeTip;
/// 发送验证码后提示语
@property (weak, nonatomic) IBOutlet UILabel *sendTipLb;
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

@implementation CNBindPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.inputTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    self.normalColor = kHexColorAlpha(0xFFFFFF, 0.15);
    self.hilghtColor = kHexColor(0x10B4DD);
    self.wrongColor = kHexColor(0xFF5860);
    self.submitBtn.enabled = NO;
    
    // 不同来源UI差别
    [self configDifferentUI];
}

- (void)configDifferentUI {
            self.view.backgroundColor = kHexColor(0x212137);
            self.navBarTransparent = YES;
            self.makeTranslucent = YES;
            [self addNaviLeftItemNil];
            
            self.bgImgv.hidden = NO;
            self.titleLb.hidden = NO;
            self.jumbBtn.hidden = NO;
            
            self.submitBtn.enabled = YES;
            [self.submitBtn setTitle:@"" forState:UIControlStateNormal];
            [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"h5"] forState:UIControlStateNormal];
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
        [weakSelf.submitBtn setBackgroundImage:[UIImage imageNamed:@"h5"] forState:UIControlStateNormal];
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
    self.phoneInputTip.hidden = YES;
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


#pragma mark - Action

/// 发送短信验证码
- (IBAction)sendSmsCode:(UIButton *)sender {

    WEAKSELF_DEFINE
    [CNLoginRequest getSMSCodeWithType:CNSMSCodeTypeBindPhone
                                 phone:self.inputTF.text
                            validateId:@""
                     completionHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        SmsCodeModel *smsModel = [SmsCodeModel cn_parse: responseObj];
        strongSelf.smsModel = smsModel;
        
        sender.enabled = NO;
        [strongSelf didSendCodeUIChange];
    }];
}

// 高亮变化, 界面UI变化
- (void)didSendCodeUIChange {
    self.codeTip.hidden = YES;
    self.sendTipLb.hidden = NO;
    NSString *lastForth = [self.inputTF.text substringFromIndex:(self.inputTF.text.length-4)];
    self.sendTipLb.text = [NSString stringWithFormat:@"我们已向您的尾号为%@的手机发送验证码，\n请在下方，输入6位短信验证码*", lastForth];
    [self.codeView clear];
    [self.codeView becomeFirstResponder];
    
    [self initCodeView];
    [self.secondTimer setFireDate:[NSDate distantPast]];
}

/// 校验短信验证码: 提交
- (IBAction)verfiSmsCode:(UIButton *)sender {
    if (!self.smsModel) {
        [CNTOPHUB showAlert:@"请输入手机号和验证码"];
        return;
    }

    [CNLoginRequest requestPhoneBind:self.smsModel.smsCode
                           messageId:self.smsModel.messageId
                   completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            // 更新信息
            [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
                [CNTOPHUB showSuccess:@"绑定成功"];
                
                    [self.navigationController pushViewController:[BYRegisterSuccADVC new] animated:YES];
                
            }];
        }
    }];

}

/// 跳过
- (IBAction)pass:(id)sender {
    // 跳过绑定，登录成功，回到首页
    [self.navigationController pushViewController:[BYRegisterSuccADVC new] animated:YES];
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
