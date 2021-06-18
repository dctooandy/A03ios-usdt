//
//  CNResetPwdVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/20.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNChangePwdVC.h"
#import "CNCodeInputView.h"
#import "CNTwoStatusBtn.h"
#import "CNLoginRequest.h"
#import "CNLoginRegisterVC.h"
#import "CNAccountSelectView.h"

@interface CNChangePwdVC () <CNCodeInputViewDelegate>
/// 注册密码视图
@property (weak, nonatomic) IBOutlet CNCodeInputView *oldeCodeView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *reCodeView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;
@end

@implementation CNChangePwdVC

+ (void)modalVc {
    CNChangePwdVC *vc = [CNChangePwdVC new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [NNControllerHelper getCurrentViewController].definesPresentationContext = YES;
    [kCurNavVC presentViewController:vc animated:YES completion:^{
        vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self setDelegate];
}

- (void)configUI {
    [self.oldeCodeView setPlaceholder:@"请输入旧密码"];
    [self.codeView setPlaceholder:@"请输入新密码"];
    [self.reCodeView setPlaceholder:@"确认密码"];
    self.oldeCodeView.codeType = CNCodeTypeOldPwd;
    self.codeView.codeType = CNCodeTypeNewPwd;
    self.reCodeView.codeType = CNCodeTypeNewPwd;
}


#pragma mark - Action
- (IBAction)dismissBtnClicked:(nullable id)sender {
    self.view.backgroundColor = [UIColor clearColor];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - InputViewDelegate

- (void)setDelegate {
    self.oldeCodeView.delegate = self;
    self.codeView.delegate = self;
    self.reCodeView.delegate = self;
}

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    self.submitBtn.enabled = self.oldeCodeView.correct && self.codeView.correct && self.reCodeView.correct;
}

- (IBAction)submit:(UIButton *)sender {
    
    if (![self.codeView.code isEqualToString:self.reCodeView.code]) {
        [self.reCodeView showWrongMsg:@"两次输入密码不一致 请重新输入"];
        return;
    }
    
    [CNLoginRequest modifyPassword:self.oldeCodeView.code
                       newPassword:self.codeView.code
                 completionHandler:^(id responseObj, NSString *errorMsg) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            [CNTOPHUB showSuccess:@"密码修改成功 请重新登录"];
            [CNLoginRequest logoutHandler:^(id responseObj, NSString *errorMsg) {
                [[CNUserManager shareManager] cleanUserInfo];
                [kCurNavVC popToRootViewControllerAnimated:YES];
                [NNControllerHelper currentTabBarController].selectedIndex = 0;
                [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:[CNLoginRegisterVC loginVC] animated:YES];
            }];
            
        }];

    }];
    
}

@end
