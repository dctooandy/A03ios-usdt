//
//  BYVocherCenterVC.m
//  HYNewNest
//
//  Created by zaky on 3/10/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYVocherCenterVC.h"
#import "LTSegmentedBarViewController.h"
#import "BYVocherTableVC.h"

@interface BYVocherCenterVC ()
@property (nonatomic, weak) LTSegmentedBarViewController *segBarVC;
@end

@implementation BYVocherCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"优惠券";
    [self setupSegBarVC];
}

- (void)setupSegBarVC {
    BYVocherTableVC *vc1 = [[BYVocherTableVC alloc] initWithType:BYVocherTagListInReview];
    BYVocherTableVC *vc2 = [[BYVocherTableVC alloc] initWithType:BYVocherTagListUsing];
    BYVocherTableVC *vc3 = [[BYVocherTableVC alloc] initWithType:BYVocherTagListEnded];
    
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
        config.segmentedBarBackgroundColor = kHexColor(0x1A1A2C);
        config.itemWidthFit = YES;
    }];

    // Setup Title and VC here
    [self.segBarVC setUpWithItems:@[@"待使用", @"使用中", @"已结束"]
             childViewControllers:@[vc1, vc2, vc3]];
}

#pragma mark - LAZY
- (LTSegmentedBarViewController *)segBarVC{
    if (!_segBarVC)
    {
        LTSegmentedBarViewController *segBarVC = [[LTSegmentedBarViewController alloc] init];
        segBarVC.segmentedBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 54);
        [segBarVC.segmentedBar addLineDirection:LineDirectionTop color:kHexColorAlpha(0x6D778B, .5) width:0.5];
        [self.view addSubview:segBarVC.segmentedBar];
        
        segBarVC.view.frame = CGRectMake(0, 54, kScreenWidth, self.view.bounds.size.height-54);
        [self addChildViewController:segBarVC];
        [self.view addSubview:segBarVC.view];
        _segBarVC = segBarVC;
    }
    return  _segBarVC;
}

@end
