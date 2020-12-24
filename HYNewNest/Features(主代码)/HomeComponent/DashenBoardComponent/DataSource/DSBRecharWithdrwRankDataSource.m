//
//  DSBRecharWithdrwRankDataSource.m
//  HYNewNest
//
//  Created by zaky on 12/21/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBRecharWithdrwRankDataSource.h"
#import "DSBRchrWthdrwRankCell.h"
#import "DSBRchrWthdrwHeader.h"
#import "BYDashenBoardConst.h"

NSString *const RankCellID = @"DSBRchrWthdrwRankCell";
NSString *const HeaderID = @"DSBRchrWthdrwHeader";

@interface DSBRecharWithdrwRankDataSource()<UITableViewDelegate, UITableViewDataSource>
@property (weak,nonatomic) id<DashenBoardAutoHeightDelegate> delegate; // 高度代理
@property (weak,nonatomic) UITableView *tableView;

//TODO:=
@property (strong,nonatomic) NSArray *fakeData;

@end

@implementation DSBRecharWithdrwRankDataSource

- (instancetype)initWithDelegate:(id)delegate TableView:(UITableView *)tableView type:(DashenBoardType)type {
    
    self = [super init];
    _delegate = delegate;
    
    tableView.backgroundColor = kHexColor(0x1C1B34);
    [tableView registerNib:[UINib nibWithNibName:RankCellID bundle:nil] forCellReuseIdentifier:RankCellID];
    [tableView registerNib:[UINib nibWithNibName:HeaderID bundle:nil] forHeaderFooterViewReuseIdentifier:HeaderID];
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
        [self.delegate didSetupDataGetTableHeight:(636.0)];
    }
}

- (NSArray *)fakeData {
    if (self.type == DashenBoardTypeRechargeBoard) {
        _fakeData = @[@[@"fxxx23", @"赌尊", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23", @"赌神", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23", @"赌圣", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23", @"赌王", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23", @"赌霸", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23", @"赌侠", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23", @"VIP1", @"123,123", @"12:30:42"],
                      @[@"fxxx23", @"VIP1", @"123,123", @"12:30:42"],
                      @[@"fxxx23", @"VIP1", @"123,123", @"12:30:42"],
                      @[@"fxxx23", @"VIP1", @"123,123", @"12:30:42"]];
    } else {
        _fakeData = @[@[@"fxxx23r", @"赌尊", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23r", @"赌神", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23r", @"赌圣", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23r", @"赌王", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23r", @"赌霸", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23r", @"赌侠", @"3,123,123", @"12:30:42"],
                      @[@"fxxx23r", @"VIP1", @"123,123", @"12:30:42"],
                      @[@"fxxx23r", @"VIP1", @"123,123", @"12:30:42"],
                      @[@"fxxx23r", @"VIP1", @"123,123", @"12:30:42"],
                      @[@"fxxx23r", @"VIP1", @"123,123", @"12:30:42"]];
    }
    
    return _fakeData;
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fakeData.count - 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSBRchrWthdrwRankCell *cell = (DSBRchrWthdrwRankCell*)[tableView dequeueReusableCellWithIdentifier:RankCellID];
    [cell setupIndexRow:indexPath.row dataArr:self.fakeData[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyLog(@"点了%@", indexPath);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DSBRchrWthdrwHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    //TODO: =
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 215;
}

@end
