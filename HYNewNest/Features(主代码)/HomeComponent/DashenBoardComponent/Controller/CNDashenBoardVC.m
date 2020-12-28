//
//  CNDashenBoardVC.m
//  HYNewNest
//
//  Created by zaky on 12/3/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNDashenBoardVC.h"
#import "DSBHeaderSelectionView.h"
#import "BYMultiDataSourceTableView.h"

#import "DashenBoardRequest.h"
#import "DSBWeekMonthListDataSource.h"
#import "DSBRecharWithdrwRankDataSource.h"
#import "DSBProfitBoardDataSource.h"

@interface CNDashenBoardVC () <DashenBoardAutoHeightDelegate>
@property (weak, nonatomic) IBOutlet DSBHeaderSelectionView *headerSelecView;

@property (nonatomic, strong) DSBWeekMonthListDataSource *mlTbDataSource;
@property (strong,nonatomic) DSBRecharWithdrwRankDataSource *rwTbDataSource;
@property (strong,nonatomic) DSBProfitBoardDataSource *proTbDataSource;
@property (weak, nonatomic) IBOutlet BYMultiDataSourceTableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHCons;
@property (assign, readwrite, nonatomic) CGFloat totalHeight;
@property (weak, nonatomic) IBOutlet UILabel *btmLabel;

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
    
    // 滑动手势
    UISwipeGestureRecognizer *swipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeftRight:)];
    swipGes.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [_tableView addGestureRecognizer:swipGes];
    
    // 周榜月榜
    _mlTbDataSource = [[DSBWeekMonthListDataSource alloc] initWithDelegate:self TableView:_tableView type:DashenBoardTypeWeekBoard];
    // 充值提现
    _rwTbDataSource = [[DSBRecharWithdrwRankDataSource alloc] initWithDelegate:self TableView:_tableView type:DashenBoardTypeRechargeBoard];
    // 盈利榜
    _proTbDataSource = [[DSBProfitBoardDataSource alloc] initWithDelegate:self TableView:_tableView];
    
    // 头部点击回调
    WEAKSELF_DEFINE
    _headerSelecView.didTapBtnBlock = ^(NSString * _Nonnull rankName) {
        STRONGSELF_DEFINE
        
        if ([rankName containsString:@"大神"]) {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.proTbDataSource type:DashenBoardTypeProfitBoard];
            strongSelf.btmLabel.text = @"大神榜为当天百家乐数据，每5分钟刷新一次";
            
        } else if ([rankName containsString:@"充值"]) {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.rwTbDataSource type:DashenBoardTypeRechargeBoard];
            strongSelf.btmLabel.text = @"数据每小时刷新";
            
        } else if ([rankName containsString:@"提现"]) {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.rwTbDataSource type:DashenBoardTypeWithdrawBoard];
            strongSelf.btmLabel.text = @"数据每小时刷新";
            
        } else if ([rankName containsString:@"周总"]) {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.mlTbDataSource type:DashenBoardTypeWeekBoard];
            strongSelf.btmLabel.text = @"数据每周一凌晨更新";
            
        } else {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.mlTbDataSource type:DashenBoardTypeMonthBoard];
            strongSelf.btmLabel.text = @"数据每周一凌晨更新";
        }
    };
    
    //TODO: 默认调用一个数据源 来设定_tableViewHCons高度并触发代理回调
    [self.tableView changeDataSourceDelegate:self.proTbDataSource type:DashenBoardTypeProfitBoard];
    
}


#pragma mark - UI

- (void)didSetupDataGetTableHeight:(CGFloat)tableHeight {
    _tableViewHCons.constant = tableHeight;
    
    if (self.delegate) {
        [self.delegate didSetupDataGetTableHeight:(tableHeight + 100.0)];
    }
}


#pragma mark - UISwipeGesture

- (void)didSwipeLeftRight:(UISwipeGestureRecognizer *)swipe {
    if (_tableView.type == DashenBoardTypeProfitBoard) {
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            NSLog(@"大神榜 从左往右");
        }else{
            NSLog(@"大神榜 从右往左");
        }
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
