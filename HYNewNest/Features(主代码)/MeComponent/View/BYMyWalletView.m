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

@interface BYMyWalletView()

@property (weak, nonatomic) IBOutlet UIButton *nextLevelBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *betProgressView;

@end

@implementation BYMyWalletView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    [self.nextLevelBtn jk_setImagePosition:LXMImagePositionRight spacing:2];
    [self requestAccountBalances:NO];
}


#pragma mark - Action
/// 显示账户详情
//- (IBAction)click2ShowAccountBalncesDetail:(id)sender {
//    BOOL isIndi = self.amountLb.isIndicating;
//    if (isIndi) {
//        [CNHUB showWaiting:@"余额详情正在加载中..请稍等"];
//        return;
//    }
//    [HYBalancesDetailView showBalancesDetailView];
//}
//
//- (IBAction)didTapVIPDetailBtn:(id)sender {
//    [NNPageRouter jump2HTMLWithStrURL:@"/starall" title:@"星特权新体验" needPubSite:YES];
//}


#pragma mark - Data
- (void)requestAccountBalances:(BOOL)isRefreshing {
//    self.currencyLb.text = [CNUserManager shareManager].userInfo.uiMode;
//
//    [self.amountLb showIndicatorIsBig:NO];
//    [self.weekAmountLb showIndicatorIsBig:NO];
//    [self.monthPromoLb showIndicatorIsBig:NO];
//    [self.monthXiMaLb showIndicatorIsBig:NO];
//
//    WEAKSELF_DEFINE
//    if (isRefreshing) {
//        [[BalanceManager shareManager] requestBalaceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
//            STRONGSELF_DEFINE
//            [strongSelf.amountLb hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
//            strongSelf.currencyLb.text = model.currency;
//        }];
//        [[BalanceManager shareManager] requestBetAmountHandler:^(BetAmountModel * _Nonnull model) {
//            STRONGSELF_DEFINE
//            [strongSelf.weekAmountLb hideIndicatorWithText:[model.weekBetAmount jk_toDisplayNumberWithDigit:2]];
//        }];
//        [[BalanceManager shareManager] requestMonthPromoteAndXimaHandler:^(PromoteXimaModel * _Nonnull model) {
//            STRONGSELF_DEFINE
//            [strongSelf.monthPromoLb hideIndicatorWithText:[model.promoAmountByMonth jk_toDisplayNumberWithDigit:2]];
//            [strongSelf.monthXiMaLb hideIndicatorWithText:[model.rebatedAmountByMonth jk_toDisplayNumberWithDigit:2]];
//        }];
//
//    } else {
//        [[BalanceManager shareManager] getBalanceDetailHandler:^(AccountMoneyDetailModel * _Nonnull model) {
//            STRONGSELF_DEFINE
//            [strongSelf.amountLb hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
//            strongSelf.currencyLb.text = model.currency;
//        }];
//        [[BalanceManager shareManager] getWeeklyBetAmountHandler:^(BetAmountModel * _Nonnull model) {
//            STRONGSELF_DEFINE
//            [strongSelf.weekAmountLb hideIndicatorWithText:[model.weekBetAmount jk_toDisplayNumberWithDigit:2]];
//        }];
//        [[BalanceManager shareManager] getPromoteXimaHandler:^(PromoteXimaModel * _Nonnull pxModel) {
//            STRONGSELF_DEFINE
//            [strongSelf.monthPromoLb hideIndicatorWithText:[pxModel.promoAmountByMonth jk_toDisplayNumberWithDigit:2]];
//            [strongSelf.monthXiMaLb hideIndicatorWithText:[pxModel.rebatedAmountByMonth jk_toDisplayNumberWithDigit:2]];
//        }];
//    }
}

@end
