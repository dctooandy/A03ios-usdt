//
//  HYWithdrawViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYWithdrawViewController.h"
#import "HYXiMaTopView.h"
#import "CNTwoStatusBtn.h"
#import "HYWideOneBtnAlertView.h"
#import <MJRefresh.h>
#import "HYWithdrawCardCell.h"
#import "HYWithdrawAddCardFooter.h"
#import "HYWithdrawComfirmView.h"
#import "CNCompleteInfoVC.h"
#import "HYTabBarViewController.h"
#import "HYWithdrawCalculatorComView.h"
#import "HYWithdrawChooseWallectComView.h"
#import "HYWithdrawActivityAlertView.h"

#import "CNTradeRecodeVC.h"

#import "CNWithdrawRequest.h"
#import "CNWDAccountRequest.h"
#import "BalanceManager.h"
#import <IVLoganAnalysis/IVLAManager.h>

@interface HYWithdrawViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet HYXiMaTopView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *sumitBtn;
@property (nonatomic, strong) HYWithdrawComfirmView *comfirmView;

@property (nonatomic, assign) NSInteger selectedIdx;
@property (nonatomic, strong) NSMutableArray<AccountModel *> *elecCardsArr;//所有卡 根据当前模式只会是银行卡 或者 子账户钱包账户
@property (nonatomic, strong) NSMutableArray<AccountModel *> *subWalletAccounts;//子账户所有钱包
@property (nonatomic, strong) AccountMoneyDetailModel *moneyModel;
@property (nonatomic, strong) WithdrawCalculateModel *giftCalculatorModel;//带参数计算后的 全额和拆分会有所不同

@end

@implementation HYWithdrawViewController
static NSString * const KCardCell = @"HYWithdrawCardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [CNUserManager shareManager].isUsdtMode ? @"提币" : @"提现";
    [self.sumitBtn setTitle:[CNUserManager shareManager].isUsdtMode ? @"提币" : @"提现" forState:UIControlStateNormal];
//    [self addNaviRightItemWithImageName:@"service"];
    
    self.selectedIdx = 0;
    [self setupTopView];
    [self setupTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [(HYTabBarViewController *)[NNControllerHelper currentTabBarController] showSuspendBall];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getBalance];
    [self requestWithdrawAddress];;
    
    if ((![CNUserManager shareManager].isUsdtMode)
        && (![CNUserManager shareManager].userDetail.mobileNoBind || ![CNUserManager shareManager].userDetail.realName)) {
        [HYTextAlertView showWithTitle:@"完善信息" content:@"对不起！系统发现您还没有完成实名认证，请先完成实名认证，再进行提现操作。" comfirmText:@"去认证" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm){
            if (isComfirm) {
                [self.navigationController pushViewController:[CNCompleteInfoVC new] animated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)bunchRequest {
    [self requestBalance];
    [self requestWithdrawAddress];
}

//- (void)rightItemAction {
//    [NNPageRouter jump2Live800Type:CNLive800TypeDeposit];
//}


- (void)setupTopView {
    NSString *tx = [CNUserManager shareManager].isUsdtMode?@"提币USDT":@"提现金额";
    self.topView.lblTitle.text = [NSString stringWithFormat:@"可%@", tx];
    [self.topView.ruleBtn setTitle:@" 说明" forState:UIControlStateNormal];
    
    self.topView.clickBlock = ^{
        if (![CNUserManager shareManager].isUsdtMode && self.calculatorModel.creditExchangeFlag) {
            [self didTapNewCNYRule];
        } else {
            NSString *content = [NSString stringWithFormat:@"根据《菲律宾反洗钱法》规定：\n1. %@需达到充币的1倍有效投注额\n2. 可%@金额＝总资产 - 各厅不足1%@下的金额\n3. 如参与了网站的优惠活动，%@需根据相关活动规则有效投注额\n\n具体%@情况以审核完结果为准。", tx, tx, [CNUserManager shareManager].userInfo.currency, tx, tx];
            [HYWideOneBtnAlertView showWithTitle:[NSString stringWithFormat:@"%@说明", tx] content:content comfirmText:@"我知道了" comfirmHandler:^{
            }];
        }
        
    };
}

- (void)setupTableView {
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 106;
    [self.tableView registerNib:[UINib nibWithNibName:KCardCell bundle:nil] forCellReuseIdentifier:KCardCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(bunchRequest)];
    
    UINib *nib = [UINib nibWithNibName:@"HYWithdrawAddCardFooter" bundle:nil];
    HYWithdrawAddCardFooter *footer = [nib instantiateWithOwner:nil options:nil].firstObject;
    footer.frame = CGRectMake(0, 0, kScreenWidth, 106);
    self.tableView.tableFooterView = footer;
    
    self.sumitBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sumitBtn.layer.shadowOffset = CGSizeMake(2.0, 2.0f);
    self.sumitBtn.layer.shadowOpacity = 0.13f; //透明度

}


#pragma mark - ACTION
- (IBAction)didTapWithdrawBtn:(id)sender {
    WEAKSELF_DEFINE
    HYWithdrawComfirmView *view = [[HYWithdrawComfirmView alloc] initWithAmountModel:self.moneyModel sumbitBlock:^(NSString * withdrawAmout) {
        STRONGSELF_DEFINE
        [strongSelf sumbimtWithdrawAmount:withdrawAmout];
    }];
    self.comfirmView = view;
    [self.view addSubview:view];
}

- (void)didTapNewCNYRule {
    if (self.calculatorModel) {
        NSString *cont = [NSString stringWithFormat:@"1、需要最低取款%ld元，如不足则会按全额转入USDT账户；\n2、USDT账户如已绑定钱包，则会直接取款到数字钱包；如没有绑定，则转入USDT账户额度；", self.calculatorModel.exchangeAmountLimit];
        [HYWideOneBtnAlertView showWithTitle:@"提现说明" content:cont comfirmText:@"我知道了" comfirmHandler:^{
        }];
    }
}

- (void)getBalance {
    [self.topView.lblAmount showIndicatorIsBig:YES];
    [[BalanceManager shareManager] getBalanceDetailHandler:^(AccountMoneyDetailModel * _Nonnull model) {
        self.moneyModel = model;
        [self.topView.lblAmount hideIndicatorWithText:[model.withdrawBal jk_toDisplayNumberWithDigit:2]];
        self.sumitBtn.enabled = YES;
    }];
}

#pragma mark - REQUEST
- (void)requestBalance {
    [self.topView.lblAmount showIndicatorIsBig:YES];
    [[BalanceManager shareManager] requestBalaceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
        self.moneyModel = model;
        [self.topView.lblAmount hideIndicatorWithText:[model.withdrawBal jk_toDisplayNumberWithDigit:2]];
        self.sumitBtn.enabled = YES;
    }];
}

- (void)requestWithdrawAddress {
    WEAKSELF_DEFINE
    [CNWDAccountRequest queryAccountHandler:^(id responseObj, NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        STRONGSELF_DEFINE
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            
            // 子账户钱包是否有值 CNYyong
            if (responseObj[@"subWalletAccounts"]) {
                NSArray *subAccounts = responseObj[@"subWalletAccounts"];
                strongSelf.subWalletAccounts = [AccountModel cn_parse:subAccounts];
            }
            
            
            NSArray *accountArr = responseObj[@"accounts"];
            NSArray *accounts = [AccountModel cn_parse:accountArr];
            //手动筛选
            strongSelf.elecCardsArr = @[].mutableCopy;

            for (AccountModel *subModel in accounts) {
                if ([subModel.bankName isEqualToString:@"BTC"]) {
                    
                    // usdt卡
                } else if (([subModel.bankName isEqualToString:@"USDT"] || [subModel.bankName isEqualToString:@"DCBOX"])
                           && [CNUserManager shareManager].isUsdtMode) {
                    if ([subModel.bankName isEqualToString:@"DCBOX"]) {
                        subModel.bankName = @"小金库";
                    }
                    [strongSelf.elecCardsArr addObject:subModel];
                    
                    // 银行卡
                } else if (!([subModel.bankName isEqualToString:@"USDT"] || [subModel.bankName isEqualToString:@"DCBOX"] || [subModel.bankName isEqualToString:@"BITOLL"])
                           && ![CNUserManager shareManager].isUsdtMode) {
                    [strongSelf.elecCardsArr addObject:subModel];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

// 取款返利规则
- (void)requestCNYWithdrawNewRuleAmount:(nullable NSNumber *)amount AccountId:(nullable NSString *)accountId handler:(void(^)(void))handler {
    [CNWithdrawRequest withdrawCalculatorMode:accountId?@0:@1
                                       amount:amount
                                    accountId:accountId
                                      handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            self.giftCalculatorModel = [WithdrawCalculateModel cn_parse:responseObj];
            !handler?:handler();
        }
    }];
}

- (void)sumbimtWithdrawAmount:(NSString *)amout {
    // 请求最后一步的闭包
    WEAKSELF_DEFINE
    AccountModel *model = self.elecCardsArr[self.selectedIdx];
    NSNumber *amount = [NSNumber numberWithDouble:[amout doubleValue]];
    
    /// ------ USDT提现
    if ([CNUserManager shareManager].isUsdtMode) {
        [CNWithdrawRequest submitWithdrawRequestAmount:amount
                                             accountId:model.accountId
                                              protocol:model.protocol
                                               remarks:@""
                                      subWallAccountId:nil
                                               handler:^(id responseObj, NSString *errorMsg) {
            STRONGSELF_DEFINE
            if (KIsEmptyString(errorMsg)) {
                [strongSelf.comfirmView showSuccessWithdraw];
                [strongSelf requestBalance];
            } else {
                [strongSelf.comfirmView removeView];
            }
        }];
        
    /// ------ CNY提现
    } else {
        __block NSString *giftAmount;
        //判断该用户是否需要拆分
        if (self.calculatorModel && self.calculatorModel.creditExchangeFlag) {
            [self.comfirmView hideView];
            
            // 计算接口 保存数据 -> 提现明细 -> 选择钱包/转USDT余额 -> 弹窗。。
            [self requestCNYWithdrawNewRuleAmount:amount
                                        AccountId:model.accountId
                                          handler:^(){
                
                [HYWithdrawCalculatorComView showWithCalculatorModel:self.giftCalculatorModel
                                            exchangeRatioOfAllAmount:self.calculatorModel.creditExchangeRatio
                                                       submitHandler:^(BOOL isComfirm, id  _Nonnull args, ...){
                    if (!isComfirm) {
                        [self.comfirmView removeView];
                        return;
                    }
                    giftAmount = args;
                    
                    MyLog(@"点击了下一步");
                    [HYWithdrawChooseWallectComView showWithAmount:self.giftCalculatorModel.promoInfo.refAmount subWalAccountsModel:self.subWalletAccounts submitHandler:^(BOOL isComfirm, id  _Nonnull args, ...) {
                        if (!isComfirm) {
                            [self.comfirmView removeView];
                            return;
                        }
                        
                        MyLog(@"选好子钱包了");
                        [CNWithdrawRequest submitWithdrawRequestAmount:amount
                                                             accountId:model.accountId
                                                              protocol:model.protocol
                                                               remarks:@""
                                                      subWallAccountId:[NSString stringWithFormat:@"%@", args]
                                                               handler:^(id responseObj, NSString *errorMsg) {
                            STRONGSELF_DEFINE
                            if (KIsEmptyString(errorMsg)) {
                                [strongSelf.comfirmView showSuccessWithdrawCNYExUSDT:self.giftCalculatorModel.promoInfo.refAmount dismissBlock:^{
                                    MyLog(@"点击了关闭");
                                    [HYWithdrawActivityAlertView showHandedOutGiftUSDTAmount:giftAmount handler:^{
                                        [strongSelf requestBalance];
                                    }];
                                }];
                            } else {
                                [strongSelf.comfirmView removeView];
                            }
                        }];
                    }];
                }];
            }];
            
        } else { //走正常流程
            [CNWithdrawRequest submitWithdrawRequestAmount:amount
                                                 accountId:model.accountId
                                                  protocol:model.protocol
                                                   remarks:@""
                                          subWallAccountId:nil
                                                   handler:^(id responseObj, NSString *errorMsg) {
                STRONGSELF_DEFINE
                if (KIsEmptyString(errorMsg)) {
                    [strongSelf.comfirmView showSuccessWithdraw];
                    [strongSelf requestBalance];
                } else {
                    [strongSelf.comfirmView removeView];
                }
            }];
        }
        
    }

}

#pragma mark - TABLEVIEW

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = self.view.backgroundColor;
    bgView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    UILabel *lblTitle = [[UILabel alloc] init];
    [bgView addSubview:lblTitle];
    lblTitle.frame = CGRectMake(30, 60-15-17, 100, 17);
    lblTitle.text = [CNUserManager shareManager].isUsdtMode ? @"提币地址" : @"提现至";
    lblTitle.textColor = kHexColorAlpha(0xFFFFFF, 0.4);
    lblTitle.font = [UIFont fontPFR15];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.elecCardsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYWithdrawCardCell *cell = [tableView dequeueReusableCellWithIdentifier:KCardCell];
    cell.model = self.elecCardsArr[indexPath.row];
    //tableView reloadDate会将所有的cell恢复成未选中状态,任何在reloadData方法执行完毕之前设置的选中状态都会失效.所以使用异步的方式将设置选中状态推迟到下一次runLoop,这样cell的选中状态就不会被tableView重置
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.selectedIdx == indexPath.row) {
            [cell setSelected:YES animated:YES];
        } else {
            [cell setSelected:NO animated:YES];
        }
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger oldSel = self.selectedIdx;
    self.selectedIdx = indexPath.row;
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldSel inSection:0],indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [tableView reloadData];
}



@end
