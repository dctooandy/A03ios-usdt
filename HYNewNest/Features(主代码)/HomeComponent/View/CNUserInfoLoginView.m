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
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchModeSegc;
@property (weak, nonatomic) IBOutlet UILabel *usrNameLb;

@property (weak, nonatomic) IBOutlet UIButton *withdrawCNYBtn;
@property (weak, nonatomic) IBOutlet UIImageView *usdtADImgv;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

#pragma - mark 未登录属性
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation CNUserInfoLoginView

- (void)loadViewFromXib {
    [super loadViewFromXib];

    [self editSegmentControlUIStatus];
    [self refreshBottomBtnsStatus];
    // 提现右上角NEW
//    [self.withdrawCNYBtn showRightTopImageName:@"new_txgb" size:CGSizeMake(30, 14) offsetX:-30 offsetYMultiple:0];
}

- (void)editSegmentControlUIStatus {
    UIColor *gdColor = [UIColor gradientColorImageFromColors:@[kHexColor(0x19CECE),kHexColor(0x10B4DD)] gradientType:GradientTypeUprightToLowleft imgSize:CGSizeMake(55, 26)];
    if (@available(iOS 13.0, *)) {
        [_switchModeSegc setSelectedSegmentTintColor:gdColor];
    } else {
        [_switchModeSegc setTintColor:gdColor];
    }
    [_switchModeSegc setBackgroundColor:kHexColor(0x3c3d62)];
    [_switchModeSegc setTitleTextAttributes:@{NSForegroundColorAttributeName:gdColor} forState:UIControlStateNormal];
    [_switchModeSegc setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
}

- (void)updateLoginStatusUIIsRefreshing:(BOOL)isRefreshing {
    if ([CNUserManager shareManager].isLogin) {
        [self configLogInUI];
        if (isRefreshing) {
            [self reloadBalance];
        } else {
            [[BalanceManager shareManager] getBalanceDetailHandler:^(AccountMoneyDetailModel * _Nonnull model) {
                
                float amount = model.yebAmount.floatValue + model.yebInterest.floatValue + model.balance.floatValue;
                [self.moneyLb hideIndicatorWithText:[@(amount) jk_toDisplayNumberWithDigit:2]];
            }];
        }
    } else {
        [self configLogoutUI];
    }
}

- (void)configLogoutUI {
    self.loginView.hidden = NO;
    self.headerIcon.image = nil;
    self.usdtADImgv.hidden = YES;
}

- (void)configLogInUI {
    self.loginView.hidden = YES;
    [self refreshBottomBtnsStatus];
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:[CNUserManager shareManager].userDetail.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];

    NSInteger level = [CNUserManager shareManager].userInfo.starLevel;
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"vip%ld", (long)level]];
    self.vipImgv.image = img;
    
    self.usrNameLb.text = [CNUserManager shareManager].printedloginName;
    self.currencyLb.text = [CNUserManager shareManager].isUsdtMode?@"USDT":@"CNY";
    
    if ([CNUserManager shareManager].isUiModeHasOptions) {
        _switchModeSegc.hidden = NO;
        _questionBtn.hidden = NO;
    } else {
        _switchModeSegc.hidden = YES;
        _questionBtn.hidden = YES;
    }
}

- (void)reloadBalance{
    if ([CNUserManager shareManager].isLogin) {
        [self.moneyLb showIndicatorIsBig:NO];
        //金额
        [[BalanceManager shareManager] requestBalaceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
            [self.moneyLb hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.switchModeSegc setEnabled:YES];
            });
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
        _switchModeSegc.selectedSegmentIndex = 1;
        self.currencyLb.text = @"USDT";
        if ([CNUserManager shareManager].userInfo.starLevel == 0) {
            self.usdtADImgv.hidden = NO;
        }

    } else {
        _switchModeSegc.selectedSegmentIndex = 0;
        self.currencyLb.text = @"CNY";
        self.usdtADImgv.hidden = YES;
    }
}

// 切换账户货币
- (IBAction)switchAccount:(UIButton *)sender {
    [sender setEnabled:false];
    if (_delegate && [_delegate respondsToSelector:@selector(switchAccountAction)]) {
        [_delegate switchAccountAction];
    }
}
- (IBAction)switchAccountWhileClik:(UISegmentedControl *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(switchAccountAction)]) {
        [_delegate switchAccountAction];
    }
}

- (IBAction)didTapQuestion:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(questionAction)]) {
        [_delegate questionAction];
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
