//
//  CNMSelectChannelVC.m
//  Hybird_1e3c3b
//
//  Created by cean on 2/15/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMSelectChannelVC.h"
#import "CNMChannelTCell.h"
#define kCNMChannelTCell    @"CNMChannelTCell"

@interface CNMSelectChannelVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CNMSelectChannelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];;
    self.title = @"选择充值方式";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 80;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:kCNMChannelTCell bundle:nil] forCellReuseIdentifier:kCNMChannelTCell];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma - mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.payments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNMChannelTCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNMChannelTCell forIndexPath:indexPath];
    cell.channel = self.payments[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelectedIndex = indexPath.row;
    !_finish ?: _finish(indexPath.row);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - OverWrite

- (void)goToBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
