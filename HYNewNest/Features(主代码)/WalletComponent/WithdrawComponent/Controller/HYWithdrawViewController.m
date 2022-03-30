//
//  HYWithdrawViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYWithdrawViewController.h"
#import "HYTabBarViewController.h"
#import "CNTradeRecodeVC.h"
#import "BYModifyPhoneVC.h"

#import "HYXiMaTopView.h"
#import "CNTwoStatusBtn.h"
#import "HYWideOneBtnAlertView.h"
#import <MJRefresh.h>
#import "HYWithdrawCardCell.h"
#import "HYWithdrawAddCardFooter.h"
#import "HYWithdrawComfirmView.h"
#import "HYWithdrawCalculatorComView.h"
#import "HYWithdrawChooseWallectComView.h"
#import "HYWithdrawActivityAlertView.h"
#import "HYOneImgBtnAlertView.h"
#import "HYTextAlertView.h"
#import "HYDownloadLinkView.h"
#import "BYChangeFundPwdVC.h"
#import "BYYuEBaoVC.h"
#import "UIColor+Gradient.h"

#import "CNEncrypt.h"
#import "CNWithdrawRequest.h"
#import "CNWDAccountRequest.h"
#import "BalanceManager.h"
#import <IVLoganAnalysis/IVLAManager.h>

#import "BYWithdrawConfirmVC.h"
#import "KYMWithdrawConfirmVC.h"
#import "KYMWithdrewRequest.h"
#import "MBProgressHUD+Add.h"
#import "IVRsaEncryptWrapper.h"
#import "KYMNormalWithdrewSuccessVC.h"
#import "KYMMatchWithdrewSuccessVC.h"
#import <CSCustomSerVice/CSCustomSerVice.h>
#import "KYMWithdrawHistoryView.h"
#import "CNMAlertView.h"
@interface HYWithdrawViewController () <UITableViewDelegate, UITableViewDataSource, BYWithdrawDelegate>
{
    BOOL _isCNYBlockLevel;
}
@property (weak, nonatomic) IBOutlet UILabel *withdrawAmoutLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *sumitBtn;
@property (nonatomic, strong) HYWithdrawComfirmView *comfirmView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withdrawBtnBtmConst;

@property (nonatomic, assign) NSInteger selectedIdx;
@property (nonatomic, strong) NSMutableArray<AccountModel *> *elecCardsArr;//所有卡 根据当前模式只会是银行卡 或者 子账户钱包账户
@property (nonatomic, strong) NSMutableArray<AccountModel *> *subWalletAccounts;//子账户所有钱包
@property (nonatomic, strong) AccountMoneyDetailModel *moneyModel;
@property (nonatomic, strong) WithdrawCalculateModel *giftCalculatorModel;//带参数计算后的 全额和拆分会有所不同

@property (weak, nonatomic) IBOutlet UIView *fundpwdEntryBg;
@property (strong,nonatomic) HYDownloadLinkView *linkView;
@property (assign,nonatomic) BOOL needWithdrawPwd;

@property (weak, nonatomic) IBOutlet UIButton *explanationButton;
@property (weak, nonatomic) IBOutlet UIButton *transferYEBButton;
@property (weak, nonatomic) IBOutlet UILabel *withdrawableLb;

@property (weak, nonatomic) IBOutlet UILabel *hisOrderNoLB;
@property (weak, nonatomic) IBOutlet UILabel *hisAmountLB;
@property (weak, nonatomic) IBOutlet UIButton *hisConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *hisNoConfirmBtn;
@property (weak, nonatomic) IBOutlet UIStackView *hisOrderStackView;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;

@property (nonatomic, strong) KYMWithdrewCheckModel *checkModel;

@end

@implementation HYWithdrawViewController

static NSString * const KCardCell = @"HYWithdrawCardCell";

#pragma mark - Lazy
- (HYDownloadLinkView *)linkView {
    if (!_linkView) {
        HYDownloadLinkView *linkView = [[HYDownloadLinkView alloc] initWithFrame:CGRectMake(80, 0, 240, 30) normalText:@"提现需要资金密码，" tapableText:@"前往设置" tapColor:kHexColor(0x3176F0) hasUnderLine:YES urlValue:nil];
        linkView.tapBlock = ^{
//            [strongSelf.navigationController pushViewController:[BYChangeFundPwdVC new] animated:YES];
            [BYChangeFundPwdVC modalVc];
        };
        _linkView = linkView;
    }
    return _linkView;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    self.withdrawableLb.text = [CNUserManager shareManager].isUsdtMode ? @"可提现金额 (USDT)" : @"可提现金额 (CNY)";
    [self.sumitBtn setTitle:@"提现" forState:UIControlStateNormal];
    [self addNaviRightItemWithImageName:@"kf"];
    
    self.selectedIdx = 0;
    [self setupHistory];
    [self setupTableView];
    
    [self.explanationButton setTitleColor:[UIColor gradientFromColor:kHexColor(0x19CECE)
                                                             toColor:kHexColor(0x10B4DD)
                                                           withWidth:self.explanationButton.size.width]
                                 forState:UIControlStateNormal];
    
//    [self.transferYEBButton setHidden:[CNUserManager shareManager].isUsdtMode ? false : true];
    [self.transferYEBButton setHidden:true];
    
    // 动态表单
    [CNWithdrawRequest checkIsNeedWithdrawPwdHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            NSDictionary *dict = responseObj[0];
            if ([dict[@"password_flag"] integerValue] == 1) {
                [self.fundpwdEntryBg addSubview:self.linkView];
                self.needWithdrawPwd = YES;
            }
        }
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self bunchRequest];
}

- (void)bunchRequest {
    [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
        [self requestBalance];
        [self requestWithdrawAddress];
        
        if ([CNUserManager shareManager].isUsdtMode == false) {
            [self checkBlackListLevel];
        }

    }];
    if (![CNUserManager shareManager].isUsdtMode) {
        [KYMWithdrewRequest checkWithdrawWithCallBack:^(BOOL isMatch,KYMWithdrewCheckModel *model) {
            self.checkModel = model;
            if (model && model.data.mmProcessingOrderType == 2 && model.data.mmProcessingOrderStatus == 2 && model.data.mmProcessingOrderPairStatus == 5) {
                self.hisAmountLB.text = model.data.mmProcessingOrderAmount;
                self.hisOrderNoLB.text = model.data.mmProcessingOrderTransactionId;
                self.tableViewTop.constant = 140;
                self.historyView.hidden = NO;
            }
        }];
    }
}

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC];
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
    self.tableViewTop.constant = 6;
}

- (void)setupHistory
{
    self.hisConfirmBtn.layer.borderWidth = 1.0;
    self.hisConfirmBtn.layer.cornerRadius = 16;
    self.hisConfirmBtn.layer.borderColor = [UIColor colorWithRed:0x10 / 255.0 green:0xB4 / 255.0 blue:0xDD / 255.0 alpha:1].CGColor;
    self.hisConfirmBtn.layer.masksToBounds = YES;
    self.hisNoConfirmBtn.layer.borderWidth = 1.0;
    self.hisNoConfirmBtn.layer.cornerRadius = 16;
    self.hisNoConfirmBtn.layer.borderColor = [UIColor colorWithRed:0x10 / 255.0 green:0xB4 / 255.0 blue:0xDD / 255.0 alpha:1].CGColor;
    self.hisNoConfirmBtn.layer.masksToBounds = YES;
    self.hisAmountLB.text = @"";
    self.hisOrderNoLB.text = @"";
    self.hisOrderStackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hisOrderNoGesture)];
    [self.hisOrderStackView addGestureRecognizer:gesture];
    self.historyView.hidden = YES;
}


#pragma mark - ACTION
- (void)hisOrderNoGesture
{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.hisOrderNoLB.text;
    [MBProgressHUD showMessagNoActivity:@"已复制" toView:nil];
}
- (void)showMatchConfirmAlert
{
    __weak typeof(self)weakSelf = self;
    [CNMAlertView showAlertTitle:@"温馨提示" content:@"老板！请您再次确认是否到账" desc:nil needRigthTopClose:YES commitTitle:@"没有到账" commitAction:^{
        [weakSelf noConfirm];
    } cancelTitle:@"确认到账" cancelAction:^{
        [KYMWithdrewRequest checkReceiveStats:NO transactionId:weakSelf.hisOrderNoLB.text callBack:^(BOOL status, NSString *msg) {
            if (status) {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:msg toView:nil];
            }
        }];
    }];
}
- (void)noConfirm {
    [KYMWithdrewRequest checkReceiveStats:YES transactionId:self.hisOrderNoLB.text callBack:^(BOOL status, NSString *msg) {
        if (status) {
            // 联系客服
            [CSVisitChatmanager startWithSuperVC:self.navigationController.childViewControllers.firstObject finish:^(CSServiceCode errCode) {
                if (errCode != CSServiceCode_Request_Suc) {
                    [MBProgressHUD showError:@"暂时无法链接，请贵宾改以电话联系，感谢您的理解与支持" toView:nil];
                }
            }];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:msg toView:nil];
        }
    }];
}
- (IBAction)confirmBtnClicked:(id)sender {
    [self showMatchConfirmAlert];
}
- (IBAction)noConfirmBtnClicked:(id)sender {
    [self showMatchConfirmAlert];
}

- (IBAction)didTapWithdrawBtn:(id)sender {
    if (![CNUserManager shareManager].userDetail.mobileNoBind) {
        [HYTextAlertView showWithTitle:@"手机绑定" content:@"对不起！系统发现您还没有绑定手机，请先完成手机绑定流程，再进行提现操作。" comfirmText:@"去绑定" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm) {
            if (isComfirm) {
                [BYModifyPhoneVC modalVcWithSMSCodeType:CNSMSCodeTypeBindPhone];
            } else {
                [CNTOPHUB showError:@"用户拒绝"];
            }
        }];
        return;
    }
    
    // 负信用等级不能取rmb
    if (self->_isCNYBlockLevel) {
        [self showCNYBandAlert];
        return;
    }
    
    // 判断卡
    if (self.elecCardsArr.count == 0) {
        [CNTOPHUB showError:[NSString stringWithFormat:@"请先绑定至少%@",[CNUserManager shareManager].isUsdtMode?@"一个钱包地址":@"一张银行卡"]];
        return;
    }
    
    if (!self.moneyModel) {
        [CNTOPHUB showError:@"未能获取到可提余额，请下拉刷新试试"];
        return;
    }
    
    if ([CNUserManager shareManager].isUsdtMode) {
        BYWithdrawConfirmVC *vc = [[BYWithdrawConfirmVC alloc] initWithDelegate:self
                                                            selectedBankAccount:self.elecCardsArr[self.selectedIdx]
                                                            andAvailableBalance:self.moneyModel];

        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [NNControllerHelper getCurrentViewController].definesPresentationContext = YES;
        [kCurNavVC presentViewController:vc animated:YES completion:^{
            vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        }];
    }
    else {
        KYMWithdrawConfirmVC *vc = [[KYMWithdrawConfirmVC alloc] init];
        vc.checkModel = self.checkModel;
        vc.balanceModel = self.moneyModel;
        __weak typeof(self)weakSelf = self;
        __weak typeof(vc)weakVC = vc;
        vc.submitHandler = ^(NSString * _Nonnull pwd, NSString * _Nonnull amount, BOOL isMatch) {
            if (self.elecCardsArr.count == 0) {
                return;
            }
            pwd = [IVRsaEncryptWrapper encryptorString:pwd];
            if (isMatch) {//撮合取款
                [weakSelf requestMatchWithdrawWithPwd:pwd amount:amount confirmVC:weakVC];
            } else {//普通取款
                [weakSelf sumbimtWithdrawAmount:amount pwd:pwd confirmVC:weakVC];
            }
            
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)didTapNewCNYRule {
    if (self.calculatorModel) {
        NSString *cont = [NSString stringWithFormat:@"1、需要最低取款%ld元，如不足则会按全额转入USDT账户；\n2、USDT账户如已绑定钱包，则会直接取款到数字钱包；如没有绑定，则转入USDT账户额度；", (long)self.calculatorModel.exchangeAmountLimit];
        [HYWideOneBtnAlertView showWithTitle:@"提现说明" content:cont comfirmText:@"我知道了" comfirmHandler:^{
        }];
    }
}

- (IBAction)yuebaoDidClicked:(id)sender {
    [self.navigationController pushViewController:[BYYuEBaoVC new] animated:true];
}

- (IBAction)explanationClicked:(id)sender {
    NSString *tx = [CNUserManager shareManager].isUsdtMode ? @"提币USDT" : @"提现金额";
    NSString *content = [NSString stringWithFormat:@"根据《菲律宾反洗钱法》规定：\n1. %@需达到充币的1倍有效投注额\n2. 可%@金额＝总资产 - 各厅不足1%@下的金额\n3. 如参与了网站的优惠活动，%@需根据相关活动规则有效投注额\n\n具体%@情况以审核完结果为准。", tx, tx, [CNUserManager shareManager].userInfo.currency, tx, tx];
    [HYWideOneBtnAlertView showWithTitle:[NSString stringWithFormat:@"%@说明", tx] content:content comfirmText:@"我知道了" comfirmHandler:^{
    }];
}

- (void)showCNYBandAlert {
    [HYOneImgBtnAlertView showWithImgName:@"img-warning" contentString:@"为保障您的资金安全，\n详情联系客服咨询" btnText:@"联系客服" handler:^(BOOL isComfirm) {
        if (isComfirm) {
            [NNPageRouter presentOCSS_VC];
        }
    }];
}

#pragma mark - REQUEST
- (void)checkBlackListLevel {
    [CNWithdrawRequest checkCNYBlacklistDepositLevelHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            NSDictionary *dic = responseObj[0];
            NSString *blocks = dic[@"block_list"];
            NSArray *list = [blocks componentsSeparatedByString:@";"];
            NSString *depLev = [NSString stringWithFormat:@"%ld",[CNUserManager shareManager].userDetail.depositLevel];

            // 负信用等级不能取rmb
            if ([list containsObject:depLev] && !(([CNUserManager shareManager].userDetail.starLevel > 1 && [depLev isEqualToString:@"-11"]) || [depLev isEqualToString:@"-13"])) {
                self->_isCNYBlockLevel = YES;
                [self showCNYBandAlert];
                return;
            }
        }
    }];
}

- (void)requestBalance {
    [self.withdrawAmoutLabel showIndicatorIsBig:YES];
    [BalanceManager requestWithdrawAbleBalanceHandler:^(AccountMoneyDetailModel * _Nonnull model) {
        if (self.moneyModel.withdrawBal == nil)
            self.moneyModel.withdrawBal = @(0);
        self.moneyModel = model;
        [self.withdrawAmoutLabel hideIndicatorWithText:[model.withdrawBal jk_toDisplayNumberWithDigit:2]];
        self.sumitBtn.enabled = YES;
    }];
}
//创建撮合取款提案
- (void)requestMatchWithdrawWithPwd:(NSString *)pwd amount:(NSString *)amount confirmVC:(UIViewController *)confirmVC
{
    AccountModel *model = self.elecCardsArr[self.selectedIdx];
    [KYMWithdrewRequest createWithdrawWithBankNum:model.accountId amount:amount pwd:pwd callback:^(BOOL status, NSString * _Nonnull msg, KYMCreateWithdrewModel  *_Nonnull model) {
        if (!status) {
            [MBProgressHUD showError:msg toView:nil];
            return;
        }
        KYMMatchWithdrewSuccessVC *vc = [[KYMMatchWithdrewSuccessVC alloc] init];
        vc.transactionId = model.referenceId;
        CGFloat notAmount = floor([model.amount doubleValue] * 0.005 * 100) / 100;
        vc.amountStr = [NSString stringWithFormat:@"%0.2lf",notAmount];;
        [confirmVC dismissViewControllerAnimated:YES completion:^{
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    }];
}
- (void)requestWithdrawAddress {
    WEAKSELF_DEFINE
    [CNWDAccountRequest queryAccountHandler:^(id responseObj, NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        STRONGSELF_DEFINE
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            
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
                    if (strongSelf.elecCardsArr.count == 3) {
                        weakSelf.tableView.tableFooterView = nil;
                    }
                    
                    
                }
            }
            [self.tableView reloadData];
        }
    }];
}

// 取款返利规则
- (void)requestCNYWithdrawNewRuleAmount:(nullable NSString *)amount AccountId:(nullable NSString *)accountId handler:(void(^)(void))handler {
    [CNWithdrawRequest withdrawCalculatorMode:accountId?@0:@1
                                       amount:amount
                                    accountId:accountId
                                      handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            self.giftCalculatorModel = [WithdrawCalculateModel cn_parse:responseObj];
            !handler?:handler();
        }
    }];
}

/// ------ CNY提现
// 提交取款金额
- (void)sumbimtWithdrawAmount:(NSString *)amout pwd:(NSString *)pwd confirmVC:(UIViewController *)confirmVC {
    // 请求最后一步的闭包
    WEAKSELF_DEFINE
    if (self.elecCardsArr.count == 0) {
        return;
    }
    AccountModel *model = self.elecCardsArr[self.selectedIdx];
    
    /*
    __block NSString *giftAmount;
    //判断该用户是否需要拆分
    
    if (self.calculatorModel && self.calculatorModel.creditExchangeFlag) {
        [self.comfirmView hideView];
        
        // 计算接口 保存数据 -> 提现明细 -> 选择钱包/转USDT余额 -> 弹窗。。
        [self requestCNYWithdrawNewRuleAmount:amout
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
                    [CNWithdrawRequest submitWithdrawRequestAmount:amout
                                                         accountId:model.accountId
                                                          protocol:model.protocol
                                                           remarks:@""
                                                  subWallAccountId:[NSString stringWithFormat:@"%@", args]
                                                          password:pwd
                                                           handler:^(id responseObj, NSString *errorMsg) {
                        STRONGSELF_DEFINE
                        if (!errorMsg) {
                            [strongSelf.comfirmView showSuccessWithdrawCNYExUSDT:self.giftCalculatorModel.promoInfo.refAmount dismissBlock:^{
                                MyLog(@"点击了关闭");
                                [HYWithdrawActivityAlertView showHandedOutGiftUSDTAmount:giftAmount handler:^{
                                    [strongSelf requestBalance];
                                    [[NSNotificationCenter defaultCenter] postNotificationName:BYRefreshBalanceNotification object:nil]; // 让首页和我的余额刷新
                                }];
                            }];
                        } else {
                            [strongSelf.comfirmView removeView];
                        }
                    }];
                }];
            }];
        }];
        
    } else { //走正常流程*/
        [CNWithdrawRequest submitWithdrawRequestAmount:amout
                                             accountId:model.accountId
                                              protocol:model.protocol
                                               remarks:@""
                                      subWallAccountId:nil
                                              password:pwd
                                               handler:^(id responseObj, NSString *errorMsg) {
            STRONGSELF_DEFINE
            if (!errorMsg) {
                
                [confirmVC dismissViewControllerAnimated:YES completion:^{
                    KYMNormalWithdrewSuccessVC *vc = [KYMNormalWithdrewSuccessVC new];
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                [strongSelf requestBalance];
                [[NSNotificationCenter defaultCenter] postNotificationName:BYRefreshBalanceNotification object:nil]; // 让首页和我的余额刷新
            } else {
            }
        }];



}

#pragma mark - TABLEVIEW

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = self.view.backgroundColor;
    bgView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    UILabel *lblTitle = [[UILabel alloc] init];
    [bgView addSubview:lblTitle];
    lblTitle.frame = CGRectMake(15, 60-15-17, 100, 17);
    lblTitle.text = [CNUserManager shareManager].isUsdtMode ? @"提现地址" : @"提现至";
//    lblTitle.textColor = kHexColorAlpha(0xFFFFFF, 0.4);
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font = [UIFont fontPFR16];
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

#pragma mark -
#pragma mark BYWithdrawDelegate
- (void)sumitWithdrawSuccess {
    [self requestBalance];
}

@end
