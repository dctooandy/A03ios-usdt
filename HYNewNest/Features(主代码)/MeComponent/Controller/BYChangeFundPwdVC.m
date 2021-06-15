//
//  BYChangeFundPwdVC.m
//  HYNewNest
//
//  Created by zaky on 6/3/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYChangeFundPwdVC.h"
#import "CNCodeInputView.h"
#import "CNAccountInputView.h"
#import "CNTwoStatusBtn.h"
#import "HYOneBtnAlertView.h"
#import "CNLoginRequest.h"

@interface BYChangeFundPwdVC () <CNCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldCodeViewHightConst;
@property (weak, nonatomic) IBOutlet CNCodeInputView *oldeCodeView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeView; //密码
@property (weak, nonatomic) IBOutlet CNCodeInputView *reCodeView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeInputView; //验证码
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;
@end

@implementation BYChangeFundPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([CNUserManager shareManager].userDetail.withdralPwdFlag) {
        self.title = @"修改资金密码";
    } else {
        self.title = @"资金密码";
        _oldeCodeView.hidden = YES;
        _oldCodeViewHightConst.constant = 0;
    }
    
    if (![CNUserManager shareManager].userDetail.mobileNoBind) {
        [HYOneBtnAlertView showWithTitle:@"温馨提示" content:@"请先绑定手机号码再设置资金密码" comfirmText:@"好的" comfirmHandler:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    
    [self addNaviRightItemWithImageName:@"service"];
    [self configUI];
    [self setDelegate];
}

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC];
}

- (void)configUI {
    [self.oldeCodeView setPlaceholder:@"请输入旧资金密码"];
    [self.codeView setPlaceholder:@"请输入新密码"];
    [self.reCodeView setPlaceholder:@"确认密码"];
    [self.reCodeView setTipsText:@"确认新资金密码*"];
    [self.codeInputView setPlaceholder:@"请输入验证码"];
    
    self.oldeCodeView.codeType = CNCodeTypeOldFundPwd;
    self.codeView.codeType = CNCodeTypeNewFundPwd;
    self.reCodeView.codeType = CNCodeTypeNewFundPwd;
    
    // 验证码须传入手机号
    self.codeInputView.account = [CNUserManager shareManager].userDetail.mobileNo;
    self.codeInputView.codeType = CNCodeTypeFundPwdSMS;
}

- (void)setDelegate {
    self.oldeCodeView.delegate = self;
    self.codeView.delegate = self;
    self.reCodeView.delegate = self;
    self.codeInputView.delegate = self;
}

#pragma mark - Action
- (IBAction)didTapSubmitBtn:(id)sender {
    // 校验 两次输入
    if (![self.codeView.code isEqualToString:self.reCodeView.code]) {
        [self.reCodeView showWrongMsg:@"两次新资金密码输入不一致 请重新输入"];
        return;
    }
    
    // 修改资金密码
    [CNLoginRequest modifyFundPwdSmsCode:self.codeInputView.code
                               messageId:self.codeInputView.smsModel.messageId
                             oldPassword:self.oldeCodeView.code
                             newPassword:self.codeView.code
                                    type:[CNUserManager shareManager].userDetail.withdralPwdFlag?@3:@4
                                 handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [CNTOPHUB showSuccess:@"资金密码设置成功！"];
            [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
            }];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - delegate
- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    // 按钮可点击条件
    if ([CNUserManager shareManager].userDetail.withdralPwdFlag) {
        self.submitBtn.enabled = self.oldeCodeView.correct && self.codeView.correct && self.reCodeView.correct && self.codeInputView.correct;
    } else {
        self.submitBtn.enabled = self.codeView.correct && self.reCodeView.correct && self.codeInputView.correct;
    }
}

@end
