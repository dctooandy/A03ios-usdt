//
//  CNResetPwdVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/20.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNResetPwdVC.h"
#import "CNCodeInputView.h"
#import "CNTwoStatusBtn.h"
#import "CNLoginRequest.h"
#import "CNLoginRegisterVC.h"
#import "CNAccountSelectView.h"
#import "BRPickerView.h"

@interface CNResetPwdVC () <CNCodeInputViewDelegate>
/// 注册密码视图
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *reCodeView;
@property (weak, nonatomic) IBOutlet CNAccountSelectView *accountSelectView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitBtn;
@end

@implementation CNResetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarTransparent = YES;
    self.makeTranslucent = YES;
    
    [self configUI];
    [self setDelegate];
}

- (void)configUI {
    self.view.backgroundColor = kHexColor(0x212137);
    
    [self.codeView setPlaceholder:@"请输入新密码"];
    [self.reCodeView setPlaceholder:@"确认密码"];
    self.codeView.codeType = CNCodeTypeNewPwd;
    self.reCodeView.codeType = CNCodeTypeNewPwd;
    
    NSString *defaultName = self.fpwdModel.samePhoneLoginNames.firstObject.loginName;
    self.accountSelectView.loginNameTf.text = defaultName;
}

#pragma mark - InputViewDelegate

- (void)setDelegate {
    self.codeView.delegate = self;
    self.reCodeView.delegate = self;
}

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    self.submitBtn.enabled = self.codeView.correct && self.reCodeView.correct;
}

- (IBAction)didClickAccountSelect:(id)sender {
    NSArray <SamePhoneLoginNameItem *> *items = self.fpwdModel.samePhoneLoginNames;
    NSMutableArray *names = @[].mutableCopy;
    for (SamePhoneLoginNameItem *item in items) {
        [names addObject:item.loginName];
    }
    
    WEAKSELF_DEFINE
    [BRStringPickerView showStringPickerWithTitle:@"选择账号" dataSource:names defaultSelValue:self.accountSelectView.loginNameTf.text resultBlock:^(id selectValue, NSInteger index) {
        STRONGSELF_DEFINE
        strongSelf.accountSelectView.loginNameTf.text = selectValue;
    }];
}


- (IBAction)submit:(UIButton *)sender {
    
    if (![self.codeView.code isEqualToString:self.reCodeView.code]) {
        [self.reCodeView showWrongMsg:@"密码不一致请重新输入"];
        return;
    }
    
    if (self.fpwdModel) {
        [CNLoginRequest modifyPasswordLoginName:self.accountSelectView.loginNameTf.text
                                        smsCode:self.smsCode
                                    newPassword:self.codeView.code
                                     validateId:self.fpwdModel.validateId
                                      messageId:self.fpwdModel.messageId
                              completionHandler:^(id responseObj, NSString *errorMsg) {
            
            [CNHUB showSuccess:@"重设成功 请牢记您的新密码"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [NNControllerHelper pop2ViewControllerClass:[CNLoginRegisterVC class]];
            });
        }];
    
    }
    
}
@end
