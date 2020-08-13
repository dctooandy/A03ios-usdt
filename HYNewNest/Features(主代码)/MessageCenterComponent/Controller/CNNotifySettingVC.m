//
//  CNNotifySettingVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNNotifySettingVC.h"
#import "CNNotifySettingTCell.h"
#import "CNUserCenterRequest.h"
#define kCNNotifySettingTCellID  @"CNNotifySettingTCell"

@interface CNNotifySettingVC () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *models;
@end

@implementation CNNotifySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知设置";
    [self configUI];
    
    [self querySubscribe];
}

- (void)configUI {
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:kCNNotifySettingTCellID bundle:nil] forCellReuseIdentifier:kCNNotifySettingTCellID];
}

- (void)querySubscribe {
    [CNUserCenterRequest queryUserSubscribHandler:^(id responseObj, NSString *errorMsg) {
        NSArray<UserSubscribItem *> *subcs = [UserSubscribItem cn_parse:responseObj];
        self.models = subcs;
        [self.tableView reloadData];
    }];
}


// 提交
- (IBAction)submit:(id)sender {
    [CNUserCenterRequest modifyUserSubscribArray:self.models handler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            [CNHUB showSuccess:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    __block UserSubscribItem *model = self.models[indexPath.row];
    CNNotifySettingTCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNNotifySettingTCellID forIndexPath:indexPath];
    cell.titleLb.text = model.name;
    cell.selectBtn.selected = [model.subscribed boolValue];
    cell.btnClick = ^(BOOL selected) {
        model.subscribed = @(selected?1:0);
    };
    return cell;
}


@end
