//
//  CNCompleteInfoVC.m
//  HYNewNest
//
//  Created by Cean on 2020/8/12.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNCompleteInfoVC.h"
#import "CNNormalInputView.h"
#import "CNCodeInputView.h"
#import "CNAccountInputView.h"
#import "NSString+Validation.h"
#import "CNUserCenterRequest.h"
#import "HYTextAlertView.h"

@interface CNCompleteInfoVC () <CNAccountInputViewDelegate, CNNormalInputViewDelegate, CNCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet CNNormalInputView *nameInputView;
@property (weak, nonatomic) IBOutlet CNAccountInputView *phoneInputView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeInputView;
@end

@implementation CNCompleteInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息完善";
    [self setDelegate];
    [self setOrignData];
}

#pragma mark - InputViewDelegate

- (void)setDelegate {
    self.nameInputView.delegate = self;
    self.phoneInputView.delegate = self;
    self.phoneInputView.fromServer = YES;
    self.codeInputView.delegate = self;
    [self.nameInputView setPlaceholder:@"请输入您的真实姓名"];
    [self.phoneInputView setPlaceholder:@"请输入您要绑定的手机号"];
    [self.codeInputView setPlaceholder:@"请输入验证码"];
    self.phoneInputView.fromServer = YES;
    self.codeInputView.codeType = CNCodeTypeBindPhone;
}

- (void)setOrignData {
    if ([CNUserManager shareManager].userDetail.realName.length > 0) {
        self.nameInputView.text = [CNUserManager shareManager].userDetail.realName;
        self.nameInputView.userInteractionEnabled = NO;
    }
    if ([CNUserManager shareManager].userDetail.mobileNoBind) {
        self.phoneInputView.account = [CNUserManager shareManager].userDetail.mobileNo;
        self.phoneInputView.userInteractionEnabled = NO;
        self.codeInputView.hidden = YES;
    }
}

- (void)inputViewTextChange:(CNNormalInputView *)view {
    self.submitBtn.enabled = (self.nameInputView.text.length > 0)
    && (self.phoneInputView.correct)
    && (self.codeInputView.correct);
}

- (void)accountInputViewTextChange:(CNAccountInputView *)view {
    self.codeInputView.account = view.account;
    self.submitBtn.enabled = (self.nameInputView.text.length > 0)
    && (self.phoneInputView.correct)
    && (self.codeInputView.correct);
}


- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    self.submitBtn.enabled = (self.nameInputView.text.length > 0)
    && (self.phoneInputView.correct)
    && (self.codeInputView.correct);
}


- (IBAction)submit:(id)sender {
    
    if ([CNUserManager shareManager].userDetail.realName.length == 0) {
        NSString *tip = [NSString stringWithFormat:@"您将要绑定姓名“%@”到您的账户，绑定后不可修改，且必须和提现银行卡姓名保持一致。", self.nameInputView.text];
        [HYTextAlertView showWithTitle:@"实名认证" content:tip comfirmText:@"确认" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm){
            if (isComfirm) {
                [self bindRealName];
            }
        }];
    } else {
        [self bindPhone];
    }
}

#pragma mark - Request
- (void)bindRealName {
    [CNUserCenterRequest modifyUserRealName:self.nameInputView.text gender:nil birth:nil avatar:nil onlineMessenger2:nil email:nil handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [CNHUB showSuccess:@"实名认证成功"];
            [self bindPhone];
        }
    }];
}

- (void)bindPhone {
    SmsCodeModel *smsModel = self.codeInputView.smsModel;
    if (!smsModel) {
        [CNHUB showError:@"请重新发送手机验证码"];
        return;
    }
    
    [CNLoginRequest requestPhoneBind:self.codeInputView.code
                           messageId:smsModel.messageId
                   completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                [CNLoginRequest getUserInfoByTokenCompletionHandler:nil]; // 更新信息
                [CNHUB showSuccess:@"绑定手机号成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}


@end
