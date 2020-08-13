//
//  HYBonusViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/17.
//  Copyright © 2020 james. All rights reserved.
//

#import "HYBonusViewController.h"
#import "LTSegmentedBarViewController.h"
#import "HYBonusTableViewController.h"
#import "CNBonusRequest.h"

@interface HYBonusViewController () <BonusTableViewDelegate>
@property (nonatomic, strong) LTSegmentedBarViewController *segBarVC;
@property (nonatomic, strong) HYBonusTableViewController *allTVC;
@property (nonatomic, strong) HYBonusTableViewController *realPersonTVC;
@property (nonatomic, strong) HYBonusTableViewController *elecGameTVC;
@property (nonatomic, strong) HYBonusTableViewController *otherTVC;

@end

@implementation HYBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSegBarVC];
    [self loadDataAndHandle];

}

- (void)refreshBegin {
    [self loadDataAndHandle];
}

- (void)loadDataAndHandle {
    WEAKSELF_DEFINE
    [CNBonusRequest getBonusListHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *dicArr = responseObj[@"myPromoList"];
            
            NSArray *allPro = [MyPromoItem cn_parse:dicArr];
            NSMutableArray *realPro = @[].mutableCopy;
            NSMutableArray *elecPro = @[].mutableCopy;
            NSMutableArray *othePro = @[].mutableCopy;
            for (MyPromoItem *item in allPro) {
                if ([item.imgTip isEqualToString:@"真人"]) {
                    [realPro addObject:item];
                } else if ([item.imgTip isEqualToString:@"电游"]) {
                    [elecPro addObject:item];
                } else {
                    [othePro addObject:item];
                }
            }
            strongSelf.allTVC.promos = allPro;
            strongSelf.realPersonTVC.promos = realPro;
            strongSelf.elecGameTVC.promos = elecPro;
            strongSelf.otherTVC.promos = othePro;
            [strongSelf.allTVC.tableView reloadData];
        }
    }];
}


- (void)setupSegBarVC {
    
    HYBonusTableViewController *vc1 = [HYBonusTableViewController new];
    self.allTVC = vc1;
    vc1.delegate = self;
    
    HYBonusTableViewController *vc2 = [HYBonusTableViewController new];
    self.realPersonTVC = vc2;
    vc2.delegate = self;
    
    HYBonusTableViewController *vc3 = [HYBonusTableViewController new];
    self.elecGameTVC = vc3;
    vc3.delegate = self;
    
    HYBonusTableViewController *vc4 = [HYBonusTableViewController new];
    self.otherTVC = vc4;
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
    [self.segBarVC setUpWithItems:@[@"全部", @"真人", @"电游", @"其他"]
             childViewControllers:@[vc1, vc2, vc3, vc4]];
}


#pragma mark - LAZY
- (LTSegmentedBarViewController *)segBarVC{
    if (!_segBarVC)
    {
        LTSegmentedBarViewController *segBarVC = [[LTSegmentedBarViewController alloc] init];
        
        segBarVC.segmentedBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        self.navigationItem.titleView = segBarVC.segmentedBar;
        
        segBarVC.view.frame = self.view.frame;
        [self addChildViewController:segBarVC];
        [self.view addSubview:segBarVC.view];
        _segBarVC = segBarVC;
    }
    return  _segBarVC;
}

@end
