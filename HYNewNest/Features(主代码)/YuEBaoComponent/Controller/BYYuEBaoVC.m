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
    
    self.title = @"余额宝";
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self requestAmount];
    [self requestTickets];
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
    [CNTOPHUB showAlert:@"还未配置跳转链接"];
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
    
    [[BalanceManager shareManager] requestYuEBaoYesterdaySumHandler:^(CNYuEBaoBalanceModel * model) {
        if (model) {
            NSString *yesDay = [model.interestDay jk_toDisplayNumberWithDigit:2];
            NSString *yesDayStr = [NSString stringWithFormat:@"+%@",yesDay];
            [self.lbEarningsYesterdayAmt hideIndicatorWithText:yesDayStr];
            [self.lbQuarterlyInterestAmt hideIndicatorWithText:[model.interestSeason jk_toDisplayNumberWithDigit:2]];
        }
    }];
    
    [CNYuEBaoRequest checkYuEBaoConfigHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            CNYuEBaoConfigModel *model = [CNYuEBaoConfigModel cn_parse:responseObj];
            self.model = model;
            NSString *annStr = [NSString stringWithFormat:@"%@%%",model.yearRate];
            [self.lbAnnualizedReturnAmnt hideIndicatorWithText:annStr];
            NSNumber *total = @( model.yebAmount.floatValue + model.yebInterest.floatValue );
            [self.lbTotalAmount hideIndicatorWithText:[total jk_toDisplayNumberWithDigit:2]];
        }
    }];
}

- (void)requestTickets {
    WEAKSELF_DEFINE
    [CNYuEBaoRequest checkYuEBaoTicketsHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *tickets = responseObj[@"result"];
            __block int num_5percent = 0;
            __block int num_15percent = 0;
            __block int num_10percent = 0;
            __block int num_20percent = 0;
            [tickets enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSNumber *plevel = obj[@"prizeLevel"];
                NSNumber *flag = obj[@"flag"];
                if (flag.integerValue == 1) {
                    switch ([plevel integerValue]) {
                        case 1:
                        case 2:
                            num_5percent ++;
                            break;
                        case 3:
                        case 4:
                            num_10percent ++;
                            break;
                        case 5:
                        case 6:
                            num_15percent ++;
                            break;
                        case 7:
                        case 8:
                            num_20percent ++;
                            break;
                        default:
                            break;
                    }
                }
            }];
            strongSelf.lb5Percent.text = [NSString stringWithFormat:@"%d 张", num_5percent];
            strongSelf.lb10Percent.text = [NSString stringWithFormat:@"%d 张", num_10percent];
            strongSelf.lb15Percent.text = [NSString stringWithFormat:@"%d 张", num_15percent];
            strongSelf.lb20Percent.text = [NSString stringWithFormat:@"%d 张", num_20percent];
        }
    }];
}



@end
