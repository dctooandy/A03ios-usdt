//
//  BYMultiDataSourceTableView.m
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "BYMultiDataSourceTableView.h"
//#import "DSBProfitBoardDataSource.h"

@interface BYMultiDataSourceTableView ()
@property (nonatomic, assign, readwrite) DashenBoardType type;
//@property (weak,nonatomic) id dd;
@end

@implementation BYMultiDataSourceTableView

/// 每次切换需要重新设置数据源代理 否则数据源不切换
- (void)changeDataSourceDelegate:(id)dd type:(DashenBoardType)type {
    self.dataSource = dd;
    self.delegate = dd;
//    self.dd = dd;
    self.type = type;
    [dd setValue:@(type) forKey:@"type"];
}

@end
