//
//  BYYuEBaoVC.m
//  HYNewNest
//
//  Created by zaky on 5/11/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYYuEBaoVC.h"
#import "BYVocherCenterVC.h"
#import "HYVIPRuleAlertView.h"
#import "BYYuEBaoTransferVC.h"

@interface BYYuEBaoVC ()
@property (weak, nonatomic) IBOutlet UILabel *lbTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrency;
@property (weak, nonatomic) IBOutlet UIButton *yuebaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *lbAnnualizedReturnAmnt;
@property (weak, nonatomic) IBOutlet UILabel *lbQuarterlyInterestAmt;
@property (weak, nonatomic) IBOutlet UILabel *lbEarningsYesterdayAmt;
@property (weak, nonatomic) IBOutlet UIButton *btnWithdraw;
@property (weak, nonatomic) IBOutlet UIButton *btnDeposit;
@property (weak, nonatomic) IBOutlet UILabel *lb5Percent;
@property (weak, nonatomic) IBOutlet UILabel *lb15Percent;
@property (weak, nonatomic) IBOutlet UILabel *lb10Percent;
@property (weak, nonatomic) IBOutlet UILabel *lb20Percent;

@end

@implementation BYYuEBaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"余额宝";
    _lbCurrency.text = [NSString stringWithFormat:@"-%@-", [CNUserManager shareManager].isUsdtMode?@"USDT":@"CNY"];
    
    [_yuebaoBtn jk_setImagePosition:LXMImagePositionRight spacing:2];
    
    UIColor *gColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:40];
    [_btnDeposit setTitleColor:gColor forState:UIControlStateNormal];
    [_btnWithdraw setTitleColor:gColor forState:UIControlStateNormal];
}


#pragma mark - ACTION

- (IBAction)didTapRuleBtn:(id)sender {
    [HYVIPRuleAlertView showYuEBaoRule];
}

- (IBAction)didTapYuEBaoTotalAmount:(id)sender {
    
}

- (IBAction)didTapDeposit2YuEBao:(id)sender {
    BYYuEBaoTransferVC *vc = [[BYYuEBaoTransferVC alloc] initWithType:YEBTransferTypeDeposit];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didTapWithdrawFrYuEBao:(id)sender {
    BYYuEBaoTransferVC *vc = [[BYYuEBaoTransferVC alloc] initWithType:YEBTransferTypeWithdraw];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didTapCheckMyDepositTicket:(id)sender {
    [self.navigationController pushViewController:[BYVocherCenterVC new] animated:YES];
}

@end
