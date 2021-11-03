//
//  BYDeleteBankCardVC.m
//  HYNewNest
//
//  Created by RM03 on 2021/10/29.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYDeleteBankCardVC.h"
#import "CNCodeInputView.h"
#import "CNAccountInputView.h"
#import "CNTwoStatusBtn.h"
#import "HYOneBtnAlertView.h"
#import "CNLoginRequest.h"
#import "CNWDAccountRequest.h"


@interface BYDeleteBankCardVC () <CNCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldCodeViewHightConst;
@property (weak, nonatomic) IBOutlet CNCodeInputView *oldeCodeView;
@property (weak, nonatomic) IBOutlet CNAccountInputView *accountInputView; //密码
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeInputView; //验证码
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;

@property (nonatomic, strong) AccountModel* currentAccountModel;
@property (nonatomic,copy) HandlerBlock backHandlerBlock;
@property (nonatomic, strong) SmsCodeModel *smsModel;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *validateId;
@end

@implementation BYDeleteBankCardVC

+ (void)modalVcWithBankModel:(AccountModel*) accounts handler:(HandlerBlock)handler {
    BYDeleteBankCardVC *vc = [BYDeleteBankCardVC new];
    vc.currentAccountModel = accounts;
    vc.backHandlerBlock = handler;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [NNControllerHelper getCurrentViewController].definesPresentationContext = YES;
    [kCurNavVC presentViewController:vc animated:YES completion:^{
        vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"删除银行卡";
    
    if (![CNUserManager shareManager].userDetail.mobileNoBind) {
        [HYOneBtnAlertView showWithTitle:@"温馨提示" content:@"请先绑定手机号码再设置资金密码" comfirmText:@"好的" comfirmHandler:^{
//            [self.navigationController popViewControllerAnimated:YES];
            [self dismissBtnClicked:nil];
        }];
        return;
    }
    
    [self configUI];
    [self setDelegate];
}

- (void)configUI {
    
    [self.accountInputView setPlaceholder:@"请输入11位手机号码"];
    self.accountInputView.fromServer = YES;
    self.accountInputView.account = [CNUserManager shareManager].userDetail.mobileNo;
    self.accountInputView.correct = YES;
    self.accountInputView.userInteractionEnabled = NO;
    

    [self.oldeCodeView setPlaceholder:@"请输入资金密码"];
    [self.codeInputView setPlaceholder:@"请输入验证码"];
    
    self.oldeCodeView.codeType = CNCodeTypeOldFundPwd;
    
    // 验证码须传入手机号
    self.codeInputView.mobileNum = [CNUserManager shareManager].userDetail.mobileNo;
    self.codeInputView.codeType = CNCodeTypecModifyBankCard;
}

- (void)setDelegate {
    self.oldeCodeView.delegate = self;
    self.accountInputView.delegate = self;
    self.codeInputView.delegate = self;
}


#pragma mark - Action
- (IBAction)didTapSubmitBtn:(id)sender {
    WEAKSELF_DEFINE
    [CNLoginRequest verifySMSCodeWithType:CNSMSCodeTypeChangeBank smsCode:self.codeInputView.code smsCodeId:weakSelf.smsModel.messageId completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            // 更新校验码
            weakSelf.smsModel.validateId = [[SmsCodeModel cn_parse:responseObj] validateId];
//            [self bindBankCard];
            [CNWDAccountRequest deleteAccountId:weakSelf.currentAccountModel.accountId smsCodeModel:weakSelf.smsModel handler:^(id responseObj, NSString *errorMsg) {
                weakSelf.backHandlerBlock(responseObj,errorMsg);
                if (!errorMsg)
                {
                    [weakSelf dismissBtnClicked:nil];
                }
            }];
        }
    }];
  
//    [CNWDAccountRequest deleteAccountId:_currentAccountModel.accountId handler:^(id responseObj, NSString *errorMsg) {
//        weakSelf.backHandlerBlock(responseObj,errorMsg);
//    }];
    
    // 修改资金密码
//    [CNLoginRequest modifyFundPwdSmsCode:self.codeInputView.code
//                               messageId:self.codeInputView.smsModel.messageId
//                             oldPassword:self.oldeCodeView.code
//                             newPassword:self.accountInputView.account
//                                    type:[CNUserManager shareManager].userDetail.withdralPwdFlag?@3:@4
//                                 handler:^(id responseObj, NSString *errorMsg) {
//        if (!errorMsg) {
//            [CNTOPHUB showSuccess:@"资金密码设置成功！"];
//            [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
//                [self dismissBtnClicked:nil];
//            }];
//        }
//    }];
}

- (IBAction)dismissBtnClicked:(nullable id)sender {
    self.view.backgroundColor = [UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)showCustomerView:(id)sender {
    [NNPageRouter presentOCSS_VC];
}


#pragma mark - delegate
- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    // 按钮可点击条件
    if ([CNUserManager shareManager].userDetail.withdralPwdFlag) {
        self.submitBtn.enabled = self.accountInputView.correct && self.codeInputView.correct;
    } else {
        self.submitBtn.enabled = self.accountInputView.correct && self.codeInputView.correct;
    }
}
- (void)didReceiveSmsCodeModel:(SmsCodeModel *)model {
    self.smsModel = model;
}
- (void)accountInputViewTextChange:(CNAccountInputView *)view {
    if (view.correct) {
        self.codeInputView.mobileNum = view.account;
    }
    self.submitBtn.enabled = self.accountInputView.correct && self.codeInputView.correct;
}

@end
