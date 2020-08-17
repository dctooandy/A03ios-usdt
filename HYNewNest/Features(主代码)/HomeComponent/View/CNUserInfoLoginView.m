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

@interface CNUserInfoLoginView ()
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet CNVIPLabel *vipLb;
@property (weak, nonatomic) IBOutlet UILabel *moneyLb;
@property (weak, nonatomic) IBOutlet UILabel *currencyLb;
@property (weak, nonatomic) IBOutlet UIButton *showHideBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewSpacing;

#pragma - mark 未登录属性
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation CNUserInfoLoginView

- (void)loadViewFromXib {
    [super loadViewFromXib];

    // 按钮边框颜色
    self.registerBtn.layer.borderColor = kHexColor(0x19CECE).CGColor;
    self.registerBtn.layer.borderWidth = 1;
}

- (void)updateLoginStatusUI {
    if ([CNUserManager shareManager].isLogin) {
        [self configLogInUI];
        [self reloadBalance];
        if ([CNUserManager shareManager].userDetail.newAccountFlag == 1) {
            self.switchModeBtn.hidden = YES;
        } else {
            self.switchModeBtn.hidden = NO;
            [self switchAccountUIChange];
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

    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:[CNUserManager shareManager].userInfo.avatar]];
    self.nameLb.text = [CNUserManager shareManager].printedloginName;
    self.vipLb.text = [NSString stringWithFormat:@"VIP%ld", [CNUserManager shareManager].userInfo.starLevel];
    // 默认展示底部视图
    self.showHideBtn.selected = YES;
    [self showHide:self.showHideBtn];
}

- (void)reloadBalance {
    //金额
    WEAKSELF_DEFINE
    [CNUserCenterRequest requestAccountBalanceHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        AccountMoneyDetailModel *model = [AccountMoneyDetailModel cn_parse:responseObj];
        if (!model) {
            return;
        }
        strongSelf.moneyLb.text = [model.balance jk_toDisplayNumberWithDigit:2];
        strongSelf.currencyLb.text = model.currency;
        
    }];
}

- (void)switchAccountUIChange {
    if (self.bottomView.hidden) {
        [self showHide:self.showHideBtn]; //切换时展开 不然会有消失不见的奇怪的问题
    }
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

// 消息
- (IBAction)massge:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(messageAction)]) {
        [_delegate messageAction];
    }
}

// 切换账户货币
- (IBAction)switchAccount:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(switchAccountAction)]) {
        [_delegate switchAccountAction];
    }
}

- (IBAction)showHide:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.bottomView.hidden = sender.selected;
    self.bottomViewH.constant = sender.selected ? 0: [CNUserManager shareManager].isUsdtMode?88:44;
    self.bottomViewSpacing.constant = sender.selected ? -44: [CNUserManager shareManager].isUsdtMode?-44:0;
    if (_delegate && [_delegate respondsToSelector:@selector(showHideAction:)]) {
        [_delegate showHideAction:sender.selected];
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


- (IBAction)register:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(registerAction)]) {
        [_delegate registerAction];
    }
}

@end
