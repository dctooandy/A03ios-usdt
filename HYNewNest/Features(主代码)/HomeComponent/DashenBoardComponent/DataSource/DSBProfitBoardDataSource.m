//
//  DSBProfitBoardDataSource.m
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBProfitBoardDataSource.h"
#import "DSBProfitBoardCell.h"
#import "DSBProfitFooter.h"
#import "DSBProfitHeader.h"
#import "DashenBoardRequest.h"

NSString *const ProfitCellId = @"DSBProfitBoardCell";
NSString *const ProfitFooterId = @"DSBProfitFooter";
NSString *const ProfitHeaderId = @"DSBProfitHeader";

@interface DSBProfitBoardDataSource () <UITableViewDelegate, UITableViewDataSource>
@property (weak,nonatomic) id<DashenBoardAutoHeightDelegate> delegate; // 高度代理
@property (weak,nonatomic) UITableView *tableView;

//TODO:=
@property (strong,nonatomic) NSArray *fakeData;

@end

@implementation DSBProfitBoardDataSource

- (instancetype)initWithDelegate:(id)delegate TableView:(UITableView *)tableView{
    
    self = [super init];
    _delegate = delegate;
    
    tableView.backgroundColor = kHexColor(0x1C1B34);
    [tableView registerNib:[UINib nibWithNibName:ProfitCellId bundle:nil] forCellReuseIdentifier:ProfitCellId];
    [tableView registerNib:[UINib nibWithNibName:ProfitFooterId bundle:nil] forHeaderFooterViewReuseIdentifier:ProfitFooterId];
    [tableView registerNib:[UINib nibWithNibName:ProfitHeaderId bundle:nil] forHeaderFooterViewReuseIdentifier:ProfitHeaderId];
    tableView.dataSource = self;
    tableView.delegate = self;
    _tableView = tableView;
        
    return self;
}

- (void)setType:(DashenBoardType)type {
    _type = type;
    
    [self requestYinliRank];
    if (self.delegate) {
        [self.delegate didSetupDataGetTableHeight:(618.0)];
    }
}


- (NSArray *)fakeData {
    return @[@[@"12:30", @"欧洲厅 D008桌", @"3,123,123", @"12:30:42"],
             @[@"fxxx23", @"赌神", @"3,123,123", @"12:30:42"],
             @[@"fxxx23", @"赌圣", @"3,123,123", @"12:30:42"],
             @[@"fxxx23", @"赌王", @"3,123,123", @"12:30:42"],
             @[@"fxxx23", @"赌霸", @"3,123,123", @"12:30:42"],
             @[@"fxxx23", @"赌侠", @"3,123,123", @"12:30:42"],
             @[@"fxxx23", @"VIP1", @"123,123", @"12:30:42"],
             @[@"fxxx23", @"VIP1", @"123,123", @"12:30:42"],
             @[@"fxxx23", @"VIP1", @"123,123", @"12:30:42"],
             @[@"fxxx23", @"VIP1", @"123,123", @"12:30:42"]];

}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSBProfitBoardCell *cell = (DSBProfitBoardCell*)[tableView dequeueReusableCellWithIdentifier:ProfitCellId];
//    [cell setupIndexRow:indexPath.row dataArr:self.fakeData[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyLog(@"点了%@", indexPath);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DSBProfitHeader *header = (DSBProfitHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ProfitHeaderId];
    //TODO: =
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 309;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DSBProfitFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ProfitFooterId];
    //TODO: =
    return footer;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80;
}


#pragma mark - Request

/// 盈利榜
- (void)requestYinliRank {

    // 1小时内?
//    NSString *beginDate = [[[NSDate date] jk_dateBySubtractingHours:1] jk_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *endDate = [[NSDate date] jk_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *beginDate = [[[NSDate date] jk_startOfMonth] jk_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *endDate = [[[NSDate date] jk_endOfMonth] jk_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [DashenBoardRequest requestProfitPageNo:1 beginDate:beginDate endDate:endDate handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            //TODO:
        }
    }];
}

@end
