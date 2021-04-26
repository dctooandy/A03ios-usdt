//
//  BYMyWalletView.m
//  HYNewNest
//
//  Created by zaky on 3/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYMyWalletView.h"
#import "HYBalancesDetailView.h"
#import "BalanceManager.h"
#import "UILabel+Indicator.h"
#import "HYOneBtnAlertView.h"

@interface BYMyWalletView()
@property (weak, nonatomic) IBOutlet UIImageView *wenhaoImgv;
@property (weak, nonatomic) IBOutlet UILabel *totalBalance; //!>总余额
@property (weak, nonatomic) IBOutlet UILabel *effectiveBetAmountLb; //!>本周有效投注额
@property (weak, nonatomic) IBOutlet UILabel *nonWithdrableAmountLb; //!>不可提额度
@property (weak, nonatomic) IBOutlet UILabel *withdrableAmountLb; //!>可提额度
@property (weak, nonatomic) IBOutlet UILabel *voucherAmountLb; //!>优惠券额度
@property (weak, nonatomic) IBOutlet UILabel *gamesBalanceLb; //!>厅内额度

@property (weak, nonatomic) IBOutlet UILabel *nonWithdrableTxtLb;
@property (weak, nonatomic) IBOutlet UILabel *withdrableTxtLb;


@end

@implementation BYMyWalletView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    [self setupUI];
    [self requestAccountBalances:NO];
}

- (void)setupUI {
    UIImage *theImage = [UIImage imageNamed:@"icon_rule"];
    theImage = [theImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _wenhaoImgv.image = theImage;
    _wenhaoImgv.tintColor = kHexColorAlpha(0xFFFFFF, 0.7);
}


#pragma mark - Action
/// 显示厅余额详情
- (IBAction)click2ShowAccountBalncesDetail:(id)sender {
    BOOL isIndi = self.gamesBalanceLb.isIndicating;
    if (isIndi) {
        [CNHUB showWaiting:@"余额详情正在加载中..请稍等"];
        return;
    }
    [HYBalancesDetailView showBalancesDetailView];
}

- (IBAction)didTapDetailBtn:(id)sender {
    NSString *tx = [CNUserManager shareManager].isUsdtMode?@"提币":@"提现";
    NSString *content = [NSString stringWithFormat:@"总余额 = 可%@额度 + 不可%@额度 + 优惠券总额 + 厅内额度", tx, tx];
    [HYOneBtnAlertView showWithTitle:@"温馨提示" content:content comfirmText:@"知道了" comfirmHandler:^{
    }];
}


#pragma mark - Data
- (void)requestAccountBalances:(BOOL)isRefreshing {
    if ([CNUserManager shareManager].isUsdtMode) {
        _nonWithdrableTxtLb.text = @"不可提币额度";
        _withdrableTxtLb.text = @"可提币额度";
    } else {
        _nonWithdrableTxtLb.text = @"不可提现额度";
        _withdrableTxtLb.text = @"可提现额度";
    }

    [self.totalBalance showIndicatorIsBig:NO];
    [self.effectiveBetAmountLb showIndicatorIsBig:NO];
    [self.nonWithdrableAmountLb showIndicatorIsBig:NO];
    [self.withdrableAmountLb showIndicatorIsBig:NO];
    [self.voucherAmountLb showIndicatorIsBig:NO];
    [self.gamesBalanceLb showIndicatorIsBig:NO];

    WEAKSELF_DEFINE
    if (isRefreshing) {
        [[BalanceManager shareManager] requestBetAmountHandler:^(BetAmountModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.effectiveBetAmountLb hideIndicatorWithText:[model.weekBetAmount jk_toDisplayNumberWithDigit:2]];

        }];
        [[BalanceManager shareManager] requestBalaceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            STRONGSELF_DEFINE
            
            [strongSelf setupDataWithModel:model];
        }];

    } else {
        [[BalanceManager shareManager] getWeeklyBetAmountHandler:^(BetAmountModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.effectiveBetAmountLb hideIndicatorWithText:[model.weekBetAmount jk_toDisplayNumberWithDigit:2]];

        }];
        [[BalanceManager shareManager] getBalanceDetailHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            STRONGSELF_DEFINE
            
            [strongSelf setupDataWithModel:model];
        }];
    }
}

- (void)setupDataWithModel:(AccountMoneyDetailModel *)model {
    [self.totalBalance hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
    [self.withdrableAmountLb hideIndicatorWithText:[model.walletBalance.withdrawable jk_toDisplayNumberWithDigit:2]];
    [self.nonWithdrableAmountLb hideIndicatorWithText:[model.walletBalance.nonWithDrawable jk_toDisplayNumberWithDigit:2]];
    [self.voucherAmountLb hideIndicatorWithText:[model.walletBalance.promotion jk_toDisplayNumberWithDigit:2]];
    [self.gamesBalanceLb hideIndicatorWithText:[model.platformTotalBalance jk_toDisplayNumberWithDigit:2]];
}

@end
