//
//  HYRechargeViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYRechargeViewController.h"
#import "HYRechargeEditView.h"
#import "CNTwoStatusBtn.h"
#import "CNRechargeRequest.h"
#import "HYRechargePayWayController.h"
#import "HYRechargeHelper.h"
#import "ChargeManualMessgeView.h"
#import "CNTradeRecodeVC.h"
#import "HYTabBarViewController.h"
#import "LYEmptyView.h"
#import "UIView+Empty.h"
#import "IN3SAnalytics.h"

@interface HYRechargeViewController () <HYRechargeEditViewDelegate>
@property (nonatomic, strong) UILabel *lblTip;
@property (nonatomic, strong) UIImageView *imgvBanner;
@property (nonatomic, strong) CNTwoStatusBtn *btnSubmit;

@property (nonatomic, assign) NSInteger selcPayWayIdx;
@property (nonatomic, strong) OnlineBanksModel *curOnliBankModel;
@property (nonatomic, strong) NSArray<DepositsBankModel *> *depositModels;
@property (nonatomic, strong) HYRechargeEditView *editView;
@end

@implementation HYRechargeViewController


#pragma mark - VIEW LIFE CYCLE

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充币";
    
    _launchDate = [NSDate date];
    
    [self setupViews];
    [self queryDepositBankPayWays];
    // !!!:  没数据 先隐藏顶部tipsView
    [self didClickCloseTip];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [(HYTabBarViewController *)[NNControllerHelper currentTabBarController] showSuspendBall];
}

- (void)setSelcPayWayIdx:(NSInteger)selcPayWayIdx {
    if (!_depositModels || _depositModels.count == 0) {
        return;
    }
    _selcPayWayIdx = selcPayWayIdx;
    [self.editView setupDepositModel:self.depositModels[selcPayWayIdx]];
    // 线上支付要请求一个onlinebank
    [self queryOnlineBankAmount];
}


#pragma mark - VIEWS

- (void)setupViews {
    [self setupTopLable];
    [self setupBanner];
    [self setupMainEditView];
    [self setupSubmitBtn];

    LYEmptyView *empView = [LYEmptyView emptyActionViewWithImage:[UIImage imageNamed:@"kongduixiang"] titleStr:@"" detailStr:@"暂无充币方式提供" btnTitleStr:@"刷新试试" btnClickBlock:^{
        [self queryDepositBankPayWays];
    }];
    empView.actionBtnBackGroundColor = kHexColor(0x2B2B45);
    empView.actionBtnCornerRadius = 10;
    empView.actionBtnTitleColor = [UIColor lightGrayColor];
    self.view.ly_emptyView = empView;
    
}

-(void)setupTopLable {
    UILabel *lblTip = [[UILabel alloc] init];
    lblTip.backgroundColor = kHexColor(0x212137);
    lblTip.text = @"您可通过多种数字货币，以实时汇率兑换平台USDT额度";
    lblTip.font = [UIFont fontPFR13];
    lblTip.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
    lblTip.textAlignment = NSTextAlignmentCenter;
    lblTip.userInteractionEnabled = YES;
    [self.view addSubview:lblTip];
    [lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    self.lblTip = lblTip;
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnClose setImage:[UIImage imageNamed:@"l_close"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(didClickCloseTip) forControlEvents:UIControlEventTouchUpInside];
    [lblTip addSubview:btnClose];
    [self.lblTip addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblTip);
        make.topMargin.mas_equalTo(7);
        make.rightMargin.mas_equalTo(-5);
        make.height.width.mas_equalTo(27);
    }];
    
}

- (void)setupBanner {
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"banner-2"];
    imgv.userInteractionEnabled = YES;
    imgv.layer.cornerRadius = 10;
    imgv.layer.masksToBounds = YES;
    [self.view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.lblTip.mas_bottom).offset(20);
        make.height.equalTo(imgv.mas_width).multipliedBy(115/345.0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
    [imgv addGestureRecognizer:tap];
    self.imgvBanner = imgv;
    
    UIButton *knowBtn = [[UIButton alloc] init];
    [knowBtn setTitle:@"立即了解" forState:UIControlStateNormal];
    [knowBtn setTitleColor:kHexColor(0x10B4DD) forState:UIControlStateNormal];
    knowBtn.titleLabel.font = [UIFont fontPFR13];
    [imgv addSubview:knowBtn];
    knowBtn.userInteractionEnabled = NO;
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgv).offset(-25);
        make.bottom.equalTo(imgv).offset(-20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(24);
    }];
    knowBtn.layer.cornerRadius = 12;
    knowBtn.layer.borderColor = kHexColor(0x19CECE).CGColor;
    knowBtn.layer.borderWidth = 1;
    knowBtn.layer.masksToBounds = YES;
}

- (void)tapBanner:(UITouch *)touch {
    ///pub_site/
    [NNPageRouter jump2HTMLWithStrURL:@"/tutorialReference" title:@"请稍等.." needPubSite:YES];
}

- (void)setupMainEditView {
    HYRechargeEditView *editView = [HYRechargeEditView new];
    editView.delegate = self;
    self.editView = editView;
    [self.view addSubview:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.imgvBanner.mas_bottom).offset(24);
        make.height.mas_equalTo(249); //changeable
    }];
}

- (void)setupSubmitBtn {
    CNTwoStatusBtn *subBtn = [[CNTwoStatusBtn alloc] init];
    [subBtn setTitle:@"提交订单+获取地址" forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(submitUSDTRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subBtn];
    [subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-24-kSafeAreaHeight);
        make.height.mas_equalTo(48);
    }];
    self.btnSubmit = subBtn;
}


#pragma mark - ACTION

- (void)didClickCloseTip {
    self.lblTip.hidden = YES;
    [self.lblTip mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}


#pragma mark - HYRechargeEditViewDelegate
- (void)didTapSwitchBtnModel:(DepositsBankModel *)depositModel {
    HYRechargePayWayController *vc = [[HYRechargePayWayController alloc] initWithDepositModels:self.depositModels
                                                                                       selcIdx:self.selcPayWayIdx];
    vc.navPopupBlock = ^(id obj) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            self.selcPayWayIdx = [(NSNumber *)obj integerValue];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didChangeIsAmountRight:(BOOL)isAmountRight {
    self.btnSubmit.enabled = isAmountRight;
}


#pragma mark - REQUEST

/**
USDT支付渠道
*/
- (void)queryDepositBankPayWays {
    [CNRechargeRequest queryUSDTPayWalletsHandler:^(id responseObj, NSString *errorMsg) {
        NSArray *depositModels = [DepositsBankModel cn_parse:responseObj];
        NSMutableArray *models = @[].mutableCopy;
        for (DepositsBankModel *bank in depositModels) {
            if (([bank.bankname isEqualToString:@"dcbox"] || [HYRechargeHelper isUSDTOtherBankModel:bank])) {
                [models addObject:bank];
            }
        }
        self.depositModels = models;
        self.selcPayWayIdx = 0;
        
        if (models.count == 0) {
            self.editView.hidden = YES;
            [self.view ly_showEmptyView];
        } else {
            self.editView.hidden = NO;
            [self.view ly_hideEmptyView];
            [self queryOnlineBankAmount];
        }
        
        // 耗时间隔毫秒
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:self->_launchDate] * 1000;
        NSLog(@" ======> 进USDT支付 耗时：%f毫秒", duration);
        NSString *timeString = [NSString stringWithFormat:@"%f", [self->_launchDate timeIntervalSince1970]];
        [IN3SAnalytics enterPageWithName:@"PaymentPageLoad" responseTime:duration timestamp:timeString];
    }];
}

/**
在线类支付 需要
*/
- (void)queryOnlineBankAmount {
    DepositsBankModel *model = self.depositModels[_selcPayWayIdx];
    [CNRechargeRequest queryOnlineBanksPayType:model.payType
                                  usdtProtocol:self.editView.selectedProtocol
                                       handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            OnlineBanksModel *oModel = [OnlineBanksModel cn_parse:responseObj];
            self.curOnliBankModel = oModel;
        }
    }];
}

- (void)submitUSDTRequest {
    DepositsBankModel *model = self.depositModels[_selcPayWayIdx];
    
    if ([HYRechargeHelper isUSDTOtherBankModel:model]) {
        [CNRechargeRequest submitOnlinePayOrderV2Amount:self.editView.rechargeAmount
                                               currency:model.currency
                                           usdtProtocol:self.editView.selectedProtocol
                                                payType:model.payType
                                                handler:^(id responseObj, NSString *errorMsg) {
            
            if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
                ChargeManualMessgeView *view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"address"] retelling:nil type:ChargeMsgTypeOTHERS];
                view.clickBlock = ^(BOOL isSure) {
                    [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
                };
                [kKeywindow addSubview:view];
            }
        }];
        
    } else {
        [CNRechargeRequest submitOnlinePayOrderAmount:self.editView.rechargeAmount
                                             currency:model.currency
                                         usdtProtocol:self.editView.selectedProtocol
                                              payType:model.payType
                                                payid:self.curOnliBankModel.payid
                                           showQRCode:1
                                              handler:^(id responseObj, NSString *errorMsg) {
            
            if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
                ChargeManualMessgeView *view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"payUrl"] retelling:nil type:[HYRechargeHelper isUSDTOtherBankModel:model]?ChargeMsgTypeOTHERS:ChargeMsgTypeDCBOX];
                view.clickBlock = ^(BOOL isSure) {
                    [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
                };
                [kKeywindow addSubview:view];
            }
        }];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
