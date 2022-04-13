//
//  BYMyBonusTableViewController.m
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "BYMyBonusTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "BYMyBonusTableViewCell.h"
#import "LYEmptyView.h"
#import "UIView+Empty.h"
#import "PublicMethod.h"
#import "RedPacketsRainView.h"
#import "CNLoginRegisterVC.h"
#import "A03ActivityManager.h"
#import "BTTAnimationPopView.h"

static NSString *const KMyBonusCell = @"BYMyBonusTableViewCell";

@interface BYMyBonusTableViewController ()

@end

@implementation BYMyBonusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = KColorRGB(16, 16, 28);
    self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
    self.tableView.rowHeight = 170;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:KMyBonusCell bundle:nil] forCellReuseIdentifier:KMyBonusCell];
    
    WEAKSELF_DEFINE
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONGSELF_DEFINE
        if (strongSelf.delegate) {
            [strongSelf.delegate refreshBegin];
        }
    }];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"kongduixiang"
                                                            titleStr:@"暂无内容"
                                                           detailStr:@""];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setPromos:(NSArray<BYMyBounsModel *> *)promos {
    
    NSMutableArray *sortPromos = promos.mutableCopy;
    NSMutableArray *topPromos = @[].mutableCopy;
    NSMutableArray *btmPromos = @[].mutableCopy;
    [sortPromos enumerateObjectsUsingBlock:^(BYMyBounsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 结束de置底
        if (obj.flag == 0) {
            [sortPromos removeObject:obj];
            [btmPromos addObject:obj];
        } else if (obj.isTop) { // 置顶
            [sortPromos removeObject:obj];
            [topPromos addObject:obj];
        }
    }];
    [sortPromos addObjectsFromArray:btmPromos];
    [topPromos enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sortPromos insertObject:obj atIndex:0];
    }];
    
    _promos = sortPromos;
    
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.promos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYMyBounsModel *item = self.promos[indexPath.row];
    BYMyBonusTableViewCell *cell = (BYMyBonusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:KMyBonusCell forIndexPath:indexPath];
    WEAKSELF_DEFINE
    cell.goFetchAction = ^(NSString * _Nonnull requestId) {
        STRONGSELF_DEFINE
        if ([strongSelf.delegate respondsToSelector:@selector(applyPromoWithRequestId:)])
        {
            [strongSelf.delegate applyPromoWithRequestId:requestId];
        }
    };
    cell.goDepositAction = ^{
        [NNPageRouter jump2Deposit];
    };
    cell.goRefreshBegin = ^{
        STRONGSELF_DEFINE
        [strongSelf.delegate refreshBegin];
    };
    cell.model = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self jumpToHtmlWithIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH * (215.0/375.0);
}
@end
