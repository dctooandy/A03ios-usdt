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
{
    BOOL _isExpanded;
}
@property (weak, nonatomic) IBOutlet UIImageView *wenhaoImgv;
@property (weak, nonatomic) IBOutlet UILabel *totalBalance; //!>总余额
@property (weak, nonatomic) IBOutlet UILabel *effectiveBetAmountLb; //!>本周有效投注额
@property (weak, nonatomic) IBOutlet UILabel *nonWithdrableAmountLb; //!>不可提额度
@property (weak, nonatomic) IBOutlet UILabel *withdrableAmountLb; //!>可提额度
@property (weak, nonatomic) IBOutlet UILabel *voucherAmountLb; //!>优惠券额度
@property (weak, nonatomic) IBOutlet UILabel *gamesBalanceLb; //!>厅内额度

@property (weak, nonatomic) IBOutlet UILabel *nonWithdrableTxtLb;
@property (weak, nonatomic) IBOutlet UILabel *withdrableTxtLb;

@property (weak, nonatomic) IBOutlet UILabel *yebAmountLb; //!>余额宝余额
@property (weak, nonatomic) IBOutlet UILabel *yebInterestLb; //!>季度利息
@property (weak, nonatomic) IBOutlet UILabel *yebProfitYesterdayLb; //!>昨日收益
@property (weak, nonatomic) IBOutlet UIView *middleZoomBgView;
@property (weak, nonatomic) IBOutlet UIView *btmZoomBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandBtnTopConst;
@property (weak, nonatomic) IBOutlet UIView *topZoomBgView;


@end

@implementation BYMyWalletView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    _isExpanded = NO;
    [self requestAccountBalances:NO];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_btmZoomBgView jk_setRoundedCorners:UIRectCornerAllCorners radius:12];
    [_middleZoomBgView jk_setRoundedCorners:UIRectCornerAllCorners radius:12];
    [_topZoomBgView jk_setRoundedCorners:UIRectCornerAllCorners radius:12];
}

#pragma mark - Action
/// 显示厅余额详情
- (IBAction)click2ShowAccountBalncesDetail:(id)sender {
    BOOL isIndi = self.gamesBalanceLb.isIndicating;
    if (isIndi) {
        [CNTOPHUB showWaiting:@"余额详情正在加载中..请稍等"];
        return;
    }
    [HYBalancesDetailView showBalancesDetailView];
}

- (IBAction)didTapDetailBtn:(id)sender {
    NSString *content;
    if ([CNUserManager shareManager].isUsdtMode) {
        content = @"账户余额 = 可提币额度 + 不可提币额度 + 优惠券总额 + 厅内额度 + 余额宝";
    } else {
        content = @"账户余额 = 可提币额度 + 不可提币额度 + 优惠券总额 + 厅内额度";
    }

    [HYOneBtnAlertView showWithTitle:@"温馨提示" content:content comfirmText:@"知道了" comfirmHandler:^{
    }];
}

- (IBAction)didTapExpandBtn:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    _isExpanded = !_isExpanded;
    [self refreshUI];
}

- (void)refreshUI {
    if (!_isExpanded) { // 已展开
        _middleZoomBgView.hidden = YES;
        _btmZoomBgView.hidden = YES;
        _expandBtnTopConst.constant = 56;
    } else { //未展开
        if ([CNUserManager shareManager].isUsdtMode) {
            _middleZoomBgView.hidden = NO;
            _btmZoomBgView.hidden = NO;
            _expandBtnTopConst.constant = 56+67*2;
        } else {
            _middleZoomBgView.hidden = NO;
            _btmZoomBgView.hidden = YES;
            _expandBtnTopConst.constant = 56+67;
        }
    }
    !_expandBlock?:_expandBlock(_isExpanded);
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
    [self.yebAmountLb showIndicatorIsBig:NO];
    [self.yebInterestLb showIndicatorIsBig:NO];
    [self.yebProfitYesterdayLb showIndicatorIsBig:NO];
    [self refreshUI];

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
        [[BalanceManager shareManager] requestYuEBaoYesterdaySumHandler:^(CNYuEBaoBalanceModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.yebInterestLb hideIndicatorWithText:[model.interestSeason jk_toDisplayNumberWithDigit:2]];
            [strongSelf.yebProfitYesterdayLb hideIndicatorWithText:[model.interestDay jk_toDisplayNumberWithDigit:2]];
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
        [[BalanceManager shareManager] getYuEBaoYesterdaySumHandler:^(CNYuEBaoBalanceModel * _Nonnull model) {
            STRONGSELF_DEFINE
            [strongSelf.yebInterestLb hideIndicatorWithText:[model.interestSeason jk_toDisplayNumberWithDigit:2]];
            [strongSelf.yebProfitYesterdayLb hideIndicatorWithText:[model.interestDay jk_toDisplayNumberWithDigit:2]];
        }];
    }
}

- (void)setupDataWithModel:(AccountMoneyDetailModel *)model {
    
    [self.withdrableAmountLb hideIndicatorWithText:[model.walletBalance.withdrawable jk_toDisplayNumberWithDigit:2]];
    [self.nonWithdrableAmountLb hideIndicatorWithText:[model.walletBalance.nonWithDrawable jk_toDisplayNumberWithDigit:2]];
    [self.voucherAmountLb hideIndicatorWithText:[model.walletBalance.promotion jk_toDisplayNumberWithDigit:2]];
    [self.gamesBalanceLb hideIndicatorWithText:[model.platformTotalBalance jk_toDisplayNumberWithDigit:2]];
    
    float yebAmount = model.yebAmount.floatValue + model.yebInterest.floatValue;
    [self.yebAmountLb hideIndicatorWithText:[@(yebAmount) jk_toDisplayNumberWithDigit:2]];
    float totalAmount = model.balance.floatValue + yebAmount;
    [self.totalBalance hideIndicatorWithText:[@(totalAmount) jk_toDisplayNumberWithDigit:2]];
}

@end
