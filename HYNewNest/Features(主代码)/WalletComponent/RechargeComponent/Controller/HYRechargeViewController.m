//
//  HYRechargeViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYRechargeViewController.h"
#import "HYNewCTZNViewController.h"
#import "HYRechargePayWayController.h"
#import "CNTradeRecodeVC.h"

#import "BYRechargeUSDTTopView.h"
#import "HYRechargeEditView.h"
#import "CNTwoStatusBtn.h"
#import "ChargeManualMessgeView.h"
#import "LYEmptyView.h"
#import "UIView+Empty.h"

#import "HYRechargeHelper.h"
#import "IN3SAnalytics.h"
#import "CNRechargeRequest.h"

@interface HYRechargeViewController () <HYRechargeEditViewDelegate>
@property (nonatomic, strong) UILabel *lblTip;
@property (nonatomic, strong) UIImageView *imgvBanner;
@property (nonatomic, strong) CNTwoStatusBtn *btnSubmit;
@property (strong,nonatomic) BYRechargeUSDTTopView *topView;

@property (nonatomic, assign) NSInteger selcPayWayIdx;
@property (nonatomic, strong) OnlineBanksModel *curOnliBankModel;
@property (nonatomic, strong) NSArray<DepositsBankModel *> *depositModels;
@property (nonatomic, strong) HYRechargeEditView *editView;
@end

@implementation HYRechargeViewController


#pragma mark - VIEW LIFE CYCLE

- (instancetype)init {
    _launchDate = [NSDate date];
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充币";
    [self addNaviRightItemWithImageName:@"service"];

    [self setupViews];
    [self queryDepositBankPayWays];
    // !!!:  没数据 先隐藏顶部tipsView
    [self didClickCloseTip];
}

- (void)rightItemAction {
    [NNPageRouter jump2Live800Type:CNLive800TypeDeposit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_hasRecord) {
        NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:self->_launchDate] * 1000;
        NSLog(@" ======> 进USDT支付 耗时：%f毫秒", duration);
        NSString *timeString = [NSString stringWithFormat:@"%f", [self->_launchDate timeIntervalSince1970]];
        [IN3SAnalytics enterPageWithName:@"PaymentPageLoad" responseTime:duration timestamp:timeString];
    }
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
    [self setupTopView];
    [self setupBanner];
    [self setupMainEditView];
    [self setupSubmitBtn];
    [self setupEmptyView];
}

- (void)setupEmptyView {
    LYEmptyView *empView = [LYEmptyView emptyActionViewWithImage:[UIImage imageNamed:@"kongduixiang"] titleStr:@"" detailStr:@"暂无充币方式提供" btnTitleStr:@"刷新试试" btnClickBlock:^{
        [self queryDepositBankPayWays];
    }];
    empView.actionBtnBackGroundColor = kHexColor(0x2B2B45);
    empView.actionBtnCornerRadius = 10;
    empView.actionBtnTitleColor = [UIColor lightGrayColor];
    self.view.ly_emptyView = empView;
}

- (void)setupTopView {
    BYRechargeUSDTTopView *view = [BYRechargeUSDTTopView new];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(115);
        make.top.equalTo(self.view).offset(16);
    }];
    self.topView = view;
    [self.topView addCornerAndShadow];
}

- (void)setupBanner {
    UIImageView *imgv = [[UIImageView alloc] init];
    imgv.image = [UIImage imageNamed:@"ctzn-banner"];
    imgv.userInteractionEnabled = YES;
    imgv.layer.cornerRadius = 10;
    imgv.layer.masksToBounds = YES;
    [self.view addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(imgv.mas_width).multipliedBy(115/345.0);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
    [imgv addGestureRecognizer:tap];
    self.imgvBanner = imgv;
    
    UILabel *titLb = [UILabel new];
    titLb.text = @"充提指南";
    titLb.font = [UIFont fontPFSB18];
    titLb.textColor = kHexColorAlpha(0xFFFFFF, 0.9);
    [imgv addSubview:titLb];
    [titLb sizeToFit];
    [titLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgv.mas_right).offset(-59);
        make.top.equalTo(imgv).offset(34);
    }];
    
    UILabel *detalLb = [UILabel new];
    detalLb.text = @"安全简单，了解一下";
    detalLb.font = [UIFont fontPFSB12];
    detalLb.textColor = kHexColorAlpha(0xFFFFFF, 0.7);
    [imgv addSubview:detalLb];
    [detalLb sizeToFit];
    [detalLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titLb).offset(-10);
        make.top.equalTo(titLb.mas_bottom).offset(7);
    }];
    
    UIImageView *imgIcon = [[UIImageView alloc] init];
    UIImage *img = [UIImage imageNamed:@"right1"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgIcon.image = img;
    imgIcon.tintColor = kHexColorAlpha(0xFFFFFF, 0.8);
    [imgv addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(detalLb);
        make.left.equalTo(detalLb.mas_right).offset(4);
        make.height.width.mas_equalTo(18);
    }];
}

- (void)setupMainEditView {
    HYRechargeEditView *editView = [HYRechargeEditView new];
    editView.delegate = self;
    self.editView = editView;
    [self.view addSubview:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.topView.mas_bottom).offset(24);
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
        make.top.equalTo(self.editView.mas_bottom).offset(50);
        make.height.mas_equalTo(48);
    }];
    self.btnSubmit = subBtn;
}


#pragma mark - ACTION

- (void)tapBanner:(UITouch *)touch {
//    [NNPageRouter jump2HTMLWithStrURL:@"/tutorialReference" title:@"请稍等.." needPubSite:YES];
    [self presentViewController:[HYNewCTZNViewController new] animated:YES completion:^{
    }];
}

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
