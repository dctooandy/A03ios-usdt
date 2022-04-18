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
@property (weak, nonatomic) IBOutlet UIView *protocolContainer;
@property (nonatomic, strong) NSArray *protocols; // 所有协议
/// 选中的协议
@property (nonatomic, copy, readwrite) NSString *selectedProtocol;
@property (weak, nonatomic) IBOutlet UILabel *youCanTrustLabel;

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
    self.selectedProtocol = @"ERC20";
    self.protocols = @[@"ERC20", @"TRC20"];
    UIColor *gradColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:self.youCanTrustLabel.width];
    _youCanTrustLabel.textColor = gradColor;
    [self setupProtocolView];
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
                                          protocol:self.selectedProtocol
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
#pragma mark - Protocol

- (UIButton *)getPortocalBtn {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_newrecharge_sel"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontDBOf16Size];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn addTarget:self action:@selector(protocolSelected:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)setupProtocolView {
    [self.protocolContainer.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
    }];
    
    CGFloat ItemMargin = 30;
    CGFloat ItemHight = 20;
    CGFloat ItemWidht = 72;
    for (__block int i=0; i<self.protocols.count; i++) {
        UIButton *proBtn = [self getPortocalBtn];
        [proBtn setTitle:self.protocols[i] forState:UIControlStateNormal];
        proBtn.tag = i;

        [self.protocolContainer addSubview:proBtn];
        proBtn.frame = CGRectMake((ItemMargin + ItemWidht) * i, (self.protocolContainer.height-ItemHight)*0.5, ItemWidht, ItemHight);
        if (i != 0)
        {
            UILabel *youBetterSelectLabel = [[UILabel alloc] init];
            youBetterSelectLabel.frame = CGRectMake(CGRectGetMaxX(proBtn.frame), 0, 25, 18);
            youBetterSelectLabel.backgroundColor = [UIColor redColor];
            youBetterSelectLabel.font = [UIFont systemFontOfSize:9];;
            youBetterSelectLabel.textColor = [UIColor whiteColor];
            youBetterSelectLabel.textAlignment = NSTextAlignmentCenter;
            youBetterSelectLabel.text = @"推荐";
            youBetterSelectLabel.layer.cornerRadius = 5;
            youBetterSelectLabel.layer.masksToBounds = true;
            [self.protocolContainer addSubview:youBetterSelectLabel];
        }
        if (i==0) { // 进入选中第一个
            [self protocolSelected:proBtn];
        }
    }
}

- (void)protocolSelected:(UIButton *)aBtn {
    for (UIButton *btn in self.protocolContainer.subviews) {
        if ([btn isKindOfClass:[UIButton class]])
        {
            btn.selected = NO;
        }
    }
    aBtn.selected = YES;
    self.selectedProtocol = _protocols[aBtn.tag];
    if ([self.selectedProtocol isEqualToString:@"TRC20"])
    {
        [_youCanTrustLabel setHidden:YES];
    }else
    {
        [_youCanTrustLabel setHidden:NO];
    }
//    self.selectProtocolAddress = _protocolAddrs[aBtn.tag];
//    if (_delegate && [_delegate respondsToSelector:@selector(didSelectOneProtocol:)]) {
//        [_delegate didSelectOneProtocol:self.selectedProtocol];
//    }
}
@end
