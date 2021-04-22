//
//  BYRechargeUsdtVC.m
//  HYNewNest
//
//  Created by zaky on 4/21/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYRechargeUsdtVC.h"
#import "SDCycleScrollView.h"

#import "BYRechargeUSDTTopView.h" //这是cell

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

@property (assign,nonatomic) NSInteger selIdx; //!<选中行 未选中设置为-1

@end

@implementation BYRechargeUsdtVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"充币";
    _selIdx = -1;
    [self addNaviRightItemWithImageName:@"kf"];
    
    _tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);// 顶部间隙
    [_tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
    
    _topBanner.localizationImageNamesGroup = @[@"gg"];
    _topBanner.delegate = self;
}

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC:CNLive800TypeDeposit];
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
        [UIView animateWithDuration:0.35 animations:^{
            self.topBanner.alpha = 0.0;
            self.btmBannerBg.alpha = 0.0;
            self.tableViewBtm2SafeAreaCons.priority = UILayoutPriorityRequired;
            self.tableViewTop2BgViewCons.priority = UILayoutPriorityRequired;

            self.tableView.contentInset = UIEdgeInsetsZero;
        }];
    }
    
    [self.tableView reloadData];
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:(selIdx>0)?selIdx:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (cycleScrollView == _topBanner) {
        MyLog(@"点击了顶部");
    }
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selIdx) {
        return 428;
    } else {
        return 110;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYRechargeUSDTTopView *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
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
    
    if (_selIdx == indexPath.row) { // 点击选中的cell
        self.selIdx = -1;
    } else { // 点击未选中的cell
        self.selIdx = indexPath.row;
    }
    
}


@end
  
