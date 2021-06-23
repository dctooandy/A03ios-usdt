//
//  BYWithdrawVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/6/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYTradeEntryVC.h"
#import "BYTradeTableViewCell.h"
#import "HYWithdrawViewController.h"
#import "SDCycleScrollView.h"
#import "CNWithdrawRequest.h"
#import "BYYuEBaoVC.h"
#import "BYGradientButton.h"
#import "BYTradeEntryModel.h"
#import "BYJSONHelper.h"
#import "HYCTZNPlayerViewController.h"
#import "NNPageRouter.h"
#import "HYWideOneBtnAlertView.h"
#import "BYDepositUsdtVC.h"

@interface BYTradeEntryVC () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(BYGradientButton) NSArray *playGuideButtons;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, assign) TradeEntryType type;

@property (nonatomic, strong) NSMutableArray<TradeBannerItem *> *bannerModels;
@property (nonatomic, strong) NSMutableArray<TradeEntrySetTypeItem *> *setTypeModels;
@property (nonatomic, strong) NSDictionary *tutorialsVideos;

@property (nonatomic, strong) NSString *h5Root;

@end

@implementation BYTradeEntryVC

static NSString * const kTradeEntryCell = @"BYTradeEntryCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [self fetchData];

}

- (instancetype)initWithType:(TradeEntryType)type {
    self = [super init];
    self.type = type;
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Custom Method
- (void)setupUI {
    if (self.type == TradeEntryTypeDeposit) {
        [self setTitle:@"充值"];
        BYGradientButton *rechargeButton = self.playGuideButtons[0];
        [rechargeButton setTitle:@"RMB直充教学" forState:UIControlStateNormal];
        
        BYGradientButton *buyButton = self.playGuideButtons[1];
        [buyButton setTitle:@"数字货币充值教学" forState:UIControlStateNormal];
    }
    else {
        [self setTitle:@"提现"];
        
        BYGradientButton *withdrawButton = self.playGuideButtons[0];
        [withdrawButton setTitle:@"提币教学" forState:UIControlStateNormal];
        
        BYGradientButton *sellButton = self.playGuideButtons[1];
        [sellButton setTitle:@"卖币教学" forState:UIControlStateNormal];
    }
    
    [self.tableView.tableHeaderView addSubview:self.bannerView];
    [self.tableView registerNib:[UINib nibWithNibName:@"BYTradeTableViewCell" bundle:nil]
         forCellReuseIdentifier:kTradeEntryCell];
    [self addNaviRightItemWithImageName:@"kf"];
}

- (void)setupBanner {
    NSMutableArray *h5Images = [[NSMutableArray alloc] init];
    for (TradeBannerItem *banner in self.bannerModels) {
        [h5Images addObject:[NSString stringWithFormat:@"%@%@", self.h5Root, banner.img]];
    }

    [self.bannerView setImageURLStringsGroup:h5Images];
}

- (void)playTurtorialVideosWithType:(NSString *)type {
    HYCTZNPlayerViewController *playVC = [[HYCTZNPlayerViewController alloc] init];
    if ([type isEqualToString:@"TB"]) {
        playVC.sourceUrl = [NSString stringWithFormat:@"%@%@",self.h5Root, self.tutorialsVideos[@"h5tibi"]];
        playVC.tit = @"提币教学";
    }
    else if ([type isEqualToString:@"MB"]) {
        playVC.sourceUrl = [NSString stringWithFormat:@"%@%@",self.h5Root, self.tutorialsVideos[@"h5maibi"]];
        playVC.tit = @"卖币教学";
    }
    else if ([type isEqualToString:@"RMB"]) {
        playVC.sourceUrl = [NSString stringWithFormat:@"%@%@",self.h5Root, self.tutorialsVideos[@"h5chongbi"]];
        playVC.tit = @"RMB直充教学";
    }
    else if ([type isEqualToString:@"USDT"]) {
        playVC.sourceUrl = [NSString stringWithFormat:@"%@%@",self.h5Root, self.tutorialsVideos[@"h5maibi"]];
        playVC.tit = @"数字货币充值教学";
    }
    else {
        return;
    }
    
    playVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:playVC animated:YES completion:nil];
}


#pragma mark -
#pragma mark Fetch Data From Server
- (void)fetchData {
    self.bannerModels = [[NSMutableArray alloc] init];
    self.setTypeModels = [[NSMutableArray alloc] init];
    
    WEAKSELF_DEFINE
    [BYTradeEntryRequest fetchTradeHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!errorMsg) {
            BYTradeEntryModel *model = [BYTradeEntryModel cn_parse:responseObj][self.type == TradeEntryTypeDeposit ? 0 : 1];
            NSArray *banners = [BYJSONHelper dictOrArrayWithJsonString:model.banner][@"h5"];
            strongSelf.bannerModels = [[NSMutableArray alloc] init];

            for (NSDictionary *dict in banners) {
                [strongSelf.bannerModels addObject:[TradeBannerItem cn_parse:dict]];
            }
            
            NSArray *setTypes = [BYJSONHelper dictOrArrayWithJsonString:model.setType];
            for (NSMutableDictionary *dict in setTypes) {
                dict[@"icon"] = [NSString stringWithFormat:@"icon_%@_", strongSelf.type == TradeEntryTypeWithdraw ? @"withdraw" : @"deposit"];
                [strongSelf.setTypeModels addObject:[TradeEntrySetTypeItem cn_parse:dict]];
            }
            
            strongSelf.tutorialsVideos = [BYJSONHelper dictOrArrayWithJsonString:model.video];
            strongSelf.h5Root = model.h5_root;
                
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
                [strongSelf setupBanner];
            });
        }
    }];

}

#pragma mark -
#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannerModels.count > 0 && self.bannerModels.count-1 >= index) {
        TradeBannerItem *item = self.bannerModels[index];
        [NNPageRouter jump2HTMLWithStrURL:item.url title:@"活动" needPubSite:NO];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.setTypeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYTradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTradeEntryCell];
    [cell setCellWithItem:self.setTypeModels[indexPath.row] row:indexPath.row];
    return  cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeEntrySetTypeItem *setTypeItem = self.setTypeModels[indexPath.row];

    if ([setTypeItem.type isEqualToString:@"YEB"]) { //餘額寶
        [self.navigationController pushViewController:[BYYuEBaoVC new] animated:YES];
    }
    else if ([setTypeItem.type isEqualToString:@"TB"]) { //提幣
        if ([[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowWithdrawUserDefaultKey] == false) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:HYNotShowWithdrawUserDefaultKey];
            [self playTurtorialVideosWithType:setTypeItem.type];
            return;
        }
        
        [self.navigationController pushViewController:[HYWithdrawViewController new] animated:YES];
    }
    else if ([setTypeItem.type isEqualToString:@"MB"]) { //賣幣
        if ([[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowSellUserDefaultKey] == false) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:HYNotShowSellUserDefaultKey];
            [self playTurtorialVideosWithType:setTypeItem.type];
            return;
        }
        
        [HYWideOneBtnAlertView showWithTitle:@"卖币跳转" content:@"正在为您跳转..请稍后。\n在交易所卖币数字货币，买家会将金额支付到您的银行卡，方便快捷。" comfirmText:@"我知道了，帮我跳转" comfirmHandler:^{
            [NNPageRouter openExchangeElecCurrencyPage];
        }];
    }
    else if ([setTypeItem.type isEqualToString:@"RMB"]) { //人民幣直充
        if ([[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowRMBRechrageUserDefaultKey] == false) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:HYNotShowRMBRechrageUserDefaultKey];
            [self playTurtorialVideosWithType:setTypeItem.type];
            return;
        }
        
        [NNPageRouter jump2BuyECoin];
    }
    else if ([setTypeItem.type isEqualToString:@"USDT"]) {  //數位貨幣充值
        if ([[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowDigitRechargeUserDefaultKey] == false) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:HYNotShowDigitRechargeUserDefaultKey];
            [self playTurtorialVideosWithType:setTypeItem.type];
            return;
        }
        
        [self.navigationController pushViewController:[BYDepositUsdtVC new] animated:YES];
    }
    
}

#pragma mark -
#pragma mark IBAction
- (IBAction)tutorialWithdrawDepositClicked:(id)sender {
    if (self.type == TradeEntryTypeDeposit) {
        [self playTurtorialVideosWithType:@"RMB"];
    }
    else {
        [self playTurtorialVideosWithType:@"TB"];
    }
    
}

- (IBAction)tutorialSellBuyClicked:(id)sender {
    if (self.type == TradeEntryTypeDeposit) {
        [self playTurtorialVideosWithType:@"USDT"];
    }
    else {
        [self playTurtorialVideosWithType:@"MB"];
    }
    
}

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC];
}


#pragma mark -
#pragma mark Lazy Load
- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 120) delegate:self placeholderImage:[UIImage imageNamed:@"3"]];
        bannerView.layer.cornerRadius = 6;
        bannerView.layer.masksToBounds = true;
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleBiyou;
        bannerView.pageControlDotSize = CGSizeMake(AD(6), AD(6));
        bannerView.autoScrollTimeInterval = 4;
        bannerView.autoScroll = true;
        _bannerView = bannerView;
    }
    return _bannerView;
}

@end
