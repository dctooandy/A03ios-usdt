//
//  BYVocherTableVC.m
//  HYNewNest
//
//  Created by zaky on 3/10/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYVocherTableVC.h"
#import <MJRefresh/MJRefresh.h>
#import "BYVocherTVCell.h"
#import "UIView+Empty.h"
#import "LYEmptyView.h"

static NSString *const kBYVocherCell = @"BYVocherTVCell";

@interface BYVocherTableVC ()
@property (strong,nonatomic) NSMutableArray* expandRows;
@property (strong,nonatomic) NSArray *vouchers;
@end

@implementation BYVocherTableVC

- (instancetype)initWithType:(BYVocherTagList)type {
    self = [super init];
    self.listType = type;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.expandRows = @[].mutableCopy;
    [self setupTableView];
    [self loadData];
}

- (void)setupTableView {
    self.tableView.backgroundColor = kHexColor(0x10101C);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 190;
    [self.tableView registerNib:[UINib nibWithNibName:kBYVocherCell bundle:nil] forCellReuseIdentifier:kBYVocherCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"kongduixiang"
                                                            titleStr:@"暂无优惠券"
                                                           detailStr:@""];
}

- (void)loadData {
    WEAKSELF_DEFINE
    [BYVoucherRequest getWalletCouponsList:self.listType handler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        [strongSelf.tableView.mj_header endRefreshing];
        if (!errorMsg) {
            strongSelf.vouchers = [BYVocherModel cn_parse:responseObj];
            [strongSelf.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vouchers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.expandRows containsObject:@(indexPath.row)]) {
        return 324;
    }
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYVocherTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kBYVocherCell forIndexPath:indexPath];
    cell.isExpand = [self.expandRows containsObject:@(indexPath.row)];
    if (self.vouchers.count) {
        BYVocherModel *m = self.vouchers[indexPath.row];
        cell.model = m;
    }
    WEAKSELF_DEFINE
    cell.changeCellHeightBlock = ^(BOOL isExpand) {
        if (isExpand) {
            [weakSelf.expandRows addObject:@(indexPath.row)];
        } else {
            if ([weakSelf.expandRows containsObject:@(indexPath.row)]) {
                [weakSelf.expandRows removeObject:@(indexPath.row)];
            }
        }
        [weakSelf.tableView reloadData];
    };
    return cell;
}

@end
