//
//  CNMineVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/25.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNMineVC.h"
#import "CNVIPLabel.h"
#import "CNUserCenterRequest.h"
#import <UIButton+WebCache.h>
#import "UILabel+hiddenText.h"
#import "CNSettingVC.h"
#import "CNSecurityCenterVC.h"
#import "CNTradeRecodeVC.h"
#import "HYNewCTZNViewController.h"
#import "HYXiMaViewController.h"
#import "CNMessageCenterVC.h"
#import "CNDownloadVC.h"
#import "CNInviteFriendVC.h"
#import "CNFeedBackVC.h"
#import "CNAddressManagerVC.h"
#import "HYWideOneBtnAlertView.h"
#import "HYWithdrawViewController.h"
#import "HYRechargeViewController.h"
#import "HYRechargeCNYViewController.h"
#import "CNLoginRequest.h"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"
#import <MJRefresh/MJRefresh.h>

@interface CNMineVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/// 滚动视图
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
/// 滚动视图宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentW;

#pragma mark - 顶部信息
/// 头像
@property (weak, nonatomic) IBOutlet UIButton *headerIV;
/// VIP
@property (weak, nonatomic) IBOutlet CNVIPLabel *VIPLb;
/// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
/// 金额
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
/// 货币
@property (weak, nonatomic) IBOutlet UILabel *currencyLb;
/// 本周投注额
@property (weak, nonatomic) IBOutlet UILabel *weekAmountLb;
/// 本月优惠
@property (weak, nonatomic) IBOutlet UILabel *monthPromoLb;
/// 本月戏码
@property (weak, nonatomic) IBOutlet UILabel *monthXiMaLb;

#pragma mark - 好友邀请
@property (weak, nonatomic) IBOutlet UIView *shareBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBgViewH;

#pragma mark - 底部单个下载
/// App图片
@property (weak, nonatomic) IBOutlet UIImageView *appImageV;
/// App名称
@property (weak, nonatomic) IBOutlet UILabel *appNameLb;
/// App描述
@property (weak, nonatomic) IBOutlet UILabel *appDescLb;
/// 下载按钮
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@property (nonatomic, strong) NSArray<OtherAppModel *> *otherApps;

#pragma mark - CNY和USDT区别
/// CNY和USDT 切换按钮
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
/// 中间六个模块中第四个模块标签
@property (weak, nonatomic) IBOutlet UILabel *forthTapLb;
/// 中间六个模块中第六个模块标签
@property (weak, nonatomic) IBOutlet UILabel *sixthTapLb;
/// CNY
@property (weak, nonatomic) IBOutlet UIView *CNYBusinessView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CNYBusinessViewH;
/// USDT
@property (weak, nonatomic) IBOutlet UIStackView *USDTBusinessView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *USDTBusinessViewH;
@end

@implementation CNMineVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideNavgation = YES;
    [self configUI];
    [self requestOtherAppData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCurrencyUI) name:HYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCurrencyUI) name:HYSwitchAcoutSuccNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    kPreventRepeatTime(60);
    [self switchCurrencyUI];

}

- (void)configUI {
    self.scrollContentView.backgroundColor = self.view.backgroundColor;
    self.scrollContentW.constant = kScreenWidth;
    // 按钮边框颜色
    self.downLoadBtn.layer.borderColor = kHexColor(0x19CECE).CGColor;
    self.downLoadBtn.layer.borderWidth = 1;
    self.switchBtn.layer.borderColor = kHexColor(0x19CECE).CGColor;
    self.switchBtn.layer.borderWidth = 1;
    
    __weak typeof(self) wSelf = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wSelf switchCurrencyUI];
    }];
}

#pragma mark - 按钮事件

// 显示和隐藏
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

// 设置
- (IBAction)setting:(id)sender {
    [self.navigationController pushViewController:[CNSettingVC new] animated:YES];
}


/// 买充提卖
- (IBAction)didClickMCTMBtns:(UIButton *)sender {
    //usdt模式下 未选择“不再提醒”充提指南 => 进充提指南
    if ([CNUserManager shareManager].isUsdtMode && ![[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowCTZNEUserDefaultKey]) {
        [self presentViewController:[HYNewCTZNViewController new] animated:YES completion:^{
        }];
    
    } else {
        if (sender.tag == 0) { // 买币
            [NNPageRouter openExchangeElecCurrencyPageIsSell:NO];
            
        } else if (sender.tag == 1) { // 充值
            if ([CNUserManager shareManager].isUsdtMode) {
                [self.navigationController pushViewController:[HYRechargeViewController new] animated:YES];
            } else {
                [self.navigationController pushViewController:[HYRechargeCNYViewController new] animated:YES];
            }
            
        } else if (sender.tag == 2) { // 提现
            [self.navigationController pushViewController:[HYWithdrawViewController new] animated:YES];
            
        } else { //卖币
            [HYWideOneBtnAlertView showWithTitle:@"卖币跳转" content:@"正在为您跳转..请稍后。\n在交易所卖币数字货币，买家会将金额支付到您的银行卡，方便快捷。" comfirmText:@"我知道了，帮我跳转" comfirmHandler:^{
                [NNPageRouter openExchangeElecCurrencyPageIsSell:YES];
            }];
        }
    }
}


// 洗码
- (IBAction)xima:(id)sender {
    [self.navigationController pushViewController:[HYXiMaViewController new] animated:YES];
}

// 交易记录
- (IBAction)tradeRecord:(id)sender {
    [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
}

// 消息中心
- (IBAction)messageCenter:(id)sender {
    [self.navigationController pushViewController:[CNMessageCenterVC new] animated:YES];
}

// 提现地址/银行卡
- (IBAction)withdrawAddress:(id)sender {
    [self.navigationController pushViewController:[CNAddressManagerVC new] animated:YES];
}

// 安全中心
- (IBAction)securityCenter:(id)sender {
    [self.navigationController pushViewController:[CNSecurityCenterVC new] animated:YES];
}

// 充提指南/意见反馈
- (IBAction)recharWithdrawGuide:(id)sender {
    if ([CNUserManager shareManager].isUsdtMode) {
        HYNewCTZNViewController *vc = [HYNewCTZNViewController new];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    } else {
        [self.navigationController pushViewController:[CNFeedBackVC new] animated:YES];
    }
}

// 邀请
- (IBAction)invite:(id)sender {
    [self.navigationController pushViewController:[CNInviteFriendVC new] animated:YES];
}

// 下载APP
- (IBAction)doloadApp:(id)sender {
    if (!_otherApps || _otherApps.count == 0) {
        [kKeywindow jk_makeToast:@"正在请求下载数据 请稍后.."];
        [self requestOtherAppData];
        return;
    }
    OtherAppModel *model = self.otherApps[0];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.appDownUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.appDownUrl] options:@{} completionHandler:^(BOOL success) {
            [CNHUB showSuccess:@"正在为您跳转..."];
        }];
    } else {
        [CNHUB showError:@"未知错误 无法下载"];
    }
}

// 更多下载
- (IBAction)moreDoload:(id)sender {
    if (!_otherApps || _otherApps.count == 0) {
        [kKeywindow jk_makeToast:@"正在请求下载数据 请稍后.."];
        [self requestOtherAppData];
        return;
    }
    CNDownloadVC * downVc = [CNDownloadVC new];
    downVc.otherApps = self.otherApps;
    [self.navigationController pushViewController:downVc animated:YES];
}

#pragma mark - 货币界面业务切换

- (IBAction)switchCurrency:(UIButton *)sender {
    
    [CNLoginRequest switchAccountSuccessHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [self switchCurrencyUI];
        }
    }];
}

/// 切换账户的时候 （刷新界面和数据）
- (void)switchCurrencyUI {
    
    // 1.不同货币模式UI变化
    self.switchBtn.hidden = [CNUserManager shareManager].userDetail.newAccountFlag;
    
    BOOL isUsdtMode = [CNUserManager shareManager].isUsdtMode;
    self.switchBtn.selected = !isUsdtMode;
    self.currencyLb.text = isUsdtMode ? @"USDT": @"CNY";
    self.USDTBusinessView.hidden = !isUsdtMode;
    self.USDTBusinessViewH.constant = isUsdtMode ? 80: 0;
    self.CNYBusinessView.hidden = isUsdtMode;
    self.CNYBusinessViewH.constant = isUsdtMode ? 0: 80;
    
    self.forthTapLb.text = isUsdtMode ? @"提币地址": @"银行卡";
    self.sixthTapLb.text = isUsdtMode ? @"充值指南": @"意见反馈";
    
    self.shareBgView.hidden = !isUsdtMode;
    self.shareBgViewH.constant = isUsdtMode?AD(90):0;
    
    // 2.用户信息
    if ([CNUserManager shareManager].isLogin) {
        self.VIPLb.text = [NSString stringWithFormat:@"VIP%ld", [CNUserManager shareManager].userInfo.starLevel];
        self.nickNameLb.text = [CNUserManager shareManager].printedloginName;
        [self.headerIV sd_setBackgroundImageWithURL:[NSURL URLWithString:[CNUserManager shareManager].userDetail.avatar] forState:UIControlStateNormal];
        
        // 3.加载相关金额
        [self requestAccountBalance];
        [self requestBetAmount];
        [self requestMonthPromoteAndXima];
    }
    
}

#pragma mark - REQUEST

- (void)requestOtherAppData {
    [CNUserCenterRequest requestOtherGameAppListHandler:^(id responseObj, NSString *errorMsg) {
        NSArray *otherApps = [OtherAppModel cn_parse:responseObj];
        if (otherApps.count > 0) {
            self.otherApps = otherApps;
            OtherAppModel *model = otherApps.firstObject;
            self.appNameLb.text = model.appName;
            self.appDescLb.text = model.appDesc;
            [self.appImageV sd_setImageWithURL:[NSURL getUrlWithString:model.appImage] placeholderImage:[UIImage imageNamed:@"2"]];
        }
    }];
}

- (void)requestMonthPromoteAndXima {
    [self.monthPromoLb showIndicatorIsBig:NO];
    [self.monthXiMaLb showIndicatorIsBig:NO];
    WEAKSELF_DEFINE
    [CNUserCenterRequest requestMonthPromoteAndXimaHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        
        PromoteXimaModel *pxModel = [PromoteXimaModel cn_parse:responseObj];
        
//        strongSelf.monthPromoLb.originText = [pxModel.promoAmountByMonth jk_toDisplayNumberWithDigit:2];
//        strongSelf.monthXiMaLb.originText = [pxModel.rebatedAmountByMonth jk_toDisplayNumberWithDigit:2];
        [strongSelf.monthPromoLb hideIndicatorWithText:[pxModel.promoAmountByMonth jk_toDisplayNumberWithDigit:2]];
        [strongSelf.monthXiMaLb hideIndicatorWithText:[pxModel.rebatedAmountByMonth jk_toDisplayNumberWithDigit:2]];
    }];
}

- (void)requestAccountBalance {
    [self.amountLb showIndicatorIsBig:NO];
    WEAKSELF_DEFINE
    [CNUserCenterRequest requestAccountBalanceHandler:^(id responseObj, NSString *errorMsg) {
        
        STRONGSELF_DEFINE
        AccountMoneyDetailModel *model = [AccountMoneyDetailModel cn_parse:responseObj];
        
//        strongSelf.amountLb.originText = [model.balance jk_toDisplayNumberWithDigit:2];
        [strongSelf.amountLb hideIndicatorWithText:[model.balance jk_toDisplayNumberWithDigit:2]];
        strongSelf.currencyLb.text = model.currency;
        
        [strongSelf.scrollView.mj_header endRefreshing];
    }];
}

- (void)requestBetAmount {
    [self.weekAmountLb showIndicatorIsBig:NO];
    WEAKSELF_DEFINE
    [CNUserCenterRequest requestBetAmountHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        BetAmountModel *model = [BetAmountModel cn_parse:responseObj];
        
//        strongSelf.weekAmountLb.originText = [model.weekBetAmount jk_toDisplayNumberWithDigit:2];
        [strongSelf.weekAmountLb hideIndicatorWithText:[model.weekBetAmount jk_toDisplayNumberWithDigit:2]];
    }];
}


@end
