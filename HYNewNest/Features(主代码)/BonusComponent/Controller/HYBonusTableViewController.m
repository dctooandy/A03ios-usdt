//
//  HYBonusTableViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/28.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYBonusTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "HYBonusCell.h"
#import "LYEmptyView.h"
#import "UIView+Empty.h"
#import "PublicMethod.h"
#import "RedPacketsRainView.h"
#import "CNLoginRegisterVC.h"
#import "A03ActivityManager.h"
#import "BTTAnimationPopView.h"
static NSString *const KBonusCell = @"HYBonusCell";

@interface HYBonusTableViewController ()

@end

@implementation HYBonusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = KColorRGB(16, 16, 28);
    self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
    self.tableView.rowHeight = 170;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:KBonusCell bundle:nil] forCellReuseIdentifier:KBonusCell];
    
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


- (void)setPromos:(NSArray<MyPromoItem *> *)promos {
    
    NSMutableArray *sortPromos = promos.mutableCopy;
    NSMutableArray *topPromos = @[].mutableCopy;
    NSMutableArray *btmPromos = @[].mutableCopy;
    [sortPromos enumerateObjectsUsingBlock:^(MyPromoItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    MyPromoItem *item = self.promos[indexPath.row];
    HYBonusCell *cell = (HYBonusCell *)[tableView dequeueReusableCellWithIdentifier:KBonusCell forIndexPath:indexPath];
    WEAKSELF_DEFINE
    cell.tapMoreAction = ^{
        [weakSelf jumpToHtmlWithIndexPath:indexPath];
    };
    cell.model = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self jumpToHtmlWithIndexPath:indexPath];
}
-(void)jumpToHtmlWithIndexPath:(NSIndexPath *)indexPath
{
    MyPromoItem *item = self.promos[indexPath.row];
    NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
    BOOL isBeforeDuration = [duractionArray[0] boolValue];
    BOOL isActivityDuration = [duractionArray[1] boolValue];
    BOOL isRainningTime = [duractionArray[2] boolValue];
    if ((isBeforeDuration || isActivityDuration)&& ([item.linkUrl containsString:@"tiger_red_envelope"]))
    {
        [self bonusShowRedPacketsRainViewwWithStyle:(isActivityDuration ? (isRainningTime ? RedPocketsViewRainning : RedPocketsViewBegin): RedPocketsViewPrefix)];
    }else
    {
        if (!KIsEmptyString(item.linkUrl)) {
            [NNPageRouter jump2HTMLWithStrURL:item.linkUrl
                                        title:item.title.length>0?item.title:@"优惠"
                                  needPubSite:NO];
    }
    }
}
- (void)bonusShowRedPacketsRainViewwWithStyle:(RedPocketsViewStyle)currentStyle
{
    if (![CNUserManager shareManager].isLogin && (currentStyle == RedPocketsViewBegin ||
                                                  currentStyle == RedPocketsViewRainning ||
                                                  currentStyle == RedPocketsViewDev))
    {
        [self.navigationController pushViewController:[CNLoginRegisterVC loginVC] animated:YES];
    }else
    {
        [[A03ActivityManager sharedInstance] checkTimeRedPacketRainWithCompletion:^(NSString * _Nullable response, NSString * _Nullable error) {
            RedPacketsRainView *alertView = [RedPacketsRainView viewFromXib];
            [alertView configForRedPocketsViewWithStyle:currentStyle];
            BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:alertView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
            popView.isClickBGDismiss = YES;
            [popView pop];
            
            [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            alertView.dismissBlock = ^{
                [popView dismiss];
            };
            alertView.btnBlock = ^(UIButton * _Nullable btn) {
                [popView dismiss];
            };
        } WithDefaultCompletion:nil];
    }
}
@end
