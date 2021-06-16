//
//  CNMineVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/25.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNMineVC.h"
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
#import "BYSuperCopartnerVC.h"
#import "BYVocherCenterVC.h"
#import "BYNewUsrMissionVC.h"
#import "BYYuEBaoVC.h"

#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "UILabel+hiddenText.h"
#import "NSURL+HYLink.h"
#import "UILabel+Gradient.h"

#import "CNVIPLabel.h"
#import "HYWideOneBtnAlertView.h"
#import "BYOldMyWalletView.h"
#import "BYMyWalletView.h"

#import "CNUserCenterRequest.h"
#import "CNLoginRequest.h"

@interface CNMineVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/// 滚动视图
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
/// 滚动视图宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentW;

#pragma mark 顶部信息
/// 头像
@property (weak, nonatomic) IBOutlet UIButton *headerIV;
/// VIP
@property (weak, nonatomic) IBOutlet CNVIPLabel *VIPLb;
/// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;

#pragma mark 钱包部分
@property (weak, nonatomic) IBOutlet UIView *walletContainerView;
@property (strong,nonatomic) BYBaseWalletAbsView *walletView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletContainerHeightCons;

#pragma mark 好友邀请
@property (weak, nonatomic) IBOutlet UIView *shareBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareBgViewH;

#pragma mark 中间入口部分
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *entryIconBtns;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *entryIconLbs;

#pragma mark 底部单个下载
/// App图片
@property (weak, nonatomic) IBOutlet UIImageView *appImageV;
/// App名称
@property (weak, nonatomic) IBOutlet UILabel *appNameLb;
/// App描述
@property (weak, nonatomic) IBOutlet UILabel *appDescLb;
/// 下载按钮
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@property (nonatomic, strong) NSArray<OtherAppModel *> *otherApps;

#pragma mark CNY和USDT区别
/// CNY和USDT 切换按钮
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIStackView *USDTBusinessView;
@property (weak, nonatomic) IBOutlet UIView *lastEntryView;

@end

@implementation CNMineVC

- (NSArray *)getCurrentFastEntryName {
    if ([CNUserManager shareManager].userInfo.newWalletFlag) {
        if ([CNUserManager shareManager].isUsdtMode) {
            return @[@"优惠券", @"余额宝", @"交易记录", @"消息中心", @"提币地址", @"安全中心"];
        } else {
            return @[@"优惠券", @"交易记录", @"消息中心", @"银行卡", @"安全中心", @"意见反馈"];
        }
        
    } else {
        return @[@"交易记录", @"消息中心", [CNUserManager shareManager].isUsdtMode?@"提币地址":@"银行卡", @"安全中心", @"意见反馈"];
    }
}

- (NSArray *)getCurrentFastEntryIconName {
    if ([CNUserManager shareManager].userInfo.newWalletFlag) {
        if ([CNUserManager shareManager].isUsdtMode) {
            return @[@"yhq", @"yeb", @"jl", @"xx", @"yhk", @"aq",];
        } else {
            return @[@"yhq", @"jl", @"xx", @"yhk", @"aq", @"yjfk"];
        }
    } else {
        return @[@"jl", @"xx", @"yhk", @"aq", @"yjfk"];
    }
}


#pragma mark - ViewLifeCycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideNavgation = YES;
    __weak typeof(self) wSelf = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wSelf switchCurrencyUI];
        [wSelf requestOtherAppData];
    }];
   
    [self switchCurrencyUI];
    [self requestOtherAppData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCurrencyUI) name:HYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchCurrencyUI) name:HYSwitchAcoutSuccNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self requestAccountBalances:NO];
    [self.walletView requestAccountBalances:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self configUI];
}

- (void)configUI {
    self.scrollContentW.constant = kScreenWidth;
    // 按钮边框颜色
    self.downLoadBtn.layer.borderColor = kHexColor(0x19CECE).CGColor;
    self.downLoadBtn.layer.borderWidth = 1;
    self.switchBtn.layer.borderColor = kHexColor(0x19CECE).CGColor;
    self.switchBtn.layer.borderWidth = 1;
    
}

#pragma mark - 按钮事件

// 设置
- (IBAction)setting:(id)sender {
    [self.navigationController pushViewController:[CNSettingVC new] animated:YES];
}

/// 充提洗
- (IBAction)didClickMCTMBtns:(UIButton *)sender {
    //???: 充提指南 逻辑怎么处理?
    if ([CNUserManager shareManager].isUsdtMode && [CNUserManager shareManager].userInfo.starLevel == 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowCTZNEUserDefaultKey]) {
        HYNewCTZNViewController *vc = [HYNewCTZNViewController new];
        vc.type = sender.tag;
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    if (sender.tag == 0) { // 充值
        [NNPageRouter jump2Deposit];
        
    } else if (sender.tag == 1) { // 提现
        [NNPageRouter jump2Withdraw];
        
    } else { //洗码
        [self.navigationController pushViewController:[HYXiMaViewController new] animated:YES];
    }
}

- (IBAction)didTapEntryBtns:(UIButton *)sender {
    NSString *name = [self getCurrentFastEntryName][sender.tag];
    if ([name isEqualToString:@"优惠券"]) {
        [self.navigationController pushViewController:[BYVocherCenterVC new] animated:YES];
    } else if ([name isEqualToString:@"洗码"]) {
        [self.navigationController pushViewController:[HYXiMaViewController new] animated:YES];
    } else if ([name isEqualToString:@"交易记录"]) {
        [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
    } else if ([name isEqualToString:@"消息中心"]) {
        [self.navigationController pushViewController:[CNMessageCenterVC new] animated:YES];
    } else if ([name isEqualToString:@"提币地址"] || [name isEqualToString:@"银行卡"]) {
        [self.navigationController pushViewController:[CNAddressManagerVC new] animated:YES];
    } else if ([name isEqualToString:@"安全中心"]) {
        [self.navigationController pushViewController:[CNSecurityCenterVC new] animated:YES];
    } else if ([name isEqualToString:@"意见反馈"]) {
        [self.navigationController pushViewController:[CNFeedBackVC new] animated:YES];
    } else if ([name isEqualToString:@"余额宝"]) {
        [self.navigationController pushViewController:[BYYuEBaoVC new] animated:YES];
    }
}


// 邀请
- (IBAction)invite:(id)sender {
//    [self.navigationController pushViewController:[CNInviteFriendVC new] animated:YES];
    [self.navigationController pushViewController:[BYSuperCopartnerVC new] animated:YES];
}

// 下载APP
- (IBAction)doloadApp:(id)sender {
    
    if (!_otherApps || _otherApps.count == 0) {
        [kKeywindow jk_makeToast:@"正在请求更多APP数据 请稍后.." duration:3 position:JKToastPositionCenter];
        [self requestOtherAppData];
        return;
    }
    OtherAppModel *model = self.otherApps[0];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.appDownUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.appDownUrl] options:@{} completionHandler:^(BOOL success) {
            [CNTOPHUB showSuccess:@"正在为您跳转..."];
        }];
    } else {
        [CNTOPHUB showError:@"未知错误 无法下载"];
    }
    
}

// 更多下载
- (IBAction)moreDoload:(id)sender {
    if (!_otherApps || _otherApps.count == 0) {
        [kKeywindow jk_makeToast:@"正在请求更多APP数据 请稍后.." duration:3 position:JKToastPositionCenter];
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
//        if (!errorMsg) { //已经有监听通知了
//            [self switchCurrencyUI];
//        }
    }];
}

/// 切换账户的时候 （刷新界面和数据）
- (void)switchCurrencyUI {
    
    // 1.不同货币模式UI变化
    self.switchBtn.hidden = ![CNUserManager shareManager].isUiModeHasOptions;
    
    BOOL isUsdtMode = [CNUserManager shareManager].isUsdtMode;
    BOOL isNewWallet = [CNUserManager shareManager].userInfo.newWalletFlag;
    self.switchBtn.selected = !isUsdtMode;
    
    self.lastEntryView.alpha = isNewWallet?1:0;
        
    self.shareBgView.hidden = !isUsdtMode;
    self.shareBgViewH.constant = isUsdtMode?AD(90):0;
    
    [self setUpUserInfoAndBalaces];
    
}

- (void)setUpUserInfoAndBalaces {
    if ([CNUserManager shareManager].isLogin) {
        // 1.入口信息
        [self.entryIconLbs enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arr = [self getCurrentFastEntryName];
            if (idx < arr.count) {
                obj.text = arr[idx];
            }
        }];
        [self.entryIconBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arr = [self getCurrentFastEntryIconName];
            if (idx < arr.count) {
                NSString *img = arr[idx];
                [obj setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
            }
        }];
        
        // 2.用户信息
        self.VIPLb.text = [NSString stringWithFormat:@"VIP%ld", (long)[CNUserManager shareManager].userInfo.starLevel];
        
        self.nickNameLb.text = [CNUserManager shareManager].printedloginName;
        [self.nickNameLb sizeToFit];
        [self.nickNameLb setupGradientColorFrom:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
        
        [self.headerIV sd_setBackgroundImageWithURL:[NSURL URLWithString:[CNUserManager shareManager].userDetail.avatar] forState:UIControlStateNormal];
        
        // 3.加载WalletView YES
        // 判断用户是新钱包还是旧钱包
        if ([CNUserManager shareManager].userInfo.newWalletFlag) {
            if (!self.walletContainerView.subviews.count || [self.walletView isMemberOfClass:[BYOldMyWalletView class]]) {
                [self.walletView removeFromSuperview];
                self.walletView = [BYMyWalletView new];
                self.walletContainerHeightCons.constant = 67;
                [self.walletContainerView addSubview:self.walletView];
                [self.walletView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.equalTo(self.walletContainerView);
                    make.height.mas_equalTo(202);
                }];
                BYMyWalletView *view = (BYMyWalletView *)self.walletView;
                view.expandBlock = ^(BOOL isExpand) {
                    if (isExpand) {
                        if ([CNUserManager shareManager].isUsdtMode) {
                            self.walletContainerHeightCons.constant = 67*3;
                        } else {
                            self.walletContainerHeightCons.constant = 67*2;
                        }
                    } else {
                        self.walletContainerHeightCons.constant = 67;
                    }
                };
            }
            [self.walletView requestAccountBalances:YES];
            
        } else {
            if (!self.walletContainerView.subviews.count || [self.walletView isMemberOfClass:[BYMyWalletView class]]) {
                [self.walletView removeFromSuperview];
                self.walletView = [[BYOldMyWalletView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 148)];
                self.walletContainerHeightCons.constant = 148;
                [self.walletContainerView addSubview:self.walletView];
            }
            [self.walletView requestAccountBalances:YES];
        }
    }
}

#pragma mark - REQUEST

- (void)requestOtherAppData {
    [CNUserCenterRequest requestOtherGameAppListHandler:^(id responseObj, NSString *errorMsg) {
        [self.scrollView.mj_header endRefreshing];
        if (errorMsg) {
            return;
        }
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



@end
