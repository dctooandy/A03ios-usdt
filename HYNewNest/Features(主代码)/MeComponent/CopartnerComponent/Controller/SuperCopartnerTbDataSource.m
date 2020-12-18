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

NSString * const SCTbHeader = @"SuperCopartnerTbHeader";
NSString * const SCTbFooter = @"SuperCopartnerTbFooter";
NSString * const SCTbCellID = @"SuperCopartnerTbCell";

@interface SuperCopartnerTbDataSource()

@property (nonatomic, weak) UITableView *tableView;
@property (assign,nonatomic) SuperCopartnerType formType;
@property (assign,nonatomic) BOOL isHome; //!<是否首页 限制数量
@end

@implementation SuperCopartnerTbDataSource

- (instancetype)initWithTableView:(UITableView *)tableView type:(SuperCopartnerType)type isHomePage:(BOOL)isHome {
    self = [super init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[SuperCopartnerTbHeader class] forHeaderFooterViewReuseIdentifier:SCTbHeader];
    [tableView registerNib:[UINib nibWithNibName:SCTbFooter bundle:nil] forHeaderFooterViewReuseIdentifier:SCTbFooter];
    [tableView registerClass:[SuperCopartnerTbCell class] forCellReuseIdentifier:SCTbCellID];
    
    self.tableView = tableView;
    self.isHome = isHome;
    self.formType = type;
    
    return self;
}

- (void)changeType:(SuperCopartnerType)type {
    self.formType = type;
}

- (void)setFormType:(SuperCopartnerType)formType {
    _formType = formType;
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
    if (self.isHome) {
        if (self.formType == SuperCopartnerTypeCumuBetRank) {
            UILabel *lb = [UILabel new];
            lb.text = @"(数据每天凌晨刷新)";
            lb.textColor = kHexColor(0xA6A6A6);
            lb.font = [UIFont fontPFR11];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.frame = CGRectMake(0, 0, kScreenWidth - 25, 26);
            return lb;
        } else {
            SuperCopartnerTbFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SCTbFooter];
            //TODO: 假数据
            [view setupFootType:self.formType strArr:@[@1579, @14388]];
            return view;
        }
    } else {
        return [UIView new];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isHome) {
        if (self.formType == SuperCopartnerTypeCumuBetRank) {
            return 6;
        } else {
            return 5;
        }
    } else {
        return 10;//
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SuperCopartnerTbCell *cell = (SuperCopartnerTbCell *)[tableView dequeueReusableCellWithIdentifier:SCTbCellID];
    //TODO: 假数据
    [cell setupType:self.formType strArr:@[]];
    return cell;
}



@end
