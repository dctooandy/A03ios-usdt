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

@interface BYMyWalletView()

@property (weak, nonatomic) IBOutlet UIButton *nextLevelBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *betProgressView;
@property (weak, nonatomic) IBOutlet UILabel *effectiveBetAmountLb;
@property (weak, nonatomic) IBOutlet UILabel *currencyLb;
@property (weak, nonatomic) IBOutlet UILabel *localBalanceLb;
@property (weak, nonatomic) IBOutlet UILabel *promoteAmountLb;
@property (weak, nonatomic) IBOutlet UILabel *withdrableAmountLb;

@end

@implementation BYMyWalletView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    [self.nextLevelBtn setTitle:[NSString stringWithFormat:@"VIP%ld", [CNUserManager shareManager].userInfo.starLevel+1] forState:UIControlStateNormal];
    [self.nextLevelBtn jk_setImagePosition:LXMImagePositionRight spacing:0];
    [self requestAccountBalances:NO];
}


#pragma mark - Action
/// 显示账户详情
- (IBAction)click2ShowAccountBalncesDetail:(id)sender {
    BOOL isIndi = self.localBalanceLb.isIndicating;
    if (isIndi) {
        [CNHUB showWaiting:@"余额详情正在加载中..请稍等"];
        return;
    }
    [HYBalancesDetailView showBalancesDetailView];
}

- (IBAction)didTapVIPDetailBtn:(id)sender {
    [NNPageRouter jump2HTMLWithStrURL:@"/starall" title:@"星特权新体验" needPubSite:YES];
}


#pragma mark - Data
- (void)requestAccountBalances:(BOOL)isRefreshing {
    self.currencyLb.text = [CNUserManager shareManager].userInfo.currency;

    [self.effectiveBetAmountLb showIndicatorIsBig:NO];
    [self.localBalanceLb showIndicatorIsBig:NO];
    [self.promoteAmountLb showIndicatorIsBig:NO];
    [self.withdrableAmountLb showIndicatorIsBig:NO];

    WEAKSELF_DEFINE
    if (isRefreshing) {
        [[BalanceManager shareManager] requestBetAmountHandler:^(BetAmountModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.effectiveBetAmountLb hideIndicatorWithText:[model.weekBetAmount jk_toDisplayNumberWithDigit:2]];
            [strongSelf.nextLevelBtn setTitle:[NSString stringWithFormat:@"VIP%ld", model.customerLevel+1] forState:UIControlStateNormal];
            float curStream = [model.weekBetAmount floatValue];
            float nxtStream = [model.minNextBetAmount floatValue];
            if (nxtStream > 0) {
                float a = curStream / nxtStream;
                strongSelf.betProgressView.progress = a;
            }
        }];
        [[BalanceManager shareManager] requestBalaceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.localBalanceLb hideIndicatorWithText:[model.walletBalance.nonWithDrawable jk_toDisplayNumberWithDigit:2]];
            [strongSelf.promoteAmountLb hideIndicatorWithText:[model.walletBalance.promotion jk_toDisplayNumberWithDigit:2]];
            [strongSelf.withdrableAmountLb hideIndicatorWithText:[model.walletBalance.withdrawable jk_toDisplayNumberWithDigit:2]];
        }];
//        [[BalanceManager shareManager] requestMonthPromoteAndXimaHandler:^(PromoteXimaModel * _Nonnull model) {
//            STRONGSELF_DEFINE
//            [strongSelf.monthPromoLb hideIndicatorWithText:[model.promoAmountByMonth jk_toDisplayNumberWithDigit:2]];
//            [strongSelf.monthXiMaLb hideIndicatorWithText:[model.rebatedAmountByMonth jk_toDisplayNumberWithDigit:2]];
//        }];

    } else {
        [[BalanceManager shareManager] getWeeklyBetAmountHandler:^(BetAmountModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.effectiveBetAmountLb hideIndicatorWithText:[model.weekBetAmount jk_toDisplayNumberWithDigit:2]];
            [strongSelf.nextLevelBtn setTitle:[NSString stringWithFormat:@"VIP%ld", model.customerLevel+1] forState:UIControlStateNormal];
            float curStream = [model.weekBetAmount floatValue];
            float nxtStream = [model.minNextBetAmount floatValue];
            if (nxtStream > 0) {
                float a = curStream / nxtStream;
                strongSelf.betProgressView.progress = a;
            }
        }];
        [[BalanceManager shareManager] getBalanceDetailHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.localBalanceLb hideIndicatorWithText:[model.walletBalance.nonWithDrawable jk_toDisplayNumberWithDigit:2]];
            [strongSelf.promoteAmountLb hideIndicatorWithText:[model.walletBalance.promotion jk_toDisplayNumberWithDigit:2]];
            [strongSelf.withdrableAmountLb hideIndicatorWithText:[model.walletBalance.withdrawable jk_toDisplayNumberWithDigit:2]];
        }];
//        [[BalanceManager shareManager] getPromoteXimaHandler:^(PromoteXimaModel * _Nonnull pxModel) {
//            STRONGSELF_DEFINE
//            [strongSelf.monthPromoLb hideIndicatorWithText:[pxModel.promoAmountByMonth jk_toDisplayNumberWithDigit:2]];
//            [strongSelf.monthXiMaLb hideIndicatorWithText:[pxModel.rebatedAmountByMonth jk_toDisplayNumberWithDigit:2]];
//        }];
    }
}

@end
