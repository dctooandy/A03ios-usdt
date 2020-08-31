//
//  CNVerifyMsgAlertView.m
//  HYNewNest
//
//  Created by Cean on 2020/8/6.
//  Copyright © 2020 emneoma. All rights reserved.
//


#import "CNVerifyMsgAlertView.h"
#import "JHVerificationCodeView.h"

@interface CNVerifyMsgAlertView ()
@property (weak, nonatomic) IBOutlet UIView *shakingView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
/// 电话号码
@property (nonatomic, copy) NSString *phone;
/// 发送验证码回调
@property (nonatomic, copy) dispatch_block_t sendCodeBlock;
/// 确认回调
@property (nonatomic, copy) void(^finishBlock)(NSString *smsCode);

@property (strong, nonatomic) JHVerificationCodeView *codeView;
@property (nonatomic, copy) NSString *smsCode;

/// 验证码定时器
@property (strong, nonatomic) NSTimer *secondTimer;
@property (assign, nonatomic) int second;
@end

@implementation CNVerifyMsgAlertView

+ (CNVerifyMsgAlertView *)showPhone:(NSString *)phone
       reSendCode:(nonnull dispatch_block_t)sendCodeBlock
           finish:(nonnull void (^)(NSString * _Nonnull))finishBlock {
    
    CNVerifyMsgAlertView *alert = [[CNVerifyMsgAlertView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    alert.phone = phone;
    alert.sendCodeBlock = sendCodeBlock;
    alert.finishBlock = finishBlock;
    [alert sendCode:alert.codeBtn];
    
    [alert initCodeView];
    
    return alert;
}

- (void)resetCodeView {
    _second = 0;
    [self timerAciton];
    [self.codeView clear];
}

+ (void)removeAlertView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[CNVerifyMsgAlertView class]]) {
            [view removeFromSuperview];
        }
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
    frame.size.width = kScreenWidth - 80;
    
    JHVerificationCodeView *view =
    [[JHVerificationCodeView alloc] initWithFrame:frame config:config];
    __weak typeof(self) weakSelf = self;
    view.finishBlock = ^(NSString *code) {
        weakSelf.smsCode = code;
    };
    [self.shakingView addSubview:view];
    self.codeView = view;
}


#pragma mark - button Action

// 发送验证码
- (IBAction)sendCode:(UIButton *)sender {
    _second = 60;
    self.codeBtn.enabled = NO;
    [self.secondTimer setFireDate:[NSDate distantPast]];
    // 发送验证码
    !_sendCodeBlock ?: _sendCodeBlock();
    
    [self.codeView clear];
    [self.codeView becomeFirstResponder];
}

// 提交
- (IBAction)submitAction:(UIButton *)sender {
    !_finishBlock ?: _finishBlock(self.smsCode);
}

// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    NSString *tem = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.phoneLb.text = [NSString stringWithFormat:@"我们向手机%@发送了一条验证码", tem];
}

#pragma - mark Timer

- (void)timerAciton {
    if (_second == 0) {
        _second = 60;
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
        self.second = 60;
    }
    return _secondTimer;
}
@end
