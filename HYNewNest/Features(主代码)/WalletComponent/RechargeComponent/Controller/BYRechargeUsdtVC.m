//
//  BYRechargeUsdtVC.m
//  HYNewNest
//
//  Created by zaky on 4/21/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYRechargeUsdtVC.h"
#import "CNTradeRecodeVC.h"

#import "HYRechargeHelper.h"
#import "IN3SAnalytics.h"
#import "CNRechargeRequest.h"
#import <UIImageView+WebCache.h>

#import "SDCycleScrollView.h"
#import "BYRechargeUSDTTopView.h" //这是cell
#import "LYEmptyView.h"
#import "UIView+Empty.h"
#import "ChargeManualMessgeView.h"

static NSString * const cellName = @"BYRechargeUSDTTopView";

@interface BYRechargeUsdtVC () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, BYRechargeUSDTViewDelegate>
{
    NSString *amount_list;
}
@property (weak, nonatomic) IBOutlet UIImageView *topBanner;
@property (weak, nonatomic) IBOutlet UIView *btmBannerBg;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *btmBanner;
@property (weak, nonatomic) IBOutlet UIPageControl *btmBannerControl;
/**{
 "amount_list" = "20;100;200;500;1000;2000";
 id = 1738;
 "promo_info" = "{ \"h5_img\": \"cbymtch5.png\",\"pc_img\": \"cbymtcpc.png\",\"promo_url\": \"/pub_site/coin\",  \"root\":\"https://83e6dyfront.58baili.com/cdn/83e6dyP/externals/img/_wms/banner-biyou/\"}";
 teaching = "{ \"h5_img\": [\"cbymtch5.png\",\"cbymtch5.png\",\"cbymtch5.png\"], \"pc_img\": [\"cbymtch5.png\",\"cbymtch5.png\",\"cbymtch5.png\"], \"root\": \"https://83e6dyfront.58baili.com/cdn/83e6dyP/externals/img/_wms/banner-biyou/\" }";
}*/
@property (strong,nonatomic) NSDictionary *topBannerDict; //!<顶部banner数据
@property (strong,nonatomic) NSDictionary *btmBannerDict; //!<底部轮播数据

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBtm2BannerCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBtm2SafeAreaCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop2BannerInsetCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop2BgViewCons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign,nonatomic) NSInteger selIdx; //!<选中行 未选中行时设置为-1
@property (nonatomic, strong) OnlineBanksModel *curOnliBankModel;
@property (nonatomic, strong) NSArray<DepositsBankModel *> *depositModels;

@end

@implementation BYRechargeUsdtVC

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
    _selIdx = -1;
    [self addNaviRightItemWithImageName:@"kf"];
    
    _tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0);// 顶部间隙
    [_tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
    _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"kongduixiang" titleStr:@"暂无充值渠道" detailStr:@""];
    
    _btmBanner.delegate = self;
    
    [self queryDepositBankPayWays];
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

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC:CNLive800TypeDeposit];
}

- (void)setupBtmBanners {
//    self.btmBanner.layer.cornerRadius = 10;
//    self.btmBanner.layer.masksToBounds = YES;
    self.btmBanner.autoScrollTimeInterval = 3;
    self.btmBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.btmBanner.pageControlBottomOffset = AD(120)+5;
    self.btmBanner.pageControlRightOffset = -50;
    
    NSString *root = self.btmBannerDict[@"root"];
    NSArray *h5_imgs = self.btmBannerDict[@"h5_img"];
    NSMutableArray *h5_imgs_full = @[].mutableCopy;
    [h5_imgs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *full = [root stringByAppendingString:obj];
        [h5_imgs_full addObject:full];
    }];
    [self.btmBanner setImageURLStringsGroup:h5_imgs_full.copy];
}

#pragma mark - REQUEST
- (void)getPayAmountShortCuts {
    [CNRechargeRequest getShortCutsHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSArray class]]) {
            NSDictionary *dict = responseObj[0];
            self->amount_list = dict[@"amount_list"]; //快捷输入
            
            NSString *promo = dict[@"promo_info"]; // 顶部广告图
            self.topBannerDict = [promo jk_dictionaryValue];
            NSString *topUrl = [self.topBannerDict[@"root"] stringByAppendingString:self.topBannerDict[@"h5_img"]];
            [self.topBanner sd_setImageWithURL:[NSURL URLWithString:topUrl]];
            
            NSString *teaching = dict[@"teaching"]; //轮播图
            self.btmBannerDict = [teaching jk_dictionaryValue];
            [self setupBtmBanners];
        }
    }];
}

/**
USDT支付渠道
*/
- (void)queryDepositBankPayWays {
    [CNRechargeRequest queryUSDTPayWalletsHandler:^(id responseObj, NSString *errorMsg) {
        NSArray *depositModels = [DepositsBankModel cn_parse:responseObj];
        NSMutableArray *models = @[].mutableCopy;
        [depositModels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(DepositsBankModel*  _Nonnull bank, NSUInteger idx, BOOL * _Nonnull stop) {
            if (([bank.bankname isEqualToString:@"dcbox"] || [HYRechargeHelper isUSDTOtherBankModel:bank])) {
                [models addObject:bank];
            }
        }];
        self.depositModels = models;
        
        if (models.count == 0) {
            [self.view ly_showEmptyView];
        } else {
            [self.view ly_hideEmptyView];
        }
        
        [self.tableView reloadData];
        [self getPayAmountShortCuts];
    }];
}

/**
在线类支付 需要
*/
//- (void)queryOnlineBankAmount {
//    if (_selIdx < 1) { //0是直充
//        return;
//    }
//    DepositsBankModel *model = self.depositModels[_selIdx-1];
//    NSArray *cells = [self.tableView visibleCells];
//    BYRechargeUSDTTopView *cell = cells[_selIdx];
//
//    [CNRechargeRequest queryOnlineBanksPayType:model.payType
//                                  usdtProtocol:cell.selectedProtocol
//                                       handler:^(id responseObj, NSString *errorMsg) {
//        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
//            OnlineBanksModel *oModel = [OnlineBanksModel cn_parse:responseObj];
//            self.curOnliBankModel = oModel;
//        }
//    }];
//}
- (void)didSelectOneProtocol:(NSString *)selectedProtocol {
    if (_selIdx < 1) { //0是直充
        return;
    }
    DepositsBankModel *model = self.depositModels[_selIdx-1];
    [CNRechargeRequest queryOnlineBanksPayType:model.payType
                                  usdtProtocol:selectedProtocol
                                       handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            OnlineBanksModel *oModel = [OnlineBanksModel cn_parse:responseObj];
            self.curOnliBankModel = oModel;
        }
    }];
}

/**
 提交充值
 */
- (void)didTapDepositBtnModel:(DepositsBankModel *)model
                       amount:(NSString *)amountStr
                     protocol:(NSString *)protocolStr {
    
    if ([HYRechargeHelper isUSDTOtherBankModel:model]) {
        [CNRechargeRequest submitOnlinePayOrderV2Amount:amountStr
                                               currency:model.currency
                                           usdtProtocol:protocolStr
                                                payType:model.payType
                                                handler:^(id responseObj, NSString *errorMsg) {
            
            if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
                ChargeManualMessgeView *view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"address"] amount:amountStr retelling:nil type:ChargeMsgTypeOTHERS];
                view.clickBlock = ^(BOOL isSure) {
                    [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
                };
                [kKeywindow addSubview:view];
            }
        }];
        
    } else {
        [CNRechargeRequest submitOnlinePayOrderAmount:amountStr
                                             currency:model.currency
                                         usdtProtocol:protocolStr
                                              payType:model.payType
                                                payid:self.curOnliBankModel.payid
                                           showQRCode:1
                                              handler:^(id responseObj, NSString *errorMsg) {
            
            if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
                ChargeManualMessgeView *view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"payUrl"] amount:amountStr retelling:nil type:[HYRechargeHelper isUSDTOtherBankModel:model]?ChargeMsgTypeOTHERS:ChargeMsgTypeDCBOX];
                view.clickBlock = ^(BOOL isSure) {
                    [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
                };
                [kKeywindow addSubview:view];
            }
        }];
    }
}


#pragma mark - SETTER
- (void)setSelIdx:(NSInteger)selIdx {
    _selIdx = selIdx;
    
    if (selIdx == -1) {
        [UIView animateWithDuration:0.35 animations:^{
            self.topBanner.alpha = 1.0;
            self.btmBannerBg.alpha = 1.0;
            self.tableViewBtm2SafeAreaCons.priority = UILayoutPriorityDefaultLow;
            self.tableViewTop2BgViewCons.priority = UILayoutPriorityDefaultLow;

            self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0);//150
        }];
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            self.topBanner.alpha = 0.0;
            self.btmBannerBg.alpha = 0.0;
            self.tableViewBtm2SafeAreaCons.priority = UILayoutPriorityRequired;
            self.tableViewTop2BgViewCons.priority = UILayoutPriorityRequired;

            self.tableView.contentInset = UIEdgeInsetsZero;
        }];
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:(selIdx>0)?selIdx:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.tableView reloadData];
}


#pragma mark - Action
- (IBAction)didTapTopBannerImage:(id)sender {
    if (_topBannerDict) {
        NSString *promo_url = _topBannerDict[@"promo_url"];
        [NNPageRouter jump2HTMLWithStrURL:promo_url title:@"充币活动" needPubSite:NO];
    }
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    if (_btmBannerDict) {
//        NSString *promo_url = _btmBannerDict[@"promo_url"];
        MyLog(@"点击了底部");
    }
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.depositModels.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selIdx && _selIdx != 0) {
        return 448;
    } else {
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYRechargeUSDTTopView *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    // action
    WEAKSELF_DEFINE
    cell.didTapTopBgActionBlock = ^(NSInteger lineIdx) {
        STRONGSELF_DEFINE
        if (strongSelf.selIdx == lineIdx) { // 点击已选中的cell
            strongSelf.selIdx = -1;
        } else { // 点击未选中的cell
            strongSelf.selIdx = lineIdx;
            if (lineIdx == 0) {
                [NNPageRouter jump2BuyECoin];
            }
        }
    };
    
    // 赋值
    cell.delegate = self;
    cell.lineIdx = indexPath.row;
    if (indexPath.row == 0) { //人民币直充
        cell.deposModel = nil;
    } else {
        DepositsBankModel *m = self.depositModels[indexPath.row-1];
        cell.deposModel = m;
    }
    
    // 状态
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_selIdx == indexPath.row) {
            [cell setSelected:YES animated:YES];
        } else {
            [cell setSelected:NO animated:YES];
        }
    });
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//    if (_selIdx == indexPath.row) { // 点击选中的cell
//        self.selIdx = -1;
//    } else { // 点击未选中的cell
//        self.selIdx = indexPath.row;
//        if (lineIdx == 0) {
//            [NNPageRouter jump2BuyECoin];
//        }
//    }
//
//}


@end
  
