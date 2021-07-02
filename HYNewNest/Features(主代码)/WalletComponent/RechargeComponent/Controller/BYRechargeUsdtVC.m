//
//  BYRechargeUsdtVC.m
//  HYNewNest
//
//  Created by zaky on 4/21/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYRechargeUsdtVC.h"
#import "CNTradeRecodeVC.h"
#import "HYNewCTZNViewController.h"

#import "HYRechargeHelper.h"
#import "CNRechargeRequest.h"
#import <UIImageView+WebCache.h>

#import "SDCycleScrollView.h"
#import "BYRechargeUSDTTopView.h" //这是cell
#import "LYEmptyView.h"
#import "UIView+Empty.h"
#import "ChargeManualMessgeView.h"
#import <IN3SAnalytics/CNTimeLog.h>

static NSString * const cellName = @"BYRechargeUSDTTopView";

@interface BYRechargeUsdtVC () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, BYRechargeUSDTViewDelegate>
{
    NSString *amount_list; //快捷输入金额
    NSString *h5_root; //图片根地址
}
@property (weak, nonatomic) IBOutlet UIImageView *topBanner;
@property (weak, nonatomic) IBOutlet UIView *btmBannerBg;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *btmBanner;
@property (weak, nonatomic) IBOutlet UILabel *btmTitleLb;

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
    [CNTimeLog startRecordTime:CNEventPayLaunch];
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充币";
    _selIdx = -1;
    [self addNaviRightItemWithImageName:@"kf"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"l_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//        backItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.leftBarButtonItem = backItem;
    
    if (kScreenHeight < 736) {
        _tableViewTop2BannerInsetCons.constant = -50;
    }
    _tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0);// 顶部间隙
    [_tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
    _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"kongduixiang" titleStr:@"暂无充值渠道" detailStr:@""];
    
    [self queryDepositBankPayWays];
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

- (void)setupBtmBanners {
//    self.btmBanner.placeholderImage = [UIImage imageNamed:@"3"];
    self.btmBanner.autoScrollTimeInterval = 3;
    self.btmBanner.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.btmBanner.pageControlBottomOffset = AD(120)+5;
    if (kScreenHeight < 736) {
        self.btmBanner.pageControlRightOffset = -10;
    } else {
        self.btmBanner.pageControlRightOffset = -45;
    }
    self.btmBanner.delegate = self;
    
    NSString *root = self->h5_root;
    NSArray *h5_imgs = self.btmBannerDict[@"h5_img"];
    NSMutableArray *h5_imgs_full = @[].mutableCopy;
    [h5_imgs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *full = [root stringByAppendingString:obj];
        [h5_imgs_full addObject:full];
    }];
    [self.btmBanner setImageURLStringsGroup:h5_imgs_full.copy];
}

- (void)back {
    if (self.selIdx == -1) {
        [self.navigationController popViewControllerAnimated:true];
    }
    else {
        self.selIdx = -1;
    }
}

#pragma mark - REQUEST
- (void)getPayAmountShortCuts {
    [CNRechargeRequest getShortCutsHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSArray class]]) {
            NSDictionary *dict = responseObj[0];
            self->amount_list = dict[@"amount_list"];
            self->h5_root = dict[@"h5_root"];
            self.btmTitleLb.text = dict[@"title"];
            
            NSString *promo = dict[@"promo_info"]; // 顶部广告图
            self.topBannerDict = [promo jk_dictionaryValue];
            NSString *topUrl = [self->h5_root stringByAppendingString:self.topBannerDict[@"h5_img"]];
            [self.topBanner sd_setImageWithURL:[NSURL URLWithString:topUrl] placeholderImage:[UIImage imageNamed:@"gg"]];
            
            NSString *teaching = dict[@"teaching"]; // 底部轮播图
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
 选择了协议
 */
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
    
    [CNRechargeRequest submitOnlinePayOrderV2Amount:amountStr
                                           currency:model.currency
                                       usdtProtocol:protocolStr
                                            payType:model.payType
                                            handler:^(id responseObj, NSString *errorMsg) {
        
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            ChargeManualMessgeView *view;
            if ([HYRechargeHelper isUSDTOtherBankModel:model]) {
                view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"address"] amount:amountStr retelling:nil type:ChargeMsgTypeOTHERS];
            } else {
                view = [[ChargeManualMessgeView alloc] initWithAddress:responseObj[@"address"] amount:amountStr retelling:nil type:ChargeMsgTypeDCBOX];
            }
            view.clickBlock = ^(BOOL isSure) {
                [self.navigationController pushViewController:[CNTradeRecodeVC new] animated:YES];
            };
            [kKeywindow addSubview:view];
        }
    }];

}


#pragma mark - SETTER
- (void)setSelIdx:(NSInteger)selIdx {
    _selIdx = selIdx;
    
    if (selIdx == -1) {
        [UIView animateWithDuration:0.35 animations:^{
            self.topBanner.alpha = 1.0;
            self.btmBannerBg.alpha = 1.0;
            self.tableViewBtm2SafeAreaCons.priority = UILayoutPriorityDefaultLow;
            self.tableViewBtm2BannerCons.priority = UILayoutPriorityDefaultHigh;
            self.tableViewTop2BgViewCons.priority = UILayoutPriorityDefaultLow;
            self.tableViewTop2BannerInsetCons.priority = UILayoutPriorityDefaultHigh;
            self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 0, 0);//150
        }];
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            self.topBanner.alpha = 0.0;
            self.btmBannerBg.alpha = 0.0;
            self.tableViewBtm2SafeAreaCons.priority = UILayoutPriorityDefaultHigh;
            self.tableViewBtm2BannerCons.priority = UILayoutPriorityDefaultLow;
            self.tableViewTop2BgViewCons.priority = UILayoutPriorityDefaultHigh;
            self.tableViewTop2BannerInsetCons.priority = UILayoutPriorityDefaultLow;

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
        NSArray *promo_urls = _btmBannerDict[@"url"];
        NSString *url = promo_urls[index];
        
        HYNewCTZNViewController *vc = [HYNewCTZNViewController new];
        if ([url isEqualToString:@"买币"]) {
            vc.type = 0;
            [self presentViewController:vc animated:YES completion:^{}];
        } else if ([url isEqualToString:@"充币"]) {
            vc.type = 1;
            [self presentViewController:vc animated:YES completion:^{}];
        } else if ([url isEqualToString:@"提币"]) {
            vc.type = 2;
            [self presentViewController:vc animated:YES completion:^{}];
        } else if ([url isEqualToString:@"卖币"]) {
            vc.type = 3;
            [self presentViewController:vc animated:YES completion:^{}];
            
        } else if ([url containsString:@"pub_site"]) {
            [NNPageRouter jump2HTMLWithStrURL:url title:@"活动" needPubSite:NO];
            
        } else {
            NSURL *URL = [NSURL URLWithString:url];
            if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
                    [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
                }];
            }
        }
    }
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.depositModels.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selIdx && _selIdx != 0) {
        return (kScreenWidth > 375)?448:438;
    } else {
        return (kScreenWidth > 375)?120:110;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYRechargeUSDTTopView *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (self.suggestRecharge != 0) {
        cell.suggestRecharge = self.suggestRecharge;
    }
    // action
//    WEAKSELF_DEFINE
//    cell.didTapTopBgActionBlock = ^(NSInteger lineIdx) {
//        STRONGSELF_DEFINE
//        if (strongSelf.selIdx == lineIdx) { // 点击已选中的cell
//            strongSelf.selIdx = -1;
//        } else { // 点击未选中的cell
//            strongSelf.selIdx = lineIdx;
//            if (lineIdx == 0) {
//                [NNPageRouter jump2BuyECoin];
//            }
//        }
//    };
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.selIdx == indexPath.row) { // 点击已选中的cell
        self.selIdx = -1;
    } else { // 点击未选中的cell
        self.selIdx = indexPath.row;
        if (indexPath.row == 0) {
            [NNPageRouter jump2BuyECoin];
        }
    }

}


@end
  
