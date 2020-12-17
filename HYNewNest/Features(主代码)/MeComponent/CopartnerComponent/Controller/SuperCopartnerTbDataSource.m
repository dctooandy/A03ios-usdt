//
//  SuperCopartnerTbDataSource.m
//  HYNewNest
//
//  Created by zaky on 12/17/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "SuperCopartnerTbDataSource.h"
#import "SuperCopartnerTbHeader.h"
#import "SuperCopartnerTbCell.h"

NSString * const SCTbHeader = @"SuperCopartnerTbHeader";
NSString * const SCTbCellID = @"SuperCopartnerTbCell"; //0

@interface SuperCopartnerTbDataSource()

@property (nonatomic, weak) UITableView *tableView;
@property (assign,nonatomic) SuperCopartnerType formType;
@end

@implementation SuperCopartnerTbDataSource

- (instancetype)initWithTableView:(UITableView *)tableView type:(SuperCopartnerType)type {
    self = [super init];
    self.formType = type;
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[SuperCopartnerTbHeader class] forHeaderFooterViewReuseIdentifier:SCTbHeader];
    [tableView registerClass:[SuperCopartnerTbCell class] forCellReuseIdentifier:SCTbCellID];
    
    return self;
}

- (void)changeType:(SuperCopartnerType)type {
    _formType = type;
    
    //TODO: 刷新数据源
    [self.tableView reloadData];
}


#pragma mark - MAIN

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SuperCopartnerTbHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SCTbHeader];
    view.headType = self.formType;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.formType == SuperCopartnerTypeCumuBetRank) {
        return [UIView new];
    } else {
        //TODO:
        return [UIView new];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SuperCopartnerTbCell *cell = (SuperCopartnerTbCell *)[tableView dequeueReusableCellWithIdentifier:SCTbCellID];
//    cell.backgroundColor = KRandomColor;
    
    //TODO:=
    [cell setupType:self.formType strArr:@[]];
    
    return cell;
}



@end
