//
//  CNDownloadVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNDownloadVC.h"
#import "CNDownloadTCell.h"
#import "LYEmptyView.h"
#import "UIView+Empty.h"
#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"

#define kCNDownloadTCellID  @"CNDownloadTCell"

@interface CNDownloadVC () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CNDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"APP下载";
    [self configUI];
    
    [self.tableView reloadData];
}


- (void)configUI {
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:kCNDownloadTCellID bundle:nil] forCellReuseIdentifier:kCNDownloadTCellID];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"kongduixiang"
                                                            titleStr:@"暂无内容"
                                                           detailStr:@""];
}

//- (void)requestData {
//    [CNUserCenterRequest requestOtherGameAppListHandler:^(id responseObj, NSString *errorMsg) {
//        NSArray *otherApps = [OtherAppModel cn_parse:responseObj];
//        self.otherApps = otherApps;
//        [self.tableView reloadData];
//    }];
//}


#pragma - mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.otherApps.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    OtherAppModel *model = self.otherApps[indexPath.row];
    CNDownloadTCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNDownloadTCellID forIndexPath:indexPath];
    cell.appNameLb.text = model.appName;
    cell.appDescLb.text = model.appDesc;
    [cell.appImageV sd_setImageWithURL:[NSURL getUrlWithString:model.appImage] placeholderImage:[UIImage imageNamed:@"2"]];
    cell.downloadAction = ^{
        NSLog(@"点击下载%ld", (long)indexPath.row);
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.appDownUrl]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.appDownUrl] options:@{} completionHandler:^(BOOL success) {
                [CNTOPHUB showSuccess:@"正在为您跳转..."];
            }];
        } else {
            [CNTOPHUB showError:@"未知错误 无法下载"];
        }
    };
    return cell;
}
@end

