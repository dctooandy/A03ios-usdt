//
//  BYWithdrawVC.m
//  HYNewNest
//
//  Created by RM04 on 2021/6/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYWithdrawVC.h"
#import "BYWithdrawTableViewCell.h"
#import "SDCycleScrollView.h"
#import "CNWithdrawRequest.h"

@interface BYWithdrawVC () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bannerBackgroundView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) NSArray<AdBannerModel *> *bannModels;

@end

@implementation BYWithdrawVC

static NSString * const kWithDrawCell = @"BYWithdrawCellID";

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [self fetchBannerData];


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
    [self setTitle:@"提现"];
    [self.tableView.tableHeaderView addSubview:self.bannerView];
    [self.tableView registerNib:[UINib nibWithNibName:@"BYWithdrawTableViewCell" bundle:nil]
         forCellReuseIdentifier:kWithDrawCell];

}

#pragma mark -
#pragma mark Fetch Data From Server
- (void)fetchBannerData {
    WEAKSELF_DEFINE
    [CNWithdrawRequest fetchBannerHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!errorMsg) {
            AdBannerGroupModel *groupModel = [AdBannerGroupModel cn_parse:responseObj];
            NSMutableArray *modArr = @[].mutableCopy;
            NSMutableArray *imgUrls = @[].mutableCopy;
            for (AdBannerModel *model in groupModel.bannersModel) {
                // !!!: 这里要根据货币模式筛选banner
                if([CNUserManager shareManager].isUsdtMode) {
                    if ([model.linkParam[@"mode"] isEqualToString:@"rmb"]) { // usdt模式筛掉rmb banner
                        continue;
                    }
                } else {
                    if ([model.linkParam[@"mode"] isEqualToString:@"usdt"]) { // rmb模式筛掉usdt banner
                        continue;
                    }
                }
                NSString *fullUrl = [groupModel.domainName stringByAppendingString:model.imgUrl];
                [imgUrls addObject:fullUrl];
                [modArr addObject:model];
            }
            strongSelf.bannerView.imageURLStringsGroup = imgUrls;
            strongSelf.bannModels = modArr;
        }
    }];
}

#pragma mark -
#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannModels.count > 0 && self.bannModels.count-1 >= index) {
        AdBannerModel *model = self.bannModels[index];
        if ([model.linkUrl containsString:@"detailsPage?id="]) { // 跳文章
            NSString *articalId = [model.linkUrl componentsSeparatedByString:@"="].lastObject;
            [NNPageRouter jump2ArticalWithArticalId:articalId title:@"文章"];
        } else if ([model.linkUrl hasPrefix:@"http"]) { // 跳外链
            NSURL *URL = [NSURL URLWithString:model.linkUrl];
            if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
                    [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
                }];
            }
        } else { // 跳活动
            [NNPageRouter jump2HTMLWithStrURL:model.linkUrl title:@"电游活动" needPubSite:NO];
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWithdrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWithDrawCell];
    [cell setIndexRow:indexPath.row];
    return  cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
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
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 150) delegate:self placeholderImage:[UIImage imageNamed:@"3"]];
        bannerView.layer.cornerRadius = 6;
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleBiyou;
        bannerView.pageControlDotSize = CGSizeMake(AD(6), AD(6));
        bannerView.autoScrollTimeInterval = 4;
        _bannerView = bannerView;
    }
    return _bannerView;
}

@end
