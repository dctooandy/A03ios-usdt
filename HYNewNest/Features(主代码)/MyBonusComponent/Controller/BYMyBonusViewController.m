//
//  BYMyBonusViewController.m
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "BYMyBonusViewController.h"
#import "LTSegmentedBarViewController.h"
#import "BYMyBonusTableViewController.h"
#import "BYMyBonusRequest.h"
#import "UIImage+ESUtilities.h"

@interface BYMyBonusViewController ()<MyBonusTableViewDelegate>
@property (nonatomic, strong) LTSegmentedBarViewController *segBarVC;
@property (nonatomic, strong) BYMyBonusTableViewController *allMyBonusVC;
@property (nonatomic, strong) BYMyBonusTableViewController *goFetchBonusVC;
@property (nonatomic, strong) BYMyBonusTableViewController *alreadyFetchVC;
@property (nonatomic, strong) BYMyBonusTableViewController *overDateVC;

@end

@implementation BYMyBonusViewController

- (void)viewDidLoad {
    self.title = @"我的优惠";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSegBarVC];
    [self loadDataAndHandle];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshBegin];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYDidFetchBonusDataNotificaiton object:nil];
}
- (void)refreshBegin {
    [self loadDataAndHandle];
}

- (void)loadDataAndHandle {
    WEAKSELF_DEFINE
    [BYMyBonusRequest getMyBonusListHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!errorMsg && [responseObj isKindOfClass:[NSArray class]]) {
            NSArray *dicArr = responseObj;
            
            NSArray *allPro = [BYMyBounsModel cn_parse:dicArr];
            NSMutableArray *goFetch = @[].mutableCopy;
            NSMutableArray *alreadyFetch = @[].mutableCopy;
            NSMutableArray *overDate = @[].mutableCopy;
            for (BYMyBounsModel *item in allPro) {
                if ([item.status isEqualToString:@"1"] || [item.status isEqualToString:@"4"]) {
                    [goFetch addObject:item];
                } else if ([item.status isEqualToString:@"2"]) {
                    [alreadyFetch addObject:item];
                } else {
                    [overDate addObject:item];
                }
            }
            strongSelf.allMyBonusVC.promos = allPro;
            strongSelf.goFetchBonusVC.promos = goFetch;
            strongSelf.alreadyFetchVC.promos = alreadyFetch;
            strongSelf.overDateVC.promos = overDate;
            [strongSelf.allMyBonusVC.tableView reloadData];
            strongSelf.segBarVC.segmentedBar.items = @[[NSString stringWithFormat:@"全部(%lu)",allPro.count],
                                                       [NSString stringWithFormat:@"可领(%lu)",goFetch.count],
                                                       [NSString stringWithFormat:@"已领(%lu)",alreadyFetch.count],
                                                       [NSString stringWithFormat:@"过期(%lu)",overDate.count]];
        }
    }];
}
- (void)applyPromoWithRequestId:(NSString *)requestIdString
{
    WEAKSELF_DEFINE
    [BYMyBonusRequest fetchMyBonusWithRequestID:requestIdString Handler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!errorMsg ) {
            [CNTOPHUB showSuccess:@"领取成功"];
            [strongSelf loadDataAndHandle];
        }
    }];
}

- (void)setupSegBarVC {
    
    BYMyBonusTableViewController *vc1 = [BYMyBonusTableViewController new];
    self.allMyBonusVC = vc1;
    vc1.delegate = self;
    
    BYMyBonusTableViewController *vc2 = [BYMyBonusTableViewController new];
    self.goFetchBonusVC = vc2;
    vc2.delegate = self;
    
    BYMyBonusTableViewController *vc3 = [BYMyBonusTableViewController new];
    self.alreadyFetchVC = vc3;
    vc3.delegate = self;
    
    BYMyBonusTableViewController *vc4 = [BYMyBonusTableViewController new];
    self.overDateVC = vc4;
    vc4.delegate = self;
    
    // Setup SegmentedBar Configuration here
    [self.segBarVC.segmentedBar updateWithConfig:^(LTSegmentedBarConfig *config) {
        
        // 普通赋值
        config.itemNormalColor = kHexColor(0x6D778B);
        config.itemSelectColor = [UIColor whiteColor];
        config.itemNormalFont = [UIFont fontPFR13];
        config.itemSelectFont = [UIFont fontPFSB16];
        config.indicatorHeight = 2;
        config.indicatorWidth = 20;
        config.indicatorColor = [UIColor whiteColor];
        config.splitLineColor = kHexColor(0x6D778B);
        config.itemWidthFit = YES;
        
    }];

    // Setup Title and VC here
    [self.segBarVC setUpWithItems:@[@"全部", @"可领", @"已领", @"过期"]
             childViewControllers:@[vc1, vc2, vc3, vc4]];
}

#pragma mark - LAZY
- (LTSegmentedBarViewController *)segBarVC{
    if (!_segBarVC)
    {
        LTSegmentedBarViewController *segBarVC = [[LTSegmentedBarViewController alloc] init];
        
        segBarVC.segmentedBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
//        self.navigationItem.titleView = segBarVC.segmentedBar;
        [self.view addSubview:segBarVC.segmentedBar];
        
        segBarVC.view.frame = CGRectMake(0, 44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)  - 44);
        [self addChildViewController:segBarVC];
        [self.view addSubview:segBarVC.view];
        _segBarVC = segBarVC;
    }
    return  _segBarVC;
}
@end
