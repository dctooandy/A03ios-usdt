//
//  BYModifyPhoneVC.m
//  HYNewNest
//
//  Created by zaky on 6/17/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYModifyPhoneVC.h"
#import "CNAccountInputView.h"
#import "CNCodeInputView.h"
#import "CNTwoStatusBtn.h"
#import "CNLoginRequest.h"

@interface BYModifyPhoneVC () <CNCodeInputViewDelegate, CNAccountInputViewDelegate>
@property (nonatomic, assign) CNSMSCodeType bindType;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet CNAccountInputView *accountInputView; //手机号
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeInputView; //验证码
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;

@property (copy,nonatomic) NSString *validateId; //!<修改手机第二次发送短信需要传这个
@end

@implementation BYModifyPhoneVC

+ (void)modalVcWithSMSCodeType:(CNSMSCodeType)type {
    BYModifyPhoneVC *vc = [BYModifyPhoneVC new];
    vc.bindType = type;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [NNControllerHelper getCurrentViewController].definesPresentationContext = YES;
    [kCurNavVC presentViewController:vc animated:YES completion:^{
        vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.submitBtn.enabled = NO;
    [self setupTextFieldUI];
    // 不同来源UI差别
    [self configDifferentUI];
    
}

- (void)setupTextFieldUI {
    
    [self.accountInputView setPlaceholder:@"请输入11位手机号码"];
    self.accountInputView.fromServer = YES;
    self.accountInputView.delegate = self;
    
    [self.codeInputView setPlaceholder:@"请输入验证码"];
    self.codeInputView.delegate = self;

}

- (void)configDifferentUI {
    NSString *mobileNo = [CNUserManager shareManager].userDetail.mobileNo;
    switch (self.bindType) {
        // 安全中心或者各处来的 未绑手机
        case CNSMSCodeTypeBindPhone:
            self.titleLb.text = @"绑定手机号";
            self.codeInputView.codeType = CNCodeTypeBindPhone;
            // 如果有已有手机号则设置
            if ([CNUserManager shareManager].userDetail.mobileNo.length) {
                self.accountInputView.account = mobileNo;
                self.accountInputView.correct = YES;
                self.accountInputView.userInteractionEnabled = NO;
                self.codeInputView.mobileNum = mobileNo;
            }
            break;
        // 安全中心来的 解绑
        case CNSMSCodeTypeUnbind:
            self.titleLb.text = @"手机号修改";
            self.codeInputView.codeType = CNCodeTypeUnbind;
            self.accountInputView.account = [CNUserManager shareManager].userDetail.mobileNo;
            self.accountInputView.correct = YES;
            self.accountInputView.userInteractionEnabled = NO;
            [self.submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
            break;
        // 解绑来的 绑新手机
        case CNSMSCodeTypeChangePhone:
            self.codeInputView.codeType = CNCodeTypeChangePhone;
            self.codeInputView.validateId = self.validateId; //绑新手机必须传
            self.titleLb.text = @"绑定新手机";
            break;
        default:
            break;
    }
}


#pragma mark - Action

/// 校验短信验证码: 提交
- (IBAction)verfiSmsCode:(UIButton *)sender {
    if (!self.codeInputView.smsModel) {
        [CNTOPHUB showAlert:@"请发送验证码"];
        return;
    }
    if (self.bindType == CNSMSCodeTypeBindPhone) {

        [CNLoginRequest requestPhoneBind:self.codeInputView.code
                               messageId:self.codeInputView.smsModel.messageId
                       completionHandler:^(id responseObj, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
                // 更新信息
                [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
                    [CNTOPHUB showSuccess:@"绑定成功"];
                    [self didTapCloseBtn:nil];
                }];
            }
        }];
    
    } else if (self.bindType == CNSMSCodeTypeUnbind) {
        
        [CNLoginRequest verifySMSCodeWithType:CNSMSCodeTypeChangePhone
                                      smsCode:self.codeInputView.code
                                    smsCodeId:self.codeInputView.smsModel.messageId
                            completionHandler:^(id responseObj, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg)) {
                [CNTOPHUB showSuccess:@"验证成功"];
                self.view.backgroundColor = [UIColor clearColor];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    BYModifyPhoneVC *vc = [BYModifyPhoneVC new];
                    vc.bindType = CNSMSCodeTypeChangePhone;
                    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    if (responseObj && [responseObj isKindOfClass:[NSDictionary class]]) {
                        vc.validateId = responseObj[@"validateId"];
                    }
                    [kCurNavVC presentViewController:vc animated:YES completion:^{
                        vc.view.backgroundColor = kHexColorAlpha(0x000000, 0.5);
                    }];
                }];
            }
        }];
        
    } else { //绑定新手机 CNSMSCodeTypeChangePhone
        [CNLoginRequest requestRebindPhone:self.codeInputView.code
                                 messageId:self.codeInputView.smsModel.messageId
                         completionHandler:^(id responseObj, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
                [CNLoginRequest getUserInfoByTokenCompletionHandler:nil];
                [CNTOPHUB showSuccess:@"修改成功"];
                [self didTapCloseBtn:nil];
            }
        }];
    }
}

- (IBAction)didTapCloseBtn:(nullable id)sender {
    self.view.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYDidUpdateUserProfileNoti object:nil userInfo:nil]; //发送通知让安全中心更新信息
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - Delegate

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    self.submitBtn.enabled = self.accountInputView.correct && self.codeInputView.correct;
}

- (void)accountInputViewTextChange:(CNAccountInputView *)view {
    if (view.correct) {
        self.codeInputView.mobileNum = view.account;
    }
    self.submitBtn.enabled = self.accountInputView.correct && self.codeInputView.correct;
}

@end
