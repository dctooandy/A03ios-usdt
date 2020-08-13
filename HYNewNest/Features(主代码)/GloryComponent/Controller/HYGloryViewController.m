//
//  HYGloryViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/17.
//  Copyright © 2020 james. All rights reserved.
//

#import "HYGloryViewController.h"
#import "CNGloryRequest.h"
#import "LTSegmentedBarViewController.h"
#import "HYArticalTableViewController.h"

@interface HYGloryViewController ()
@property (nonatomic, weak) LTSegmentedBarViewController *segBarVC;
@end

@implementation HYGloryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSegBarVC];
    
}


- (void)setupSegBarVC {
    HYArticalTableViewController *vc1 = [[HYArticalTableViewController alloc] init];
    vc1.listType = A03ArticleTagListEssence;
    
    HYArticalTableViewController *vc2 = [[HYArticalTableViewController alloc] init];
    vc2.listType = A03ArticleTagListMasterGame;
    
    HYArticalTableViewController *vc3 = [[HYArticalTableViewController alloc] init];
    vc3.listType = A03ArticleTagListTrends;
    
    HYArticalTableViewController *vc4 = [[HYArticalTableViewController alloc] init];
    vc4.listType = A03ArticleTagListBrief;
    
    // Setup SegmentedBar Configuration here
    [self.segBarVC.segmentedBar updateWithConfig:^(LTSegmentedBarConfig *config) {
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
    [self.segBarVC setUpWithItems:@[@"精选", @"币游大师赛", @"币游动态", @"币游简报"]
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
