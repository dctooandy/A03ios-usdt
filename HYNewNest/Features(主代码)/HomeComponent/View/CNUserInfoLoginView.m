//
//  CNUserInfoLoginView.m
//  HYNewNest
//
//  Created by Cean on 2020/7/21.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNUserInfoLoginView.h"
#import "CNVIPLabel.h"
#import "CNUserCenterRequest.h"
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

    // 提现右上角NEW
    [self.withdrawCNYBtn showRightTopImageName:@"new_txgb" size:CGSizeMake(30, 14) offsetX:-30 offsetYMultiple:0];
}

- (void)updateLoginStatusUI {
    if ([CNUserManager shareManager].isLogin) {
        [self configLogInUI];
        [self reloadBalance];
//        if (![CNUserManager shareManager].userDetail.newAccountFlag) {
        if ([CNUserManager shareManager].isUiModeHasOptions) {
            self.switchModeBtn.hidden = NO;
            self.vipImgv.hidden = YES;
            [self switchAccountUIChange];
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

    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:[CNUserManager shareManager].userInfo.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];

    if ([CNUserManager shareManager].userInfo.starLevel > 0) {
        self.vipImgv.image = [UIImage imageNamed:[NSString stringWithFormat:@"VIP%ld", [CNUserManager shareManager].userInfo.starLevel]];
    } else {
        self.vipImgv.image = [UIImage new];
    }

}

- (void)reloadBalance {
    if ([CNUserManager shareManager].isLogin) {
        [self.moneyLb showIndicatorIsBig:NO];
        //金额
        WEAKSELF_DEFINE
        [CNUserCenterRequest requestAccountBalanceHandler:^(id responseObj, NSString *errorMsg) {
            STRONGSELF_DEFINE
            AccountMoneyDetailModel *model = [AccountMoneyDetailModel cn_parse:responseObj];
            if (!model) {
                return;
            }
    //        strongSelf.moneyLb.text = [model.balance jk_toDisplayNumberWithDigit:2];
            if (model.balance.integerValue == 0) {
                [strongSelf.moneyLb hideIndicatorWithText:@"000.00"];
            } else {
                [strongSelf.moneyLb hideIndicatorWithText: [model.balance jk_toDisplayNumberWithDigit:2]];
            }
            strongSelf.currencyLb.text = model.currency;
            
        }];
    }
}

// 修改买充提买按钮
- (void)switchAccountUIChange {
    if ([CNUserManager shareManager].isUsdtMode) {
        self.switchModeBtn.selected = NO;
        self.bottomViewH.constant = 88;
        self.bottomViewSpacing.constant = -44;
    } else {
        self.switchModeBtn.selected = YES;
        self.bottomViewH.constant = 44;
        self.bottomViewSpacing.constant = 0;
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
