//
//  HYRechargeCNYViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/11.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYRechargeCNYViewController.h"
#import "CNTwoStatusBtn.h"
#import "CNRechargeRequest.h"
#import "HYRechargePayWayController.h"
#import "HYRechargeHelper.h"
#import "ChargeManualMessgeView.h"
#import "CNTradeRecodeVC.h"
#import "HYRechargeCNYEditView.h"
#import "HYWithdrawComfirmView.h"
#import "CNUserCenterRequest.h"
#import "CNRechargeChosePayTypeVC.h"
#import "LYEmptyView.h"
#import "UIView+Empty.h"
#import <IN3SAnalytics/CNTimeLog.h>
#import "HYWideOneBtnAlertView.h"
#import "BYBindRealNameVC.h"
#import "BYCNYRechargeAlertView.h"
#import "CNLoginRequest.h"
#import "BYLargeAmountView.h"

#import "CNMAlertView.h"
#import "CNMatchPayRequest.h"
#import "CNMBankModel.h"
#import "CNMatchDepositStatusVC.h"
#import <CSCustomSerVice/CSCustomSerVice.h>
#import "CNMBillView.h"
#import "CNWAmountListModel.h"
#import "CNMUploadView.h"

@interface HYRechargeCNYViewController () <HYRechargeCNYEditViewDelegate>
@property (nonatomic, assign) NSInteger selcPayWayIdx;
@property (strong, nonatomic) NSArray <PayWayV3PayTypeItem *> *paytypeList;  //支付方式
@property (nonatomic, strong) OnlineBanksModel *curOnliBankModel;
@property (strong, nonatomic) AmountListModel *curAmountModel;

@property (nonatomic, strong) CNTwoStatusBtn *btnSubmit;
@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) HYRechargeCNYEditView *editView;
@property (nonatomic, strong) BYLargeAmountView *largeAmountView;
@property (nonatomic, strong) CNWFastPayModel *fastModel;
@end

@implementation HYRechargeCNYViewController

#pragma mark - lazy load
- (UIScrollView *)scrollContainer {
    if (!_scrollContainer) {
        _scrollContainer = [[UIScrollView alloc] init];
        _scrollContainer.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:_scrollContainer];
    }
    return _scrollContainer;
}

- (HYRechargeCNYEditView *)editView {
    if (!_editView) {
        _editView = [HYRechargeCNYEditView new];
        _editView.delegate = self;
        [self.scrollContainer addSubview:_editView];
    }
    return _editView;
}

- (BYLargeAmountView *)largeAmountView {
    if (!_largeAmountView) {
        _largeAmountView = [BYLargeAmountView new];
        [self.scrollContainer addSubview:_largeAmountView];
    }
    return _largeAmountView;
}

#pragma mark - Setter
- (void)setSelcPayWayIdx:(NSInteger)selcPayWayIdx {
    if (!_paytypeList || _paytypeList.count == 0) {
        return;
    }
    _selcPayWayIdx = selcPayWayIdx;
    [self refreshQueryData];
}


#pragma mark - View life cycle

- (instancetype)init {
    [CNTimeLog startRecordTime:CNEventPayLaunch];
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CNY充值";
    [self addNaviRightItemWithImageName:@"kf"];
//    [[NNControllerHelper currentTabBarController] performSelector:@selector(showSuspendBall)];
    
    _selcPayWayIdx = 0;
    
    if ([CNUserManager shareManager].isUsdtMode == false && [[CNUserManager shareManager] userDetail].depositLevel == -11 && [[CNUserManager shareManager] userInfo].starLevel < 2) {
        [BYCNYRechargeAlertView showAlertWithContent:@"CNY通道维护中\n建议切换使用USDT账户" cancelText:@"我知道了" confirmText:@"切换USDT账户" comfirmHandler:^(BOOL isComfirm) {
            WEAKSELF_DEFINE
            [CNLoginRequest switchAccountSuccessHandler:^(id responseObj, NSString *errorMsg) {
                if (!errorMsg) {
                    [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
                        if (!errorMsg) {
                            [weakSelf.navigationController popToRootViewControllerAnimated:true];
                        }
                    }];
                }
            } faileHandler:nil];
        }];
        [self setupSubmitBtnWithHidden:false];
    }
    else {
        [self qureyFastPay];
        [self setupSubmitBtnWithHidden:YES];
        [self queryCNYPayways];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_hasRecord) {
        [CNTimeLog endRecordTime:CNEventPayLaunch];
        _hasRecord = YES;
    }
}

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC];
}

- (BOOL)isVIP {
    return ([CNUserManager shareManager].isUsdtMode == false &&
            ([CNUserManager shareManager].userDetail.depositLevel == 30 ||
             ([CNUserManager shareManager].userDetail.depositLevel >=5 &&
              [CNUserManager shareManager].userDetail.depositLevel <= 10 &&
              [CNUserManager shareManager].userDetail.starLevel >= 5)));
}

- (void)setupMainEditView {
    [self.scrollContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    CGFloat editViewHeight = 510;
    //92:支付宝秒存 91:微信秒存 90：迅捷网银
    NSArray *array = @[@"91", @"92", @"93"];
    if ([array containsObject:self.paytypeList[_selcPayWayIdx].payType]) {
        if (self.fastModel.isAvailable &&
            self.fastModel.mmProcessingOrderTransactionId.length == 0 &&
            self.fastModel.amountList.count > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (CNWAmountListModel *model in self.fastModel.amountList) {
                [array addObject:model.amount];
            }
            self.editView.matchAmountList = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
                if (obj1.intValue < obj2.intValue) {
                    return NSOrderedDescending;
                }
                return NSOrderedAscending;
            }];
            editViewHeight += 50 * MIN(ceilf(self.editView.matchAmountList.count/3.0), 3);
        }
    }
    if ([self isVIP]) {
        [self.largeAmountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollContainer).offset(15);
            make.top.equalTo(self.scrollContainer).offset(15);
            make.height.mas_equalTo(120);
            make.width.equalTo(self.scrollContainer.mas_width).offset(-30);
        }];
        
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollContainer).offset(15);
            make.top.equalTo(self.largeAmountView.mas_bottom).offset(15);
            make.height.mas_equalTo(editViewHeight).priority(MASLayoutPriorityDefaultLow);
            make.width.equalTo(self.scrollContainer.mas_width).offset(-30);
        }];
        self.scrollContainer.contentSize = CGSizeMake(self.view.size.width, editViewHeight+120+120);
    }
    else {
        [self.editView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollContainer).offset(15);
            make.top.equalTo(self.scrollContainer).offset(15);
            make.height.mas_equalTo(editViewHeight).priority(MASLayoutPriorityDefaultLow);
            make.width.equalTo(self.scrollContainer.mas_width).offset(-30);
        }];
        self.scrollContainer.contentSize = CGSizeMake(self.view.size.width, editViewHeight+120);
    }

    [self.editView setupPayTypeItem:self.paytypeList[_selcPayWayIdx]
                          bankModel:self.curOnliBankModel
                        amountModel:self.curAmountModel];
}

- (void)setupSubmitBtn {
    [self setupSubmitBtnWithHidden:false];
}

- (void)setupSubmitBtnWithHidden:(BOOL)hidden {
    CNTwoStatusBtn *subBtn = [[CNTwoStatusBtn alloc] init];
    [subBtn setTitle:@"提交" forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(submitRechargeRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollContainer addSubview:subBtn];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editView.mas_left).offset(0);
        make.right.equalTo(self.editView.mas_right).offset(0);
        make.top.equalTo(self.editView.mas_bottom).offset(60);
        make.height.mas_equalTo(48);
    }];
    self.btnSubmit = subBtn;
    self.btnSubmit.hidden = hidden;
}

#pragma mark - HYRechargeCNYEditViewDelegate

- (void)didTapSwitchBtnModel:(PayWayV3PayTypeItem *)paytypeItem {
    HYRechargePayWayController *vc = [[HYRechargePayWayController alloc] initWithPaywayItems:self.paytypeList selcIdx:self.selcPayWayIdx];
    vc.navPopupBlock = ^(id obj) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            self.selcPayWayIdx = [(NSNumber *)obj integerValue];
        }
        [self.editView clearAmountData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didChangeIsStatusRight:(BOOL)isStatusRight { 
    self.btnSubmit.enabled = isStatusRight;
}

#pragma mark - 急速存款业务

/// 查询急速转账数据

- (void)qureyFastPay {
    [CNMatchPayRequest queryFastPayOpenFinish:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            self.fastModel = [CNWFastPayModel cn_parse:responseObj];
            if (self.fastModel.mmProcessingOrderType == 1 && self.fastModel.mmProcessingOrderTransactionId.length > 0) {
                [self showTradeBill];
            }
        }
    }];
}

- (void)showTradeBill {
    CNMBillView *view = [[CNMBillView alloc] init];
    if (self.fastModel.mmProcessingOrderStatus == 2) {
        [view setUpload:NO promoTag:NO];
        [view.statusBtn addTarget:self action:@selector(confirmBill) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [view setUpload:YES promoTag:(self.fastModel.needUploadFlag != 1)];
        [view.statusBtn addTarget:self action:@selector(showUploadUI) forControlEvents:UIControlEventTouchUpInside];
    }
    self.editView.billViewH.constant = 66;
    self.editView.billView.hidden = NO;
    [self.editView.billView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    view.amountLb.text = [NSString stringWithFormat:@"%.2f", self.fastModel.mmProcessingOrderAmount.doubleValue];
    view.billNoLb.text = self.fastModel.mmProcessingOrderTransactionId;
}

- (void)showUploadUI {
    [CNMUploadView showUploadViewTo:self billId:self.fastModel.mmProcessingOrderTransactionId promo:(self.fastModel.needUploadFlag != 1) upload:(self.fastModel.mmProcessingOrderStatus == CNMPayBillStatusConfirm) commitDeposit:nil];
}

- (void)confirmBill {
    CNMatchDepositStatusVC *statusVC = [[CNMatchDepositStatusVC alloc] init];
    statusVC.transactionId = self.fastModel.mmProcessingOrderTransactionId;
    [self.navigationController pushViewController:statusVC animated:YES];
}

#pragma mark - REQUEST

- (void)queryCNYPayways {
    [CNRechargeRequest queryPayWaysV3Handler:^(id responseObj, NSString *errorMsg) {
        if (errorMsg) {
            return;
        }
        PayWayV3Model *resultModel = [PayWayV3Model cn_parse:responseObj];
        //去掉手工存款 paytype = 0 的情况。不再支持此方式，服务器去不掉只能客户端做过滤
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:resultModel.payTypeList];
        for (PayWayV3PayTypeItem *item in resultModel.payTypeList) {
            if ([item.payType isEqualToString:@"0"] || [item.payTypeName isEqualToString:@"比特币"] || [item.payTypeName containsString:@"USDT"] || [item.payTypeName containsString:@"币付宝"]) {
                [tmp removeObject:item];
            }
        }
        if (tmp.count > 0){
            //寻找lastpaytype，放到第一个
            PayWayV3PayTypeItem *lastItem = nil;
            for (PayWayV3PayTypeItem *item in tmp) {
                if ([item.payType isEqualToString:resultModel.lastPayType]) {
                    lastItem = item;
                }
            }
            if (lastItem) {
                [tmp removeObject:lastItem];
                [tmp insertObject:lastItem atIndex:0];
            }
            
            self.paytypeList = (NSArray<PayWayV3PayTypeItem *> *)[NSArray arrayWithArray:tmp];
            [self refreshQueryData];
        } else {
            [BYCNYRechargeAlertView showAlertWithContent:@"CNY通道维护中\n建议切换使用USDT账户" cancelText:@"我知道了" confirmText:@"切换USDT账户" comfirmHandler:^(BOOL isComfirm) {
                WEAKSELF_DEFINE
                [CNLoginRequest switchAccountSuccessHandler:^(id responseObj, NSString *errorMsg) {
                    if (!errorMsg) {
                        [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
                            if (!errorMsg) {
                                [weakSelf.navigationController popToRootViewControllerAnimated:true];
                            }
                        }];
                    }
                } faileHandler:nil];
            }];
        }
        
    }];
}

- (void)refreshQueryData {
    [self setupSubmitBtnWithHidden:NO];
    PayWayV3PayTypeItem *item = self.paytypeList[_selcPayWayIdx];
    if (![HYRechargeHelper isOnlinePayWay:item]) {
        [self queryTransferAmount];
    } else {
        [self queryOnlineBankAmount];
    }
    
}

/**
 转账类支付
 */
- (void)queryTransferAmount {
    PayWayV3PayTypeItem *item = self.paytypeList[_selcPayWayIdx];
    [CNRechargeRequest queryAmountListPayType:item.payType
                                      handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            AmountListModel *aModel = [AmountListModel cn_parse:responseObj];
            self.curAmountModel = aModel;
            [self setupMainEditView];
        }
    }];
}

/**
 在线类支付 需要
 */
- (void)queryOnlineBankAmount {
    PayWayV3PayTypeItem *item = self.paytypeList[_selcPayWayIdx];
    [CNRechargeRequest queryOnlineBanksPayType:item.payType
                                  usdtProtocol:nil
                                       handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            OnlineBanksModel *oModel = [OnlineBanksModel cn_parse:responseObj];
            self.curOnliBankModel = oModel;
            [self setupMainEditView];
        }
    }];
}

/**
 提交订单
 */
- (void)submitRechargeRequest {
    if (KIsEmptyString([CNUserManager shareManager].userDetail.realName)) {
        [BYBindRealNameVC modalVCBindRealName];
        return;;
    }
    
    __block PayWayV3PayTypeItem *item = self.paytypeList[_selcPayWayIdx];
    if ([HYRechargeHelper isOnlinePayWay:item]) {
        
        //在线支付
        [CNRechargeRequest submitOnlinePayOrderRMBAmount:self.editView.rechargeAmount
                                                 payType:item.payType
                                                   payid:self.curOnliBankModel.payid
                                                 handler:^(id responseObj, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
                PayOnlinePaymentModel *paymentModel = [PayOnlinePaymentModel cn_parse:responseObj];
                NSURL *payUrl = [NSURL URLWithString:paymentModel.payUrl];
                if ([[UIApplication sharedApplication] canOpenURL:payUrl]) {
                    [[UIApplication sharedApplication] openURL:payUrl options:@{} completionHandler:^(BOOL success) {
                        [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
                        // 支付等待
                        HYWithdrawComfirmView *view = [[HYWithdrawComfirmView alloc] initWithAmountModel:nil needPwd:NO sumbitBlock:nil];
                        [self.view addSubview:view];
                        [view showRechargeWaiting];
                    }];
                } else {
                    [CNTOPHUB showError:@"充值渠道链接错误"];
                }
            }
        }];
    
    } else {
        BOOL isMatch = [self.editView.matchAmountList containsObject:self.editView.rechargeAmount];
        if (isMatch) {
            [self submitMatchBill];
        } else {
            [self submitBQBill];
        }
    }
}

- (void)submitMatchBill {
    //提交订单
    __weak typeof(self) weakSelf = self;
    [CNMatchPayRequest createDepisit:self.editView.rechargeAmount realName:self.editView.depositor finish:^(id responseObj, NSString *errorMsg) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)responseObj;
            if ([[dic objectForKey:@"mmFlag"] boolValue]) {
                CNMBankModel *bank = [CNMBankModel cn_parse:[dic objectForKey:@"mmPaymentRsp"]];
                if (bank) {
                    // 成功跳转
                    CNMatchDepositStatusVC *statusVC = [[CNMatchDepositStatusVC alloc] init];
                    statusVC.transactionId = bank.transactionId;
                    [weakSelf.navigationController pushViewController:statusVC animated:YES];
                    return;
                }
            }
        }
        // 失败走普通存款
        [weakSelf submitBQBill];
    }];
}

// BQ转账
- (void)submitBQBill {
    __block PayWayV3PayTypeItem *item = self.paytypeList[_selcPayWayIdx];
    [CNRechargeRequest submitBQPaymentPayType:item.payType
                                       amount:self.editView.rechargeAmount
                                    depositor:self.editView.depositor?:self.editView.depositorId
                                depositorType:self.editView.depositor?0:1
                                      handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            BQPaymentModel *paymentBQModel = [BQPaymentModel cn_parse:responseObj];
            paymentBQModel.payWay = item.payTypeName;
            if ([item.payType isEqualToString:@"92"]) {
                //支付宝转账
                paymentBQModel.payWayType = @0;
            }else if ([item.payType isEqualToString:@"91"]) {
                //微信转账
                paymentBQModel.payWayType = @1;
            }else if ([item.payType isEqualToString:@"90"]) {
                //银行卡转账
                paymentBQModel.payWayType = @2;
            }
            CNRechargeChosePayTypeVC *vc = [[CNRechargeChosePayTypeVC alloc] initWithModel:paymentBQModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

@end
