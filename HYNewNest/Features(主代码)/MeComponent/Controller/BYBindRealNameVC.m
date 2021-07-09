//
//  BYTieRealNameVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/9.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYBindRealNameVC.h"
#import "UILabel+Gradient.h"
#import "CNTwoStatusBtn.h"
#import "CNNormalInputView.h"
#import "CNUserCenterRequest.h"

@interface BYBindRealNameVC ()
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;
@property (weak, nonatomic) IBOutlet CNNormalInputView *realNameInputView;
@property (weak, nonatomic) IBOutlet CNNormalInputView *confirmRealNameInputView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *modifyRealNameWarningLabel;

@end

@implementation BYBindRealNameVC

+ (void)modalVCBindRealName {
    BYBindRealNameVC *vc = [BYBindRealNameVC new];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [NNControllerHelper getCurrentViewController].definesPresentationContext = YES;
    [kCurNavVC presentViewController:vc animated:YES completion:^{
        vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -
#pragma mark InputViewDelegate
- (void)inputViewTextChange:(CNNormalInputView *)view {
    
    BOOL submitEnable = false;
    if ([view.text validationType:ValidationTypeRealName] == true && [self.realNameInputView.text isEqualToString:self.confirmRealNameInputView.text]) {
        view.wrongAccout = false;
        submitEnable = true;
    }
    else if (view == self.confirmRealNameInputView && [self.realNameInputView.text isEqualToString:view.text] == false) {
        [view showWrongMsg:@"您两次的输入不一致"];
        view.wrongAccout = true;
    }
    else if (view == self.realNameInputView) {
        self.confirmRealNameInputView.wrongAccout = false;
        self.confirmRealNameInputView.text = @"";
    }
    else if ([view.text validationType:ValidationTypeRealName] == false) {
        [view showWrongMsg:@"您输入的真实姓名有误"];
        view.wrongAccout = true;
    }
    else if ([view.text validationType:ValidationTypeRealName] == true) {
        view.wrongAccout = false;
    }
    
    self.submitButton.enabled = submitEnable;
    
}
#pragma mark -
#pragma mark Custom Method
- (void)setupUI {
    if (KIsEmptyString([CNUserManager shareManager].userDetail.realName)) {
        [self.warningLabel setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
        
        [self.realNameInputView setPlaceholder:@"请输入新付款人姓名"];
        [self.realNameInputView setDelegate:self];
        
        [self.confirmRealNameInputView setPlaceholder:@"确认新付款人姓名"];
        [self.confirmRealNameInputView setDelegate:self];
        
        [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
        
        [self.modifyRealNameWarningLabel setHidden:true];
    }
    else {
        [self.submitButton setTitle:@"联系客服" forState:UIControlStateNormal];
        [self.submitButton setEnabled:true];
        
        [self.modifyRealNameWarningLabel setHidden:false];
    }
}

#pragma mark -
#pragma mark IBAction
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)submitClicked:(id)sender {
    if (KIsEmptyString([CNUserManager shareManager].userDetail.realName)) {
        WEAKSELF_DEFINE
        [CNUserCenterRequest modifyUserRealName:self.realNameInputView.text gender:nil birth:nil avatar:nil onlineMessenger2:nil email:nil handler:^(id responseObj, NSString *errorMsg) {
            if (!errorMsg) {
                [CNTOPHUB showSuccess:@"实名认证成功"];
                [weakSelf dismissSelf:nil];
            }
        }];
    }
    else {
        [self dismissViewControllerAnimated:true completion:^{
            [NNPageRouter presentOCSS_VC];
        }];
        
    }
}

@end
