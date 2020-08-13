//
//  CNMessageCenterVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNMessageCenterVC.h"
#import "CNNotifySettingVC.h"
#import "CNMessageTCell.h"
#import "CNUserCenterRequest.h"
#import "CNHomeRequest.h"
#import <MJRefresh/MJRefresh.h>
#import "LYEmptyView.h"
#import "UIView+Empty.h"

#define kCNMessageTCellID  @"CNMessageTCell"

@interface CNMessageCenterVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *notifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger selecTag; //0公告 1站内信
@property (nonatomic, assign) NSInteger currPage; // 站内信页码
@property (nonatomic, strong) NSMutableArray<ArticalModel*> *articals;//站内信
@property (nonatomic, strong) NSArray<AnnounceModel *> *announces;//公告
@end

@implementation CNMessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    [self addNaviRightItemWithImageName:@"sz"];
    [self configUI];
    
    self.currPage = 0;
    self.articals = @[].mutableCopy;
    [self requestAnnouncement];
    [self requestLetters];
}

- (void)rightItemAction {
    [self.navigationController pushViewController:[CNNotifySettingVC new] animated:YES];
}

- (void)configUI {
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:kCNMessageTCellID bundle:nil] forCellReuseIdentifier:kCNMessageTCellID];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"no date"
                                                            titleStr:@"暂无内容"
                                                           detailStr:@""];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestLetters)];
}

// 公告
- (IBAction)notify:(UIButton *)sender {
    sender.selected = YES;
    self.selecTag = 0;
    self.messageBtn.selected = NO;
    self.bottomLine.centerX = sender.centerX;
    // 切换数据源为公告，reload
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.tableView reloadData];
}

// 站内信
- (IBAction)message:(UIButton *)sender {
    sender.selected = YES;
    self.selecTag = 1;
    self.notifyBtn.selected = NO;
    self.bottomLine.centerX = sender.centerX;
    // 切换数据源为站内信，reload
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView reloadData];
}


#pragma mark - REQUEST
/// 公告
- (void)requestAnnouncement {
    [CNHomeRequest requestGetAnnouncesHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            NSArray<AnnounceModel *> *announces = [AnnounceModel cn_parse:responseObj];
            self.announces = announces;
            [self.tableView reloadData];
        }
    }];
}

/// 站内信
- (void)requestLetters {
    [CNUserCenterRequest queryLetterPageNo:self.currPage pageSize:10 handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *data = responseObj[@"data"];
            NSArray<ArticalModel*> *articals = [ArticalModel cn_parse:data];
            if (self->_currPage == 0) {
                self.articals = articals.copy;
            } else {
                [self.articals addObjectsFromArray:articals];
            }
            self.currPage ++;
            if (data.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma - mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selecTag) {
        return self.articals.count;
    } else {
        return self.announces.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CNMessageTCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNMessageTCellID forIndexPath:indexPath];
    if (self.selecTag) {
        ArticalModel *arti = self.articals[indexPath.row];
        cell.timeLb.text = arti.publishDate;
        cell.contentLb.text = arti.articleContent;
    } else {
        AnnounceModel *anno = self.announces[indexPath.row];
        cell.timeLb.text = anno.createDate;
        cell.contentLb.text = anno.content;
    }
//    if ((indexPath.row % 2) == 0) {
//        cell.timeLb.text = @"2020-07-10 12:22:16";
//        cell.contentLb.text = @"尊贵的会员，近期因国际线路不稳定，导致钓鱼网站有机可乘，活动日渐猖獗。请大家提高警惕，不要相信任何网站的不实尊贵的会员，近期因国际线路不稳定，导致钓鱼网站有机可乘，活动日渐猖";
//    } else {
//        cell.timeLb.text = @"12:22:16";
//        cell.contentLb.text = @"尊贵的会员钓鱼网站有机可乘，活动日渐猖";
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
@end
