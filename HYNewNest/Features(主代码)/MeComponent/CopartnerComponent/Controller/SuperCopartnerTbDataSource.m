//
//  SuperCopartnerTbDataSource.m
//  HYNewNest
//
//  Created by zaky on 12/17/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "SuperCopartnerTbDataSource.h"
#import "SuperCopartnerTbHeader.h"
#import "SuperCopartnerTbFooter.h"
#import "SuperCopartnerTbCell.h"
#import "CNSuperCopartnerRequest.h"
#import "VIPRankConst.h"
#import <MJRefresh.h>

NSString * const SCTbHeader = @"SuperCopartnerTbHeader";
NSString * const SCTbFooter = @"SuperCopartnerTbFooter";
NSString * const SCTbCellID = @"SuperCopartnerTbCell";

@interface SuperCopartnerTbDataSource()
{
    NSInteger _pageNoMyBonus;
//    NSInteger _pageNoMyRecommen;
    NSInteger _pageNoMyRebate;
}

@property (nonatomic, weak) UITableView *tableView;
@property (assign,nonatomic) SuperCopartnerType formType;
@property (assign,nonatomic) BOOL isHome; //!<是否首页 限制数量
@property (assign,nonatomic) BOOL isHasBonus;

@property (nonatomic, strong) SCBetRankModel *betRankModel;
@property (nonatomic, strong) SCMyBonusModel *myBonusModel;
//@property (strong,nonatomic) NSArray<SCMyRecommenModel *> *myRecommenModels;
@property (strong,nonatomic) SCMyRebateModel *myRebateModel;
@end

@implementation SuperCopartnerTbDataSource

- (instancetype)initWithTableView:(UITableView *)tableView type:(SuperCopartnerType)type isHomePage:(BOOL)isHome {
    self = [super init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[SuperCopartnerTbHeader class] forHeaderFooterViewReuseIdentifier:SCTbHeader];
    [tableView registerNib:[UINib nibWithNibName:SCTbFooter bundle:nil] forHeaderFooterViewReuseIdentifier:SCTbFooter];
    [tableView registerClass:[SuperCopartnerTbCell class] forCellReuseIdentifier:SCTbCellID];
    
    _pageNoMyBonus = 1;
//    _pageNoMyRecommen = 1;
    _pageNoMyRebate = 1;
    _tableView = tableView;
    _isHome = isHome;
    self.formType = type;
    
    return self;
}

- (void)changeType:(SuperCopartnerType)type {
    self.formType = type;
}

- (void)setFormType:(SuperCopartnerType)formType {
    _formType = formType;
    
    switch (formType) {
        case SuperCopartnerTypeMyBonus:
            [self queryMyBonus];
            break;
//        case SuperCopartnerTypeMyRecommen:
//            [self queryMyRecommen];
//            break;
        case SuperCopartnerTypeCumuBetRank:
            [self queryBetRankList];
            break;
        case SuperCopartnerTypeMyXimaRebate:
            [self queryMyRebate];
            break;
        default:
            [self.tableView reloadData];
            break;
    }
}


#pragma mark - MAIN

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SuperCopartnerTbHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SCTbHeader];
    view.headType = self.formType;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.formType == SuperCopartnerTypeSXHBonus || self.formType == SuperCopartnerTypeStarGifts || self.formType == SuperCopartnerTypeMyXimaRebate) {
        SuperCopartnerTbFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SCTbFooter];
        [view setupFootType:self.formType];
        return view;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.formType == SuperCopartnerTypeSXHBonus || self.formType == SuperCopartnerTypeStarGifts || self.formType == SuperCopartnerTypeMyXimaRebate) {
        return 42;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.isHome) {
        if (self.formType == SuperCopartnerTypeSXHBonus) {
            return 6;
            
        } else if (self.formType == SuperCopartnerTypeStarGifts) {
            return 9;
            
        } else if (self.formType == SuperCopartnerTypeCumuBetRank) {
            return self.betRankModel.result.count?:10;
            
//        } else if (self.formType == SuperCopartnerTypeMyRecommen) {
//            return self.myRecommenModels.count;
            
        } else if (self.formType == SuperCopartnerTypeMyBonus) {
            return self.myBonusModel.result.count?:5;
         
        } else if (self.formType == SuperCopartnerTypeMyXimaRebate) {
            return self.myRebateModel.result.count?:5;
            
        } else {
            return 0;
        }
        
    // 弹窗出来的
//    } else {
//        if (self.formType == SuperCopartnerTypeMyBonus) {
//            return self.myBonusModel.result.count?:10;
//        }
//        if (self.formType == SuperCopartnerTypeMyRecommen) {
//            return self.myRecommenModels.count?:10;
//        }
//        return 0;
//    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SuperCopartnerTbCell *cell = (SuperCopartnerTbCell *)[tableView dequeueReusableCellWithIdentifier:SCTbCellID];
    cell.backgroundColor = [UIColor clearColor];
    
    switch (self.formType) {
        case SuperCopartnerTypeMyXimaRebate:
        {
            if (self.myRebateModel.result.count > 0) {
                MyRebateResultItem *item = self.myRebateModel.result[indexPath.row];
                NSArray *arr = @[item.loginName,
                                 item.upLevelStr,
                                 [item.totalBet jk_toDisplayNumberWithDigit:0],
                                 [item.commission jk_toDisplayNumberWithDigit:0]];
                [cell setupType:_formType strArr:arr];
            } else {
                [cell setupType:_formType strArr:@[@"--", @"--", @"--", @"--"]];
            }
            break;
        }
        case SuperCopartnerTypeMyBonus:
        {
            if (self.myBonusModel.result.count > 0) {
                MyBonusResultItem *item = self.myBonusModel.result[indexPath.row];
                NSDate *matuDate = [NSDate jk_dateWithString:item.maturityDate format:@"yyyy-MM-dd HH:mm:ss"];
                NSInteger day = [matuDate jk_distanceDaysToDate:[NSDate date]];
                NSString *dayStr = [NSString stringWithFormat:@"%ld天", day];
                NSArray *arr = @[item.loginName,
                                 item.upLevelStr,
                                 item.createdDate,
                                 item.amount,
                                 item.flag==2?dayStr:@"已领取"];
                [cell setupType:_formType strArr:arr];
            } else {
                [cell setupType:_formType strArr:@[@"--", @"--", @"--", @"--", @"--"]];
            }
            break;
        }
//        case SuperCopartnerTypeMyRecommen:
//        {
//            if (self.myRecommenModels.count > 0) {
//                SCMyRecommenModel *model = self.myRecommenModels[indexPath.row];
////                NSString *rankName = VIPRankString[model.clubLevel];
//                [cell setupType:self.formType strArr:@[model.loginName, model.customerLevel, model.createdDate, @"888", @"30天"]];
//            } else {
//                [cell setupType:_formType strArr:@[@"--", @"--", @"--", @"--", @"--"]];
//            }
//            break;
//        }
        case SuperCopartnerTypeCumuBetRank:
        {
            if (self.betRankModel) {
                BetRankResultItem *item = self.betRankModel.result[indexPath.row];
                float amount = [item.prizeAmount floatValue];
                NSNumber *num = [NSNumber numberWithFloat:amount];
                NSArray *arr = @[item.ranking, item.loginName, [num jk_toDisplayNumberWithDigit:2], item.downlineCount];
                [cell setupType:self.formType strArr:arr];
            }
            break;
        }
        case SuperCopartnerTypeSXHBonus:
        {
            if (indexPath.row == 0) {
                [cell setupType:self.formType strArr:@[@"赌尊", @"57,142,000", @"9888"]];
            } else if (indexPath.row == 1) {
                [cell setupType:self.formType strArr:@[@"赌神", @"28,571,000", @"5588"]];
            } else if (indexPath.row == 2) {
                [cell setupType:self.formType strArr:@[@"赌圣", @"14,285,000", @"2388"]];
            } else if (indexPath.row == 3) {
                [cell setupType:self.formType strArr:@[@"赌王", @"7,142,000", @"858"]];
            } else if (indexPath.row == 4) {
                [cell setupType:self.formType strArr:@[@"赌霸", @"2,857,000", @"568"]];
            } else if (indexPath.row == 5) {
                [cell setupType:self.formType strArr:@[@"赌侠", @"1,428,000", @"268"]];
            }
            break;
        }
        case SuperCopartnerTypeStarGifts:
        {
            if (indexPath.row == 0) {
                [cell setupType:self.formType strArr:@[@"VIP10", @"7,100,000", @"858"]];
            } else if (indexPath.row == 1) {
                [cell setupType:self.formType strArr:@[@"VIP9", @"2,800,00", @"418"]];
            } else if (indexPath.row == 2) {
                [cell setupType:self.formType strArr:@[@"VIP8", @"1,400,000", @"268"]];
            } else if (indexPath.row == 3) {
                [cell setupType:self.formType strArr:@[@"VIP7", @"1,000,000", @"128"]];
            } else if (indexPath.row == 4) {
                [cell setupType:self.formType strArr:@[@"VIP6", @"710,000", @"116"]];
            } else if (indexPath.row == 5) {
                [cell setupType:self.formType strArr:@[@"VIP5", @"420,000", @"98"]];
            } else if (indexPath.row == 6) {
                [cell setupType:self.formType strArr:@[@"VIP4", @"140,000", @"56"]];
            } else if (indexPath.row == 7) {
                [cell setupType:self.formType strArr:@[@"VIP3", @"71,000", @"38"]];
            } else if (indexPath.row == 8) {
                [cell setupType:self.formType strArr:@[@"VIP2", @"14,000", @"13"]];
            }
            break;
        }
        default:
            break;
    }
    return cell;
}


#pragma mark - REQUEST
- (void)queryMyBonus {
    if (![CNUserManager shareManager].isLogin || (_isHome && self.myBonusModel.result.count)) { //一页
        [self.tableView reloadData];
    } else {
        [CNSuperCopartnerRequest requestSuperCopartnerListType:SuperCopartnerTypeMyBonus pageNo:_pageNoMyBonus handler:^(id responseObj, NSString *errorMsg) {
            if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
                SCMyBonusModel *newModel = [SCMyBonusModel cn_parse:responseObj];
                if (newModel.result.count) {
                    self->_pageNoMyBonus += 1;
                }
                NSMutableArray *oldResult = self.myBonusModel?self.myBonusModel.result.mutableCopy:@[].mutableCopy;
                [oldResult addObjectsFromArray:newModel.result];
                newModel.result = oldResult.copy;
                self.myBonusModel = newModel;

                self.isHasBonus = self.myBonusModel.receivedAmount.integerValue > 0;
                [self.tableView reloadData];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceReceivedMyBonus:)]) {
                    [self.delegate dataSourceReceivedMyBonus:newModel];
                }
            }
        }];
    }
}

- (void)queryMyRebate {
    [CNSuperCopartnerRequest requestSuperCopartnerListType:SuperCopartnerTypeMyXimaRebate pageNo:_pageNoMyRebate handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            SCMyRebateModel *newModel = [SCMyRebateModel cn_parse:responseObj];
            if (newModel.result.count) {
                self->_pageNoMyRebate += 1;
            }
            NSMutableArray *oldResult = self.myBonusModel?self.myBonusModel.result.mutableCopy:@[].mutableCopy;
            [oldResult addObjectsFromArray:newModel.result];
            newModel.result = oldResult.copy;
            self.myRebateModel = newModel;

            [self.tableView reloadData];

            if (self.delegate && [self.delegate respondsToSelector:@selector(dataSourceReceivedMyRebate:)]) {
                [self.delegate dataSourceReceivedMyRebate:newModel.weekEstimate];
            }
        }
    }];
}

//- (void)queryMyRecommen {
//
//    [CNSuperCopartnerRequest requestSuperCopartnerListType:SuperCopartnerTypeMyRecommen pageNo:_pageNoMyRecommen handler:^(id responseObj, NSString *errorMsg) {
//        if (!errorMsg && [responseObj isKindOfClass:[NSArray class]]) {
//            NSMutableArray *arr = self.myRecommenModels.count?self.myRecommenModels.mutableCopy:@[].mutableCopy;
//            if (arr.count) {
//                self->_pageNoMyRecommen += 1;
//            }
//            NSArray *arrrr = [SCMyRecommenModel cn_parse:responseObj];
//            [arr addObjectsFromArray:arrrr];
//            self.myRecommenModels = arr.copy;
//            [self.tableView reloadData];
//        }
//        [self.tableView.mj_footer endRefreshing];
//    }];
//}

//- (void)queryMyPrize {
//    [CNSuperCopartnerRequest requestSuperCopartnerListType:SuperCopartnerTypeMyGifts pageNo:_pageNoMyGifts handler:^(id responseObj, NSString *errorMsg) {
//        //TODO: =
//        [self.tableView reloadData];
//    }];
//}

- (void)queryBetRankList {
    [CNSuperCopartnerRequest requestSuperCopartnerListBetRankHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            self.betRankModel = [SCBetRankModel cn_parse:responseObj];
//            if (self.delegate) {
//                [self.delegate didReceiveCumulateBetAmount:self.betRankModel.totalDownlineBet];
//            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
