//
//  BYRechargeUsdtVC.m
//  HYNewNest
//
//  Created by zaky on 4/21/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYRechargeUsdtVC.h"

#import "HYRechargeHelper.h"
#import "IN3SAnalytics.h"
#import "CNRechargeRequest.h"

#import "SDCycleScrollView.h"
#import "BYRechargeUSDTTopView.h" //这是cell
#import "LYEmptyView.h"
#import "UIView+Empty.h"

static NSString * const cellName = @"BYRechargeUSDTTopView";

@interface BYRechargeUsdtVC () <UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *topBanner;
@property (weak, nonatomic) IBOutlet UIView *btmBannerBg;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *btmBanner;
@property (weak, nonatomic) IBOutlet UIPageControl *btmBannerControl;

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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"充币";
    _selIdx = -1;
    [self addNaviRightItemWithImageName:@"kf"];
    
    _tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);// 顶部间隙
    [_tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
    _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"kongduixiang" titleStr:@"暂无充值渠道" detailStr:@""];
    
    _topBanner.localizationImageNamesGroup = @[@"gg"];
    _topBanner.delegate = self;
    
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


#pragma mark - REQUEST

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
    }];
}

/**
在线类支付 需要
*/
- (void)queryOnlineBankAmount {
    // !!!: @"ERC20"写死的 这里需要获取当前选中的默认协议
    if (_selIdx < 1) { //0是直充
        return;
    }
    DepositsBankModel *model = self.depositModels[_selIdx-1];
    [CNRechargeRequest queryOnlineBanksPayType:model.payType
                                  usdtProtocol:@"ERC20"
                                       handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            OnlineBanksModel *oModel = [OnlineBanksModel cn_parse:responseObj];
            self.curOnliBankModel = oModel;
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
            self.tableViewTop2BgViewCons.priority = UILayoutPriorityDefaultLow;

            self.tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);//150
        }];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self queryOnlineBankAmount];
        });
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
    [self.tableView reloadData];
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (cycleScrollView == _topBanner) {
        MyLog(@"点击了顶部");
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
    cell.lineIdx = indexPath.row;
    if (indexPath.row == 0) { //人民币直充
        cell.model = nil;
    } else {
        DepositsBankModel *m = self.depositModels[indexPath.row-1];
        cell.model = m;
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
  
