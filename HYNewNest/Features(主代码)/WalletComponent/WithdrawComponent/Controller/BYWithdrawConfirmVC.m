//
//  BYWithdrawVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/7/7.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYWithdrawConfirmVC.h"
#import "CNWDAccountRequest.h"
#import "CNWithdrawRequest.h"
#import "CNAmountInputView.h"
#import "CNCodeInputView.h"
#import "CNTwoStatusBtn.h"
#import "CNEncrypt.h"


@interface BYWithdrawConfirmVC ()
@property (nonatomic, strong) AccountModel *account;
@property (nonatomic, strong) AccountMoneyDetailModel *balance;
@property (nonatomic, assign) id<BYWithdrawDelegate> delgate;

@property (weak, nonatomic) IBOutlet CNAmountInputView *amountInputView;
@property (weak, nonatomic) IBOutlet CNCodeInputView *codeInputView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *availableAmountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *successView;

@end

@implementation BYWithdrawConfirmVC
#define SUCCESS_VIEW_HEIGHT 380.f

- (instancetype)initWithDelegate:(id<BYWithdrawDelegate>)delegate selectedBankAccount:(AccountModel *)account andAvailableBalance:(AccountMoneyDetailModel *)balance {
    self = [super init];
    self.delgate = delegate;
    self.account = account;
    self.balance = balance;
    return self;
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
#pragma mark Custom Method
- (void)setupUI {
    self.amountInputView.delegate = self;
    self.amountInputView.codeType = CNAmountTypeWithdraw;
    self.amountInputView.model = self.balance;
    [self.amountInputView setPlaceholder:@"请输入提款金额"];
    
    self.codeInputView.delegate = self;
    self.codeInputView.codeType = CNCodeTypeOldFundPwd;
    [self.codeInputView setPlaceholder:@"请输入资金密码"];
    
    self.availableAmountLabel.text = [self.balance.withdrawBal jk_toDisplayNumberWithDigit:2];

}

#pragma mark -
#pragma mark Input Delegate
- (void)amountInputViewTextChange:(CNAmountInputView *)view {
    [self.submitButton setEnabled:(view.correct && view.money.length > 0) && self.codeInputView.correct];
}

- (void)codeInputViewTextChange:(CNCodeInputView *)view {
    [self.submitButton setEnabled:self.amountInputView.correct && view.correct];
}

#pragma mark -
#pragma mark IBAction
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)submitClicked:(id)sender {
    [self.view endEditing:true];
    [self submitWithdraw];
}

- (IBAction)jump2Kefu:(id)sender {
    [self dismissViewControllerAnimated:true
                             completion:^{
        [NNPageRouter presentOCSS_VC];
    }];

}

#pragma mark -
#pragma mark Withdraw
- (void)submitWithdraw {
    WEAKSELF_DEFINE
    [CNWithdrawRequest submitWithdrawRequestAmount:self.amountInputView.money
                                         accountId:self.account.accountId
                                          protocol:self.account.protocol
                                           remarks:@""
                                  subWallAccountId:nil
                                          password:[CNEncrypt encryptString:self.codeInputView.code]
                                           handler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (KIsEmptyString(errorMsg)) {
            [strongSelf.delgate sumitWithdrawSuccess];
            strongSelf.successView.alpha = 0;
            [strongSelf.successView setHidden:false];
            strongSelf.viewHeightConstraint.constant = SUCCESS_VIEW_HEIGHT;
            
            [UIView animateWithDuration:0.2 animations:^{
                [weakSelf.view layoutIfNeeded];
                weakSelf.successView.alpha = 1;
            }];

            [[NSNotificationCenter defaultCenter] postNotificationName:BYRefreshBalanceNotification object:nil]; // 让首页和我的余额刷新
        }
    }];
}
@end
