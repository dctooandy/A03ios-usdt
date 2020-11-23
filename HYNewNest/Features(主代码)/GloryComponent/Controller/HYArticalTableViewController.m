//
//  HYArticalTableViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/27.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYArticalTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "HYArticalCell.h"
#import "StrengthVideoTableViewCell.h"

static NSString *const kHYArticalCell = @"HYArticalCell";
static NSString *const kHYVideoCell = @"StrengthVideoTableViewCell";

@interface HYArticalTableViewController ()
@property (nonatomic, strong) NSArray<ArticalModel *> *articals;

@end

@implementation HYArticalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kHexColor(0x19182A);
    self.tableView.estimatedRowHeight = 155;
    [self.tableView registerNib:[UINib nibWithNibName:kHYArticalCell bundle:nil] forCellReuseIdentifier:kHYArticalCell];
    [self.tableView registerClass:[StrengthVideoTableViewCell class] forCellReuseIdentifier:kHYVideoCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self loadData];
}

- (void)loadData {
    
    [CNGloryRequest getA03ArticlesTagList:self.listType handler:^(id responseObj, NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *dicArr = responseObj[@"result"];
            self.articals = [ArticalModel cn_parse:dicArr];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticalModel *model = self.articals[indexPath.row];
    if ([model.layoutType integerValue] == 1 || [model.layoutType integerValue] == 3) {
        return 260;
    } else {
        return 155;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticalModel *model = self.articals[indexPath.row];
    if ([model.layoutType integerValue] == 1 || [model.layoutType integerValue] == 3) {
        StrengthVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHYVideoCell];
        [cell setDataModel:model];
        return cell;
    } else {
        HYArticalCell *cell = [tableView dequeueReusableCellWithIdentifier:kHYArticalCell forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticalModel *model = self.articals[indexPath.row];
    if (!KIsEmptyString(model.linkUrl)) {
        [NNPageRouter jump2HTMLWithStrURL:model.linkUrl title:model.titleName];
    } else {
        [NNPageRouter jump2ArticalWithArticalId:model.articleId title:model.titleName];
    }
    
}


@end
