//
//  CNUserInfoLoginView.m
//  HYNewNest
//
//  Created by Cean on 2020/7/21.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNUserInfoLoginView.h"
#import "CNVIPLabel.h"
#import "BalanceManager.h"
#import "CNUserModel.h"
#import <UIImageView+WebCache.h>
#import "UIView+Badge.h"

@interface CNUserInfoLoginView ()
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UIImageView *vipImgv;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UILabel *currencyLb;
@property (weak, nonatomic) IBOutlet UIButton *switchModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawCNYBtn;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewSpacing;

#pragma - mark 未登录属性
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation CNUserInfoLoginView

- (void)loadViewFromXib {
    [super loadViewFromXib];

    [self refreshBottomBtnsStatus];
    // 提现右上角NEW
//    [self.withdrawCNYBtn showRightTopImageName:@"new_txgb" size:CGSizeMake(30, 14) offsetX:-30 offsetYMultiple:0];
}

- (void)updateLoginStatusUI {
    if ([CNUserManager shareManager].isLogin) {
        [self configLogInUI];
        [[BalanceManager shareManager] getBalanceDetailHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            [self.moneyLb hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
        }];
//        if (![CNUserManager shareManager].userDetail.newAccountFlag) {
        if ([CNUserManager shareManager].isUiModeHasOptions) {
            self.switchModeBtn.hidden = NO;
            self.vipImgv.hidden = YES;
        } else {
            self.switchModeBtn.hidden = YES;
            self.vipImgv.hidden = NO;
        }
    } else {
        [self configLogoutUI];
    }
}

- (void)configLogoutUI {
    self.loginView.hidden = NO;
    self.headerIcon.image = nil;
}

- (void)configLogInUI {
    self.loginView.hidden = YES;
    [self refreshBottomBtnsStatus];
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:[CNUserManager shareManager].userDetail.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];

    NSInteger level = [CNUserManager shareManager].userInfo.starLevel;
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"vip%ld", (long)level]];
    self.vipImgv.image = img;
    
    self.currencyLb.text = [CNUserManager shareManager].isUsdtMode?@"USDT":@"CNY";

}

- (void)reloadBalance{
    if ([CNUserManager shareManager].isLogin) {
        [self.moneyLb showIndicatorIsBig:NO];
        //金额
        [[BalanceManager shareManager] requestBalaceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            [self.moneyLb hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
        }];
    }
}


// 切换币种 修改买充提买按钮 必须重新加载数据
- (void)switchAccountUIChange {
    [self refreshBottomBtnsStatus];
    [self reloadBalance];
}

- (void)refreshBottomBtnsStatus {
    if ([CNUserManager shareManager].isUsdtMode) {
        self.switchModeBtn.selected = NO;
        self.bottomViewH.constant = 88;
        self.bottomViewSpacing.constant = -44;
        self.currencyLb.text = @"USDT";
    } else {
        self.switchModeBtn.selected = YES;
        self.bottomViewH.constant = 44;
        self.bottomViewSpacing.constant = 0;
        self.currencyLb.text = @"CNY";
    }
}

// 切换账户货币
- (IBAction)switchAccount:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(switchAccountAction)]) {
        [_delegate switchAccountAction];
    }
}

- (IBAction)bottomBtnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(buttonArrayAction:)]) {
        [_delegate buttonArrayAction:(CNActionType)(sender.tag)];
    }
}

- (IBAction)login:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginAction)]) {
        [_delegate loginAction];
    }
}

- (IBAction)regist:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(registerAction)]) {
        [_delegate registerAction];
    }
}

@end
