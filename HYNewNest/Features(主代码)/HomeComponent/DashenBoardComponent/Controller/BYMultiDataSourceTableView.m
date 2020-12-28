//
//  BYMultiDataSourceTableView.m
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "BYMultiDataSourceTableView.h"
//#import "DSBWeekMonthListDataSource.h"
//#import "DSBRecharWithdrwRankDataSource.h"
//#import "DSBProfitBoardDataSource.h"

@interface BYMultiDataSourceTableView ()
@property (nonatomic, assign, readwrite) DashenBoardType type;
@end

@implementation BYMultiDataSourceTableView


- (void)changeDataSourceDelegate:(id)dd type:(DashenBoardType)type {
    self.dataSource = dd;
    self.delegate = dd;
    self.type = type;
    [dd setValue:@(type) forKey:@"type"];
}

@end
