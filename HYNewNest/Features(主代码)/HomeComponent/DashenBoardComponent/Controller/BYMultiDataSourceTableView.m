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

@implementation BYMultiDataSourceTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)changeDataSourceDelegate:(id)dd type:(DashenBoardType)type {
    self.dataSource = dd;
    self.delegate = dd;
    [dd setValue:@(type) forKey:@"type"];
}

@end
