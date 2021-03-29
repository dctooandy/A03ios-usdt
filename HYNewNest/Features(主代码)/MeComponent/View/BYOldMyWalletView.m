//
//  BYOldMyWalletView.m
//  HYNewNest
//
//  Created by zaky on 3/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYOldMyWalletView.h"
#import "HYBalancesDetailView.h"
#import "BalanceManager.h"

@interface BYOldMyWalletView()
/// 金额 -> 本地余额
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
/// 货币
@property (weak, nonatomic) IBOutlet UILabel *currencyLb;
/// 本周投注额
@property (weak, nonatomic) IBOutlet UILabel *weekAmountLb;
/// 本月优惠 -> 优惠总额
@property (weak, nonatomic) IBOutlet UILabel *monthPromoLb;
/// 本月洗码 -> 可提币金额
@property (weak, nonatomic) IBOutlet UILabel *monthXiMaLb;
@end

@implementation BYOldMyWalletView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadViewFromXib {
    [super loadViewFromXib];
    [self requestAccountBalances:NO];
}


#pragma mark - Action

/// 显示账户详情
- (IBAction)click2ShowAccountBalncesDetail:(id)sender {
    BOOL isIndi = self.amountLb.isIndicating;
    if (isIndi) {
        [CNHUB showWaiting:@"余额详情正在加载中..请稍等"];
        return;
    }
    [HYBalancesDetailView showBalancesDetailView];
}

// 显示和隐藏金额
- (IBAction)seeAndHide:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 隐藏
        [self.amountLb hideOriginText];
        [self.weekAmountLb hideOriginText];
        [self.monthPromoLb hideOriginText];
        [self.monthXiMaLb hideOriginText];
    } else {
        // 显示
        [self.amountLb showOriginText];
        [self.weekAmountLb showOriginText];
        [self.monthPromoLb showOriginText];
        [self.monthXiMaLb showOriginText];
    }
}


#pragma mark - Data
- (void)requestAccountBalances:(BOOL)isRefreshing {
    self.currencyLb.text = [CNUserManager shareManager].userInfo.uiMode;
    
    [self.amountLb showIndicatorIsBig:NO];
    [self.weekAmountLb showIndicatorIsBig:NO];
    [self.monthPromoLb showIndicatorIsBig:NO];
    [self.monthXiMaLb showIndicatorIsBig:NO];
    
    WEAKSELF_DEFINE
    if (isRefreshing) {
        [[BalanceManager shareManager] requestBalaceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.amountLb hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
            strongSelf.currencyLb.text = model.currency;
        }];
        [[BalanceManager shareManager] requestBetAmountHandler:^(BetAmountModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.weekAmountLb hideIndicatorWithText:[model.weekBetAmount jk_toDisplayNumberWithDigit:2]];
            PromoteRebateModel *prModel = model.statis;
            [strongSelf.monthPromoLb hideIndicatorWithText:[prModel.promoAmount jk_toDisplayNumberWithDigit:2]];
            [strongSelf.monthXiMaLb hideIndicatorWithText:[prModel.rebateAmount jk_toDisplayNumberWithDigit:2]];
        }];
        
    } else {
        [[BalanceManager shareManager] getBalanceDetailHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.amountLb hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
            strongSelf.currencyLb.text = model.currency;
        }];
        [[BalanceManager shareManager] getWeeklyBetAmountHandler:^(BetAmountModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.weekAmountLb hideIndicatorWithText:[model.weekBetAmount jk_toDisplayNumberWithDigit:2]];
            PromoteRebateModel *prModel = model.statis;
            [strongSelf.monthPromoLb hideIndicatorWithText:[prModel.promoAmount jk_toDisplayNumberWithDigit:2]];
            [strongSelf.monthXiMaLb hideIndicatorWithText:[prModel.rebateAmount jk_toDisplayNumberWithDigit:2]];
        }];
    }
}


@end
