//
//  BYDepositUsdtVC.m
//  HYNewNest
//
//  Created by zaky on 6/21/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYDepositUsdtVC.h"
#import <IN3SAnalytics/CNTimeLog.h>
#import "CNRechargeRequest.h"
#import "HYRechargeHelper.h"
#import "ChargeManualMessgeView.h"
#import "CNTwoStatusBtn.h"
#import "BYDepositUsdtEditorView.h"
#import "UILabel+Gradient.h"
#import "ChargeManualMessgeView.h"
#import "CNTradeRecodeVC.h"
#import "HYDownloadLinkView.h"

@interface BYDepositUsdtVC () <BYDepositUsdtEditorDelegate>
@property (weak, nonatomic) IBOutlet UIButton *xjkBtn;
@property (weak, nonatomic) IBOutlet UIView *qtqbBg;
@property (weak, nonatomic) IBOutlet UIView *xjkBg;
@property (weak, nonatomic) IBOutlet UILabel *xjk;
@property (weak, nonatomic) IBOutlet UILabel *qtqb;
@property (weak, nonatomic) IBOutlet BYDepositUsdtEditorView *editorView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *depoBtn;
@property (strong,nonatomic) HYDownloadLinkView *linkView;

@property (assign,nonatomic) NSInteger selIdx; //!<选中行
@property (nonatomic, strong) NSArray<DepositsBankModel *> *depositModels;
@property (nonatomic, strong) OnlineBanksModel *curOnliBankModel;
@end

@implementation BYDepositUsdtVC

- (HYDownloadLinkView *)linkView {
    if (!_linkView) {
        HYDownloadLinkView *linkView = [[HYDownloadLinkView alloc] initWithFrame:CGRectMake(90, self.editorView.bottom, 200, 30) normalText:@"没有小金库？" tapableText:@"去下载" tapColor:kHexColor(0x11B5DD) hasUnderLine:YES urlValue:nil];
        linkView.tapBlock = ^{
            NSURL *url = [NSURL URLWithString:kDownload_XJK_Address];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
                }];
            }
        };
        _linkView = linkView;
    }
    return _linkView;
}


#pragma mark - VIEW LIFE CYCLE
- (instancetype)init {
    _launchDate = [NSDate date];
    [CNTimeLog startRecordTime:CNEventPayLaunch];
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充币";
    [self addNaviRightItemWithImageName:@"kf"];
    
    _selIdx = 0;
    _editorView.delegate = self;
    _depoBtn.enabled = NO;
    
    [_xjk setupGradientColorDirection:BYLblGrdtColorDirectionLeftRight From:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
    [_qtqb setupGradientColorDirection:BYLblGrdtColorDirectionLeftRight From:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE)];
    
    [self queryDepositBankPayWays];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_hasRecord) {
        [CNTimeLog endRecordTime:CNEventPayLaunch];
        _hasRecord = YES;
    }
    [self.view addSubview:self.linkView];
}

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC];
}


#pragma mark - IBAction
- (IBAction)didTapTopDepositWayBtn:(UIButton *)sender {
    self.selIdx = sender.tag;
    if (sender.tag == 0) {
        _qtqbBg.backgroundColor = kHexColor(0x1C1C36);
        _xjkBg.backgroundColor = kHexColor(0x272749);
        _linkView.hidden = NO;
    } else {
        _qtqbBg.backgroundColor = kHexColor(0x272749);
        _xjkBg.backgroundColor = kHexColor(0x1C1C36);
        _linkView.hidden = YES;
    }
}

- (void)setSelIdx:(NSInteger)selIdx {
    _selIdx = selIdx;
    _editorView.deposModel = self.depositModels[_selIdx];
}


#pragma mark - BYDepositUsdtEditorDelegate
/**
 选择了协议
 */
- (void)didSelectOneProtocol:(NSString *)selectedProtocol {

    DepositsBankModel *model = self.depositModels[_selIdx];
    [CNRechargeRequest queryOnlineBanksPayType:model.payType
                                  usdtProtocol:selectedProtocol
                                       handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            OnlineBanksModel *oModel = [OnlineBanksModel cn_parse:responseObj];
            self.curOnliBankModel = oModel;
        }
    }];
}

- (void)depositAmountIsRight:(BOOL)isRight {
    self.depoBtn.enabled = isRight;
}


#pragma mark - REQUEST
//- (void)getPayAmountShortCuts {
//    [CNRechargeRequest getShortCutsHandler:^(id responseObj, NSString *errorMsg) {
//        if (!errorMsg && [responseObj isKindOfClass:[NSArray class]]) {
//            NSDictionary *dict = responseObj[0];
//            self->amount_list = dict[@"amount_list"];
//            self->h5_root = dict[@"h5_root"];
//            self.btmTitleLb.text = dict[@"title"];

//            NSString *promo = dict[@"promo_info"]; // 顶部广告图
//            self.topBannerDict = [promo jk_dictionaryValue];
//            NSString *topUrl = [self->h5_root stringByAppendingString:self.topBannerDict[@"h5_img"]];
//            [self.topBanner sd_setImageWithURL:[NSURL URLWithString:topUrl] placeholderImage:[UIImage imageNamed:@"gg"]];
//
//            NSString *teaching = dict[@"teaching"]; // 底部轮播图
//            self.btmBannerDict = [teaching jk_dictionaryValue];
//            [self setupBtmBanners];
//        }
//    }];
//}

/**
USDT支付渠道
*/
- (void)queryDepositBankPayWays {
    [CNRechargeRequest queryUSDTPayWalletsHandler:^(id responseObj, NSString *errorMsg) {
        
        NSArray *depositModels = [DepositsBankModel cn_parse:responseObj];
        
        __block NSMutableArray *models = @[].mutableCopy;
        __block NSInteger xjkIdx = 0;
        __block NSInteger otherWalletIdx = 0;
        [depositModels enumerateObjectsUsingBlock:^(DepositsBankModel * _Nonnull bank, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([bank.bankname caseInsensitiveCompare:@"dcbox"] == NSOrderedSame) {
                [models addObject:bank];
                xjkIdx = models.count-1;
            }
            if ([HYRechargeHelper isUSDTOtherBankModel:bank]) {
                [models addObject:bank];
                otherWalletIdx = models.count-1;
            }
        }];
        // 将小金库排到第一位
        if (xjkIdx != 0) {
            [models exchangeObjectAtIndex:0 withObjectAtIndex:xjkIdx];
        }
        
        self.depositModels = models;
        [self didTapTopDepositWayBtn:self->_xjkBtn];
    }];
}

/**
 提交充值
 */
- (IBAction)startDepositAction:(id)sender {
    DepositsBankModel *model = self.depositModels[_selIdx];
    [CNRechargeRequest submitOnlinePayOrderV2Amount:self.editorView.rechargeAmount
                                           currency:model.currency
                                       usdtProtocol:self.editorView.selectedProtocol
                                            payType:model.payType
                                            handler:^(id responseObj, NSString *errorMsg) {
        
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            ChargeManualMessgeView *view;
            if ([HYRechargeHelper isUSDTOtherBankModel:model]) {
                view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"address"] amount:self.editorView.rechargeAmount retelling:nil type:ChargeMsgTypeOTHERS];
            } else {
                view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"address"] amount:self.editorView.rechargeAmount retelling:nil type:ChargeMsgTypeDCBOX];
            }
            view.clickBlock = ^(BOOL isSure) {
                [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
            };
            [kKeywindow addSubview:view];
        }
    }];
}



@end
