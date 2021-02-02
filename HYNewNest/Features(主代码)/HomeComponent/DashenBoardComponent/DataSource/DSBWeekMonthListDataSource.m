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
#import "DashenBoardRequest.h"
#import "DSBRecharWithdrwUsrModel.h"

NSString *const listCellID = @"DSBWeekMonthListCell";

@interface DSBWeekMonthListDataSource () <UITableViewDelegate, UITableViewDataSource>
//{
//    NSTimeInterval _lastReqTimeWeekly;
//    NSTimeInterval _lastReqtimeMonthly;
//}
@property (weak,nonatomic) id<DashenBoardAutoHeightDelegate> delegate; // 高度代理
@property (weak,nonatomic) UITableView *tableView;

@property (strong,nonatomic) DSBWeekMonthModel *weekRank;
@property (strong,nonatomic) DSBWeekMonthModel *monthRank;
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

- (void)setType:(DashenBoardType)type {
    _type = type;
    
    if (type == DashenBoardTypeWeekBoard) {
        [self requestChampionRankWeekly];
    } else {
        [self requestChampionRankMonthly];
    }
    
    if (self.delegate) {
        [self.delegate didSetupDataGetTableHeight:(250.0)];
    }
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSBWeekMonthListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellID];
    DSBWeekMonthModel *main;
    if (self.type == DashenBoardTypeWeekBoard) {
        main = self.weekRank;
    }else{
        main = self.monthRank;
    }
    
    if (indexPath.row == 0) {
        NSArray *models = main.ljyl;
        if (models.count) {
            DSBRecharWithdrwUsrModel *usr = models[0];
            [cell setupDataArr:@[@"累计盈利冠军", usr.loginName, [usr.cusAmountSum?:@0 jk_toDisplayNumberWithDigit:0]]];
        } else {
            [cell setupDataArr:@[@"累计盈利冠军", @"--", @"--"]];
        }
    } else if (indexPath.row == 1) {
        NSArray *models = main.dbyl;
        if (models.count) {
            DSBRecharWithdrwUsrModel *usr = models[0];
            [cell setupDataArr:@[@"单笔盈利冠军", usr.loginName, [usr.cusAmount?:@0 jk_toDisplayNumberWithDigit:0]]];
        } else {
            [cell setupDataArr:@[@"单笔盈利冠军", @"--", @"--"]];
        }
    } else if (indexPath.row == 2) {
        NSArray *models = main.cz;
        if (models.count) {
            DSBRecharWithdrwUsrModel *usr = models[0];
            [cell setupDataArr:@[@"充值冠军", usr.loginName, [usr.totalAmount?:@0 jk_toDisplayNumberWithDigit:0]]];
        } else {
            [cell setupDataArr:@[@"充值冠军", @"--", @"--"]];
        }
    } else if (indexPath.row == 3) {
        NSArray *models = main.tx;
        if (models.count) {
            DSBRecharWithdrwUsrModel *usr = models[0];
            [cell setupDataArr:@[@"提现冠军", usr.loginName, [usr.totalAmount?:@0 jk_toDisplayNumberWithDigit:0]]];
        } else {
            [cell setupDataArr:@[@"提现冠军", @"--", @"--"]];
        }
    } else {
        NSArray *models = main.xm;
        if (models.count) {
            DSBRecharWithdrwUsrModel *usr = models[0];
            [cell setupDataArr:@[@"洗码冠军", usr.loginName, [usr.totalAmount1?:@0 jk_toDisplayNumberWithDigit:0]]];
        } else {
            [cell setupDataArr:@[@"洗码冠军", @"--", @"--"]];
        }
    }
    cell.btmLine.hidden = indexPath.row == 4;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyLog(@"点了%@", indexPath);
    DSBWeekMonthModel *main;
    NSString *front;
    if (self.type == DashenBoardTypeWeekBoard) {
        main = self.weekRank;
        front = @"周";
    } else {
        main = self.monthRank;
        front = @"月";
    }
    if (indexPath.row == 0) {
        [HYDSBSlideUpView showSlideupView:main.ljyl title:[front stringByAppendingString:@"累计盈利"]];
    } else if (indexPath.row == 1) {
        [HYDSBSlideUpView showSlideupView:main.dbyl title:[front stringByAppendingString:@"单笔盈利"]];
    } else if (indexPath.row == 2) {
        [HYDSBSlideUpView showSlideupView:main.cz title:[front stringByAppendingString:@"充值"]];
    } else if (indexPath.row == 3) {
        [HYDSBSlideUpView showSlideupView:main.tx title:[front stringByAppendingString:@"提现"]];
    } else if (indexPath.row == 4) {
        [HYDSBSlideUpView showSlideupView:main.xm title:[front stringByAppendingString:@"洗码"]];
    }
}


#pragma mark - Request

/// 周冠军数据
- (void)requestChampionRankWeekly {
    if (self.weekRank) {
        [self.tableView reloadData];
    } else {
        [DashenBoardRequest requestDashenBoredType:DashenBoredReqTypeTotalWeek handler:^(id responseObj, NSString *errorMsg) {
            if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
                DSBWeekMonthModel *model = [DSBWeekMonthModel cn_parse:responseObj];
                self.weekRank = model;
                [self.tableView reloadData];
            }
        }];
    }
}

/// 月冠军数据
- (void)requestChampionRankMonthly {
    if (self.monthRank) {
        [self.tableView reloadData];
    } else {
        [DashenBoardRequest requestDashenBoredType:DashenBoredReqTypeTotalMonth handler:^(id responseObj, NSString *errorMsg) {
            if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
                DSBWeekMonthModel *model = [DSBWeekMonthModel cn_parse:responseObj];
                self.monthRank = model;
                [self.tableView reloadData];
            } else {
                [self performSelector:@selector(requestChampionRankMonthly) withObject:nil afterDelay:3];
            }
        }];
    }
}


@end
