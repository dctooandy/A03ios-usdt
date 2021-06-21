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

@interface BYTradeEntryVC () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(BYGradientButton) NSArray *playGuideButtons;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, assign) TradeEntryType type;

@property (nonatomic, strong) NSArray *bannerModels;
@property (nonatomic, strong) NSArray *setTypeModels;

@end

@implementation BYTradeEntryVC

static NSString * const kTradeEntryCell = @"BYTradeEntryCellID";

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

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
        [rechargeButton setTitle:@"充币教学" forState:UIControlStateNormal];
        
        BYGradientButton *buyButton = self.playGuideButtons[1];
        [buyButton setTitle:@"买币教学" forState:UIControlStateNormal];
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

}

- (UIImage *)iconImageWithRow:(NSInteger)row {
    UIImage *image;
    switch (row) {
        case 0:
            image = [UIImage imageNamed:self.type == TradeEntryTypeDeposit ? @"icon_RMB" : @"icon_YuEBao"];
            break;
        case 1:
            image = [UIImage imageNamed:self.type == TradeEntryTypeDeposit ? @"icon_recharge" : @"icon_withdraw"];
            break;;
        case 2:
            image = [UIImage imageNamed:self.type == TradeEntryTypeDeposit ? @"icon_buy" : @"icon_sell"];
            break;
        default:
            break;
    }
    return image;
}
#pragma mark -
#pragma mark Fetch Data From Server
- (void)fetchData {
    WEAKSELF_DEFINE
    [BYTradeEntryRequest fetchTradeHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!errorMsg) {
            BYTradeEntryModel *model = [BYTradeEntryModel cn_parse:responseObj][self.type == TradeEntryTypeDeposit ? 0 : 1];
            strongSelf.bannerModels = [BYJSONHelper dictOrArrayWithJsonString:model.banner][@"h5"];
            strongSelf.setTypeModels = [BYJSONHelper dictOrArrayWithJsonString:model.setType];
            NSLog(@"%@", strongSelf.setTypeModels);
            [strongSelf.tableView reloadData];
        }
    }];

}

#pragma mark -
#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannerModels.count > 0 && self.bannerModels.count-1 >= index) {
//        AdBannerModel *model = self.bannModels[index];
//        if ([model.linkUrl containsString:@"detailsPage?id="]) { // 跳文章
//            NSString *articalId = [model.linkUrl componentsSeparatedByString:@"="].lastObject;
//            [NNPageRouter jump2ArticalWithArticalId:articalId title:@"文章"];
//        } else if ([model.linkUrl hasPrefix:@"http"]) { // 跳外链
//            NSURL *URL = [NSURL URLWithString:model.linkUrl];
//            if ([[UIApplication sharedApplication] canOpenURL:URL]) {
//                [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
//                    [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
//                }];
//            }
//        } else { // 跳活动
//            [NNPageRouter jump2HTMLWithStrURL:model.linkUrl title:@"电游活动" needPubSite:NO];
//        }
        
//        TradeBannerItem *banner = self.bannerModels[index];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.setTypeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYTradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTradeEntryCell];
    
    NSDictionary *item = self.setTypeModels[indexPath.row];
    cell.suggestionImageView.hidden = indexPath.row == 0 ? false : true;
    cell.titleLabel.text = item[@"name"];
    cell.subTitleLabel.text = item[@"text"];
    cell.tradeImageView.image = [self iconImageWithRow:indexPath.row];
    
    return  cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row) {
//        case 0:
//            [self.navigationController pushViewController:[BYYuEBaoVC new] animated:true];
//            break;
//        case 1:
//            [self.navigationController pushViewController:[HYWithdrawViewController new] animated:true];
//            break;
//        default:
//            break;
//    }
}

#pragma mark -
#pragma mark IBAction
- (IBAction)withdrawToolClicked:(id)sender {
    /*
     HYCTZNPlayerViewController *playVC = [[HYCTZNPlayerViewController alloc] init];
     playVC.sourceUrl = model.video;
     playVC.tit = model.title;
     playVC.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:playVC animated:YES completion:nil];
     */
}

- (IBAction)sellToolClicked:(id)sender {
    /*
     HYCTZNPlayerViewController *playVC = [[HYCTZNPlayerViewController alloc] init];
     playVC.sourceUrl = model.video;
     playVC.tit = model.title;
     playVC.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:playVC animated:YES completion:nil];
     */
}

#pragma mark -
#pragma mark Lazy Load
- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 150) delegate:self placeholderImage:[UIImage imageNamed:@"3"]];
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
