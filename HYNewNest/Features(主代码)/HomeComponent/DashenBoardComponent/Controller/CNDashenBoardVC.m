//
//  CNDashenBoardVC.m
//  HYNewNest
//
//  Created by zaky on 12/3/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNDashenBoardVC.h"
#import "DSBHeaderSelectionView.h"

#import "DashenBoardRequest.h"
#import "DSBWeekMonthListDataSource.h"
#import "DSBRecharWithdrwRankDataSource.h"

@interface CNDashenBoardVC () <DashenBoardAutoHeightDelegate>
@property (weak, nonatomic) IBOutlet DSBHeaderSelectionView *headerSelecView;

@property (nonatomic, strong) DSBWeekMonthListDataSource *mlTbDataSource;
@property (strong,nonatomic) DSBRecharWithdrwRankDataSource *rwTbDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHCons;
@property (assign, readwrite, nonatomic) CGFloat totalHeight;

@end

@implementation CNDashenBoardVC
@synthesize totalHeight = _totalHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self requestRankRecharge];
//    [self requestRankWithdraw];
    
//    [self requestChampionRankWeekly];
//    [self requestChampionRankMonthly];
    
//    [self requestYinliRank];
    
    // 周榜月榜
    _mlTbDataSource = [[DSBWeekMonthListDataSource alloc] initWithDelegate:self TableView:_tableView type:DashenBoardTypeWeekBoard];
    // 充值提现
    _rwTbDataSource = [[DSBRecharWithdrwRankDataSource alloc] initWithDelegate:self TableView:_tableView type:DashenBoardTypeRechargeBoard];
    
    WEAKSELF_DEFINE
    _headerSelecView.didTapBtnBlock = ^(NSString * _Nonnull rankName) {
        STRONGSELF_DEFINE
        if ([rankName containsString:@"大神"]) {
            
        } else if ([rankName containsString:@"充值"]) {
            [strongSelf.rwTbDataSource setType:DashenBoardTypeRechargeBoard];
        } else if ([rankName containsString:@"提现"]) {
            [strongSelf.rwTbDataSource setType:DashenBoardTypeWithdrawBoard];
        } else if ([rankName containsString:@"周总"]) {
            [strongSelf.mlTbDataSource setType:DashenBoardTypeWeekBoard];
        } else {
            [strongSelf.mlTbDataSource setType:DashenBoardTypeMonthBoard];
        }
    };
    
    // 默认调用一个数据源 来设定_tableViewHCons高度并触发代理回调
    [self.rwTbDataSource setType:DashenBoardTypeRechargeBoard];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_tableView jk_setRoundedCorners:UIRectCornerAllCorners radius:AD(10)];
    _tableView.layer.masksToBounds = YES;
}


#pragma mark - UI

- (void)didSetupDataGetTableHeight:(CGFloat)tableHeight {
    
    _tableViewHCons.constant = tableHeight;
    
    if (self.delegate) {
        [self.delegate didSetupDataGetTableHeight:(tableHeight + 100.0)];
    }
}


#pragma mark - Request

/// 充值榜数据
- (void)requestRankRecharge {
    [DashenBoardRequest requestDashenBoredType:DashenBoredReqTypeRecharge handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            NSArray *usrArr = [DSBRecharWithdrwUsrModel cn_parse:orgData];
            //TODO:
        }
    }];
}

/// 提现榜数据
- (void)requestRankWithdraw {
    [DashenBoardRequest requestDashenBoredType:DashenBoredReqTypeWithdraw handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            NSArray *usrArr = [DSBRecharWithdrwUsrModel cn_parse:orgData];
            //TODO:
        }
    }];
}

/// 周冠军数据
- (void)requestChampionRankWeekly {
    [DashenBoardRequest requestDashenBoredType:DashenBoredReqTypeTotalWeek handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            //TODO:
        }
    }];
}

/// 月冠军数据
- (void)requestChampionRankMonthly {
    [DashenBoardRequest requestDashenBoredType:DashenBoredReqTypeTotalMonth handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            //TODO:
        }
    }];
}

/// 盈利榜
- (void)requestYinliRank {
    
    // 1小时内?
    NSString *beginDate = [[[NSDate date] jk_dateBySubtractingHours:1] jk_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *endDate = [[NSDate date] jk_dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [DashenBoardRequest requestProfitPageNo:1 beginDate:beginDate endDate:endDate handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            //TODO:
        }
    }];
}

@end
