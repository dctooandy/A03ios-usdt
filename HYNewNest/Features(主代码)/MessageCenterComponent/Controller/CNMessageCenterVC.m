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

#import "HYTabBarViewController.h"

#define kCNMessageTCellID  @"CNMessageTCell"

@interface CNMessageCenterVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *notifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger selecTag; //0公告 1站内信
@property (nonatomic, assign) NSInteger currPage; // 站内信页码
@property (nonatomic, strong) NSMutableArray<AnnounceModel*> *articals;//站内信
@property (nonatomic, strong) NSArray<AnnounceModel *> *announces;//公告
@end

@implementation CNMessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
//    [self addNaviRightItemWithImageName:@"sz"];
    [self configUI];
    
    self.currPage = 1;
    self.articals = @[].mutableCopy;
    [self requestAnnouncement];
    [self requestLetters];
    
    NSInteger unread = [(HYTabBarViewController *)[NNControllerHelper currentTabBarController] unreadMessage];
    [self setUnreadMessage:unread];
}

//- (void)rightItemAction {
//    [self.navigationController pushViewController:[CNNotifySettingVC new] animated:YES];
//}

- (void)configUI {
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:kCNMessageTCellID bundle:nil] forCellReuseIdentifier:kCNMessageTCellID];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"kongduixiang"
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
    
    //after confirm reload tableview finish set message to read
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self performSelector:@selector(setMessageRead) withObject:nil afterDelay:1.f];
    }];
    [self.tableView reloadData];
    [CATransaction commit];
}

- (void)setUnreadMessage:(NSInteger)unread {
    if (unread <= 0) {
        [self.messageBtn setJk_shouldHideBadgeAtZero:true];
        [self.messageBtn setJk_badgeValue:@"0"];
    }
    else if (unread >= 100){
        [self.messageBtn setJk_badgeValue:[NSString stringWithFormat:@"99+"]];
    }
    else {
        [self.messageBtn setJk_badgeValue:[NSString stringWithFormat:@"%li", unread]];
    }
    
    [self.messageBtn setJk_badgeOriginX:CGRectGetWidth(self.messageBtn.frame) - 50];
    [self.messageBtn setJk_badgeOriginY:5];

}

- (void)setMessageRead {
    //    set read
    __block NSMutableArray *ids = [NSMutableArray new];
    [self.articals enumerateObjectsUsingBlock:^(AnnounceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.flag == false) {
            [ids addObject:obj.announceID];
            obj.flag = true;
        }
    }];
    
    if (ids.count > 0) {
        WEAKSELF_DEFINE
        [CNUserCenterRequest setLetterReadWithId:ids
                                         handler:^(id responseObj, NSString *errorMsg) {
            if (!errorMsg) {
                NSInteger originalUnread = [(HYTabBarViewController *)[NNControllerHelper currentTabBarController] unreadMessage];
                NSInteger unread = originalUnread - ids.count;
                [weakSelf setUnreadMessage:unread];
                [[NSNotificationCenter defaultCenter] postNotificationName:BYDidReadMessageNotificaiton object:nil];
            }
        }];
    }
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
            NSArray<AnnounceModel*> *articals = [AnnounceModel cn_parse:data];
            if (self->_currPage == 0) {
                self.articals = articals.mutableCopy;
            } else {
                if (articals.count > 0) {
                    [self.articals addObjectsFromArray:articals];
                }
            }
            self.currPage ++;
            if (data.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            
            if (self.selecTag) {
                //after confirm reload tableview finish set message to read
                [CATransaction begin];
                [CATransaction setCompletionBlock:^{
//                    [self setMessageRead];
                    [self performSelector:@selector(setMessageRead) withObject:nil afterDelay:1.f];
                }];
                [self.tableView reloadData];
                [CATransaction commit];
                
            }
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
        AnnounceModel *arti = self.articals[indexPath.row];
        cell.timeLb.text = arti.createDate;
        cell.contentLb.text = arti.content;
        cell.markLabel.text = @"未读";
        cell.markLabelConstraint.constant = arti.flag ? 0 : 30;
        
    } else {
        AnnounceModel *anno = self.announces[indexPath.row];
        cell.timeLb.text = anno.createDate;
        cell.contentLb.text = anno.content;
        cell.markLabel.text = @"新";
        cell.markLabelConstraint.constant = anno.isRead ? 0 : 30;
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
