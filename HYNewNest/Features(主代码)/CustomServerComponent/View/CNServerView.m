//
//  CNServerView.m
//  HYNewNest
//
//  Created by Cean on 2020/7/24.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNServerView.h"
#import "CNAccountInputView.h"
#import "CNCodeInputView.h"
#import "CNTwoStatusBtn.h"

@interface CNServerView () <CNAccountInputViewDelegate, CNCodeInputViewDelegate>

#pragma mark - 回拨弹框属性
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet CNAccountInputView *phoneView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;

@property (nonatomic, weak) id delegate;
@end

@implementation CNServerView

- (void)loadViewFromXib {
    [super loadViewFromXib];
}

+ (void)showServerWithDelegate:(id<CNServerViewDelegate>)delegate {
    
    CNServerView *alert = [[CNServerView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    alert.frame = window.bounds;
    [window addSubview:alert];
    
    alert.delegate = delegate;
    [alert configUI];
}

- (void)configUI {
    self.phoneView.fromServer = YES;
    [self.phoneView setPlaceholder:@"请输入您想接通的电话"];
    self.codeView.codeType = CNCodeTypePhoneLogin;
    [self.codeView setPlaceholder:@"6位数字验证码"];
    [self setDelegate];
    [self addKeyboardNotification];
    [self buttonArrayAnimation];
}

/// 出现动画
- (void)buttonArrayAnimation {
    self.bottom.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - button Action

// 回拨提交
- (IBAction)submitAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(serverView:callBack:code:messageId:)]) {
        [_delegate serverView:self
                     callBack:self.phoneView.account
                         code:self.codeView.code
                    messageId:self.codeView.smsModel.messageId];
        [self close:nil];
    }
}

- (IBAction)dialBindedPhone:(id)sender {
    if (![CNUserManager shareManager].isLogin) {
        [CNTOPHUB showError:@"您未登录 请输入要回拨的手机号后提交"];
        return;
    }
    if (![CNUserManager shareManager].userDetail.mobileNoBind) {
        [CNTOPHUB showError:@"您未绑定手机号 请先到“我的-安全中心“绑定"];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(serverViewWillDialBindedPhone)]) {
        [_delegate serverViewWillDialBindedPhone];
        [self close:nil];
    }
}

// 关闭页面
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}

#pragma mark - InputViewDelegate

- (void)setDelegate {
    self.phoneView.delegate = self;
    self.codeView.delegate = self;
}

- (void)accountInputViewTextChange:(CNAccountInputView *)view {
    self.submitBtn.enabled = view.correct && self.codeView.correct;
    self.codeView.account = view.account;
}

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    self.submitBtn.enabled = view.correct && self.phoneView.correct;
}

#pragma mark - KeyboardNotification

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notifi {
    NSDictionary *dic = notifi.userInfo;
    NSInteger animationType = [dic[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [dic[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottom.constant = rect.size.height;
    [UIView animateWithDuration:duration delay:0 options:animationType animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notifi {
    NSInteger animationType = [notifi.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [notifi.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.bottom.constant = 0;
    [UIView animateWithDuration:duration delay:0 options:animationType animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
