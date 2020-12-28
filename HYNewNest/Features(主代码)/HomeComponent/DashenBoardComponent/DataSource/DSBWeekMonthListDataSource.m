//
//  DSBWeekMonthListDataSource.m
//  HYNewNest
//
//  Created by zaky on 12/21/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBWeekMonthListDataSource.h"
#import "DSBWeekMonthListCell.h"
#import "HYDSBSlideUpView.h"

NSString *const listCellID = @"DSBWeekMonthListCell";

@interface DSBWeekMonthListDataSource () <UITableViewDelegate, UITableViewDataSource>
@property (weak,nonatomic) id<DashenBoardAutoHeightDelegate> delegate; // 高度代理
@property (weak,nonatomic) UITableView *tableView;

//TODO:=
@property (strong,nonatomic) NSArray *fakeData;
@end

@implementation DSBWeekMonthListDataSource

- (instancetype)initWithDelegate:(id)delegate TableView:(UITableView *)tableView type:(DashenBoardType)type {
    
    self = [super init];
    _delegate = delegate;
    
    tableView.backgroundColor = kHexColor(0x1C1B34);
    [tableView registerNib:[UINib nibWithNibName:listCellID bundle:nil] forCellReuseIdentifier:listCellID];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    _tableView = tableView;
    
    _type = type;
    
    return self;
}

//TODO: 修改数据源 修改高度
- (void)setType:(DashenBoardType)type {
    _type = type;
    
    [self.tableView reloadData];
    if (self.delegate) {
        [self.delegate didSetupDataGetTableHeight:(250.0)];
    }
}

- (NSArray *)fakeData {
    if (self.type == DashenBoardTypeWeekBoard) {
        _fakeData = @[@[@"累计盈利冠军", @"fxxx23", @"33,123,123"],
                      @[@"单比盈利冠军", @"fxxx23", @"235,234"],
                      @[@"充值冠军", @"fxxx23", @"775,234"],
                      @[@"提现冠军", @"fxxx23", @"235,234"],
                      @[@"提现冠军", @"fxxx23", @"23,235,234"]];
    } else {
        _fakeData = @[@[@"累计盈利冠军", @"fxxx55", @"3,123,123"],
                      @[@"单比盈利冠军", @"fxxx55", @"23,235,234"],
                      @[@"充值冠军", @"fxxx55", @"235,234"],
                      @[@"提现冠军", @"fxxx55", @"23,235,234"],
                      @[@"提现冠军", @"fxxx55", @"23,235,234"]];
    }
    
    return _fakeData;
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fakeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSBWeekMonthListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID];
    [cell setupDataArr:self.fakeData[indexPath.row]];
    cell.btmLine.hidden = indexPath.row == self.fakeData.count - 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyLog(@"点了%@", indexPath);
    
    [HYDSBSlideUpView showSlideupView];
}

@end
