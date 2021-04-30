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
#import "DashenBoardRequest.h"
#import "VIPRankConst.h"

NSString *const RankCellID = @"DSBRchrWthdrwRankCell";
NSString *const HeaderID = @"DSBRchrWthdrwHeader";

@interface DSBRecharWithdrwRankDataSource()<UITableViewDelegate, UITableViewDataSource>
{
    NSTimeInterval _lastReqTimeRecharge;
    NSTimeInterval _lastReqtimeWithdraw;
}
@property (weak,nonatomic) id<DashenBoardAutoHeightDelegate> delegate; // 高度代理
@property (weak,nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSArray<DSBRecharWithdrwUsrModel *> *recharList;
@property (strong,nonatomic) NSArray<DSBRecharWithdrwUsrModel *> *wthdrwList;
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

- (void)setType:(DashenBoardType)type {
    _type = type;
    
    if (type == DashenBoardTypeRechargeBoard) {
        [self requestRankRecharge];
    } else {
        [self requestRankWithdraw];
    }
    
    if (self.delegate) {
        [self.delegate didSetupDataGetTableHeight:(636.0)];
    }
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == DashenBoardTypeRechargeBoard) {
        return self.recharList.count - 3;
    } else {
        return self.wthdrwList.count - 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSBRchrWthdrwRankCell *cell = (DSBRchrWthdrwRankCell*)[tableView dequeueReusableCellWithIdentifier:RankCellID];
    NSMutableArray *strArr;
    DSBRecharWithdrwUsrModel *model;
    NSString *time;
    if (self.type == DashenBoardTypeRechargeBoard) {
        model = self.recharList[indexPath.row + 3];
        time = [model.lastDepositDate componentsSeparatedByString:@" "].lastObject;
    } else {
        model = self.wthdrwList[indexPath.row + 3];
        time = [model.lastWithdrawalDate componentsSeparatedByString:@" "].lastObject;
    }
    NSString *rank;
    if (model.clubLevel > 1) {
        rank = VIPRankString[model.clubLevel];
    } else {
        rank = [NSString stringWithFormat:@"VIP%ld", model.customerLevel];
    }
    NSString *amount = [model.totalAmount jk_toDisplayNumberWithDigit:0];
    strArr = @[model.loginName, rank, amount, time, model.headshot].mutableCopy;
    [cell setupIndexRow:indexPath.row dataArr:strArr];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MyLog(@"点了%@", indexPath);
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    DSBRchrWthdrwHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    NSArray *models;
    if (self.type == DashenBoardTypeRechargeBoard && self.recharList.count > 2) {
        models = @[self.recharList[0], self.recharList[1], self.recharList[2]];
        [header setup123DataArr:models];
    } else if (self.type == DashenBoardTypeWithdrawBoard && self.wthdrwList.count > 2) {
        models = @[self.wthdrwList[0], self.wthdrwList[1], self.wthdrwList[2]];
        [header setup123DataArr:models];
    }
        
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 215;
}


#pragma mark - Request

/// 充值榜数据
- (void)requestRankRecharge {
    NSTimeInterval spaceTime = [[NSDate date] timeIntervalSince1970] - _lastReqTimeRecharge;
    // 已有数据 && 在一小时内
    if (self.recharList.count && spaceTime < 60*60) {
        [self.tableView reloadData];
    } else {
        [LoadingView showLoadingViewWithToView:self.tableView needMask:YES];
        [DashenBoardRequest requestDashenBoredType:DashenBoredReqTypeRecharge handler:^(id responseObj, NSString *errorMsg) {
            [LoadingView hideLoadingViewForView:self.tableView];
            if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
                NSArray *orgData = responseObj[@"data"];
                self.recharList = [DSBRecharWithdrwUsrModel cn_parse:orgData];
                if (self.recharList.count > 3) {
                    [self.tableView reloadData];
                    self->_lastReqTimeRecharge = [[NSDate date] timeIntervalSince1970];
                }
            } else {
                [self performSelector:@selector(requestRankRecharge) withObject:nil afterDelay:3];
            }
        }];
    }
}

/// 提现榜数据
- (void)requestRankWithdraw {
    NSTimeInterval spaceTime = [[NSDate date] timeIntervalSince1970] - _lastReqtimeWithdraw;
    // 已有数据 && 在一小时内
    if (self.wthdrwList.count && spaceTime < 60*60) {
        [self.tableView reloadData];
    } else {
        [LoadingView showLoadingViewWithToView:self.tableView needMask:YES];
        [DashenBoardRequest requestDashenBoredType:DashenBoredReqTypeWithdraw handler:^(id responseObj, NSString *errorMsg) {
            [LoadingView hideLoadingViewForView:self.tableView];
            if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
                NSArray *orgData = responseObj[@"data"];
                self.wthdrwList = [DSBRecharWithdrwUsrModel cn_parse:orgData];
                if (self.wthdrwList.count > 3) {
                    [self.tableView reloadData];
                    self->_lastReqtimeWithdraw = [[NSDate date] timeIntervalSince1970];
                }
            } else {
                [self performSelector:@selector(requestRankWithdraw) withObject:nil afterDelay:3];
            }
        }];
    }
}


@end
