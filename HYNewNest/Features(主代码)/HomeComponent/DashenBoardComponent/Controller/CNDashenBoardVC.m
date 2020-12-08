//
//  CNDashenBoardVC.m
//  HYNewNest
//
//  Created by zaky on 12/3/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNDashenBoardVC.h"
#import "DashenBoardRequest.h"

@interface CNDashenBoardVC ()

@end

@implementation CNDashenBoardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self requestRankRecharge];
//    [self requestRankWithdraw];
    
//    [self requestChampionRankWeekly];
//    [self requestChampionRankMonthly];
//    [self requestYinliRank];
    
}


#pragma mark - UI

- (CGFloat)totalHeight {
    return 600;
}


#pragma mark - Request

/// 充值榜数据
- (void)requestRankRecharge {
    [DashenBoardRequest requestDashenBoredType:DashenBoredTypeRecharge handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            NSArray *usrArr = [DSBRecharWithdrwUsrModel cn_parse:orgData];
            //TODO:
        }
    }];
}

/// 提现榜数据
- (void)requestRankWithdraw {
    [DashenBoardRequest requestDashenBoredType:DashenBoredTypeWithdraw handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            NSArray *usrArr = [DSBRecharWithdrwUsrModel cn_parse:orgData];
            //TODO:
        }
    }];
}

/// 周冠军数据
- (void)requestChampionRankWeekly {
    [DashenBoardRequest requestDashenBoredType:DashenBoredTypeTotalWeek handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            //TODO:
        }
    }];
}

/// 月冠军数据
- (void)requestChampionRankMonthly {
    [DashenBoardRequest requestDashenBoredType:DashenBoredTypeTotalMonth handler:^(id responseObj, NSString *errorMsg) {
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
