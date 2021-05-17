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
#import "CNYuEBaoRequest.h"
#import "BalanceManager.h"

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
@property (strong,nonatomic) CNYuEBaoConfigModel *model;
@end

@implementation BYYuEBaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"余额宝";
    [self setupUI];
    [self requestAmount];
}

- (void)setupUI {
    [_yuebaoBtn jk_setImagePosition:LXMImagePositionRight spacing:2];
    
    UIColor *gColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:40];
    [_btnDeposit setTitleColor:gColor forState:UIControlStateNormal];
    [_btnWithdraw setTitleColor:gColor forState:UIControlStateNormal];
    
}

- (void)setModel:(CNYuEBaoConfigModel *)model {
    _model = model;
    _btnWithdraw.enabled = YES;
    _btnDeposit.enabled = YES;
}

#pragma mark - ACTION

- (IBAction)didTapRuleBtn:(id)sender {
    [HYVIPRuleAlertView showYuEBaoRule];
}

- (IBAction)didTapYuEBaoTotalAmount:(id)sender {
    //???: 
}

- (IBAction)didTapDeposit2YuEBao:(id)sender {
    BYYuEBaoTransferVC *vc = [[BYYuEBaoTransferVC alloc] initWithType:YEBTransferTypeDeposit configModel:self.model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didTapWithdrawFrYuEBao:(id)sender {
    BYYuEBaoTransferVC *vc = [[BYYuEBaoTransferVC alloc] initWithType:YEBTransferTypeWithdraw configModel:self.model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didTapCheckMyDepositTicket:(id)sender {
    [self.navigationController pushViewController:[BYVocherCenterVC new] animated:YES];
}


#pragma mark - REQUEST

- (void)requestAmount {
    [_lbTotalAmount showIndicatorIsBig:YES];
    [_lbQuarterlyInterestAmt showIndicatorIsBig:NO];
    [_lbEarningsYesterdayAmt showIndicatorIsBig:NO];
    [_lbAnnualizedReturnAmnt showIndicatorIsBig:NO];
    
    [[BalanceManager shareManager] getYuEBaoYesterdaySumHandler:^(id  _Nonnull unknowModel) {
        
        if ([unknowModel isKindOfClass:[NSNumber class]]) {
            NSString *num = [(NSNumber *)unknowModel jk_toDisplayNumberWithDigit:2];
            NSString *numStr = [NSString stringWithFormat:@"+%@",num];
            [self.lbEarningsYesterdayAmt hideIndicatorWithText:numStr];
        }
    }];
    
    [CNYuEBaoRequest checkYuEBaoConfigHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            CNYuEBaoConfigModel *model = [CNYuEBaoConfigModel cn_parse:responseObj];
            self.model = model;
            NSString *annStr = [NSString stringWithFormat:@"%@%%",model.yearRate];
            [self.lbAnnualizedReturnAmnt hideIndicatorWithText:annStr];
            NSNumber *total = @( model.yebAmount.floatValue + model.yebInterest.floatValue );
            [self.lbTotalAmount hideIndicatorWithText:[total jk_toDisplayNumberWithDigit:2]];
            [self.lbQuarterlyInterestAmt hideIndicatorWithText:[model.yebInterest jk_toDisplayNumberWithDigit:2]];
        }
    }];
}




@end
