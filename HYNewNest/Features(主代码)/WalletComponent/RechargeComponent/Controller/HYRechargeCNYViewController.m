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
#import "HYRechargePayWayController.h"
#import "HYWithdrawComfirmView.h"
#import "CNUserCenterRequest.h"
#import "CNRechargeChosePayTypeVC.h"
#import "LYEmptyView.h"
#import "UIView+Empty.h"
#import "HYTabBarViewController.h"
#import "IN3SAnalytics.h"

@interface HYRechargeCNYViewController () <HYRechargeCNYEditViewDelegate>
@property (nonatomic, assign) NSInteger selcPayWayIdx;
@property (strong, nonatomic) NSArray <PayWayV3PayTypeItem *> *paytypeList;  //支付方式
@property (nonatomic, strong) OnlineBanksModel *curOnliBankModel;
@property (strong, nonatomic) AmountListModel *curAmountModel;

@property (nonatomic, strong) CNTwoStatusBtn *btnSubmit;
@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) HYRechargeCNYEditView *editView;
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
    _launchDate = [NSDate date];
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    _selcPayWayIdx = 0;
    _launchDate = [NSDate date];
    
    LYEmptyView *empView = [LYEmptyView emptyActionViewWithImage:[UIImage imageNamed:@"kongduixiang"] titleStr:@"" detailStr:@"暂无充值方式提供" btnTitleStr:@"刷新试试" btnClickBlock:^{
        [self queryCNYPayways];
    }];
    empView.actionBtnBackGroundColor = kHexColor(0x2B2B45);
    empView.actionBtnCornerRadius = 10;
    empView.actionBtnTitleColor = [UIColor lightGrayColor];
    self.view.ly_emptyView = empView;
    
    [self setupSubmitBtn];
    [self queryCNYPayways];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_hasRecord) {
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:self->_launchDate] * 1000;
        NSLog(@" ======> 进CNY支付 耗时：%f毫秒", duration);
        NSString *timeString = [NSString stringWithFormat:@"%f", [self->_launchDate timeIntervalSince1970]];
        [IN3SAnalytics enterPageWithName:@"PaymentPageLoad" responseTime:duration timestamp:timeString];
        
        [(HYTabBarViewController *)[NNControllerHelper currentTabBarController] showSuspendBall];
    }
}

- (void)setupMainEditView {
    [self.scrollContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
//        make.height.mas_equalTo(kScreenHeight-kNavPlusStaBarHeight-48-24-kSafeAreaHeight);
        make.bottom.equalTo(self.btnSubmit.mas_top).offset(-30);
    }];
    
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainer).offset(15);
        make.top.equalTo(self.scrollContainer).offset(15);
        make.height.mas_equalTo(510).priority(MASLayoutPriorityDefaultLow);
        make.width.equalTo(self.scrollContainer.mas_width).offset(-30);
    }];
    
    [self.editView setupPayTypeItem:self.paytypeList[_selcPayWayIdx]
                          bankModel:self.curOnliBankModel
                        amountModel:self.curAmountModel];

}

- (void)setupSubmitBtn {
    CNTwoStatusBtn *subBtn = [[CNTwoStatusBtn alloc] init];
    [subBtn setTitle:@"提交" forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(submitRechargeRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subBtn];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-60);
        make.height.mas_equalTo(48);
    }];
    self.btnSubmit = subBtn;
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


#pragma mark - REQUEST

- (void)queryCNYPayways {
    [CNRechargeRequest queryPayWaysV3Handler:^(id responseObj, NSString *errorMsg) {
        if (!KIsEmptyString(errorMsg)) {
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
            
            [self.view ly_hideEmptyView];
        } else {
            [self.view ly_showEmptyView];
        }
        
    }];
}

- (void)refreshQueryData {
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
        WEAKSELF_DEFINE
        [self.view addSubview:[[HYWithdrawComfirmView alloc] initRealNameSubmitBlock:^(NSString * _Nonnull realName) {
            STRONGSELF_DEFINE
            [strongSelf bindRealName:realName];
        }]];
        return;
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
                        [CNHUB showSuccess:@"请在外部浏览器查看"];
                        // 支付等待
                        HYWithdrawComfirmView *view = [[HYWithdrawComfirmView alloc] initWithAmountModel:nil sumbitBlock:nil];
                        [self.view addSubview:view];
                        [view showRechargeWaiting];
                    }];
                } else {
                    [CNHUB showError:@"充值渠道链接错误"];
                }
            }
        }];
    
    } else {
        // BQ转账
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
}

- (void)bindRealName:(NSString *)realName {
    [CNUserCenterRequest modifyUserRealName:realName gender:nil birth:nil avatar:nil onlineMessenger2:nil email:nil handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [CNHUB showSuccess:@"实名认证成功"];
        }
    }];
}


@end
