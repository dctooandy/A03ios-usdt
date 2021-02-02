//
//  HYDSBSlideUpView.m
//  HYNewNest
//
//  Created by zaky on 12/28/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYDSBSlideUpView.h"
#import "HYDSBSlideUpViewCell.h"
#import "DSBProfitBoardCell.h"
#import <UIImageView+WebCache.h>

@interface HYDSBSlideUpView() <UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *rankList;
@property (assign,nonatomic) BOOL isYLB; //!<盈利榜
@end

@implementation HYDSBSlideUpView

+ (void)showSlideupView:(NSArray <DSBRecharWithdrwUsrModel*> *)rankList title:(NSString *)title {
    if (!rankList.count) {
        [kKeywindow jk_makeToast:@"暂无数据哦~" duration:2 position:JKToastPositionCenter];
        return;
    }
    HYDSBSlideUpView *view = [[HYDSBSlideUpView alloc] initWithContentViewHeight:479 title:@"周累计盈利" comfirmBtnText:@""];
    view.titleLbl.text = title;
    [view setupViews];
    view.rankList = rankList;
    [NNControllerHelper currentTabBarController].tabBar.hidden = YES;
}

+ (void)showSlideupYLBView:(NSArray<PrListItem *> *)usrList{
    HYDSBSlideUpView *view = [[HYDSBSlideUpView alloc] initWithContentViewHeight:479 title:@"下注历史记录" comfirmBtnText:@""];
    view.isYLB = YES;
    [view setupViews];
    view.rankList = usrList;
    [NNControllerHelper currentTabBarController].tabBar.hidden = YES;
}

- (void)setupViews {
    self.comfirmBtn.hidden = YES;
    self.contentView.backgroundColor = kHexColor(0x202238);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, AD(50), kScreenWidth, 479-AD(50))];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kHexColor(0x202238);
    if (self.isYLB) {
        [_tableView registerNib:[UINib nibWithNibName:@"DSBProfitBoardCell" bundle:nil] forCellReuseIdentifier:@"DSBProfitBoardCell"];
    } else {
        [_tableView registerNib:[UINib nibWithNibName:@"HYDSBSlideUpViewCell" bundle:nil] forCellReuseIdentifier:@"HYDSBSlideUpViewCell"];
    }
    
    [self.contentView addSubview:_tableView];
}

- (void)setRankList:(NSArray *)rankList {
    _rankList = rankList;
    [self.tableView reloadData];
}

- (void)dismiss {
    [super dismiss];
    
    [NNControllerHelper currentTabBarController].tabBar.hidden = NO;
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rankList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isYLB?115:69;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isYLB) {
        DSBProfitBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DSBProfitBoardCell"];
        PrListItem *item = self.rankList[indexPath.row];
        [cell setupPrListItem:item];
        return cell;
        
    } else {
        HYDSBSlideUpViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYDSBSlideUpViewCell"];
        cell.rankLb.text = [NSString stringWithFormat:@"%ld", (indexPath.row + 1)];
        DSBRecharWithdrwUsrModel *model = self.rankList[indexPath.row];
        cell.crownImgv.hidden = YES;
        cell.rankLb.hidden = NO;
        if (indexPath.row == 0) {
            cell.crownImgv.hidden = NO;
            cell.crownImgv.image = [UIImage imageNamed:@"rank1"];
            cell.rankLb.hidden = YES;
        } else if (indexPath.row == 1) {
            cell.crownImgv.hidden = NO;
            cell.crownImgv.image = [UIImage imageNamed:@"rank2"];
            cell.rankLb.hidden = YES;
        } else if (indexPath.row == 2) {
            cell.crownImgv.hidden = NO;
            cell.crownImgv.image = [UIImage imageNamed:@"rank3"];
            cell.rankLb.hidden = YES;
        }
        [cell.headShotImgv sd_setImageWithURL:[NSURL URLWithString:model.headshot] placeholderImage:[UIImage imageNamed:@"icon"]];
        cell.levelLb.text = model.writtenLevel;
        cell.nameLb.text = model.loginName;
        if (model.cusAmount) {
            cell.amountLb.text = [model.cusAmount jk_toDisplayNumberWithDigit:0];
        } else if (model.cusAmountSum) {
            cell.amountLb.text = [model.cusAmountSum jk_toDisplayNumberWithDigit:0];
        } else {
            cell.amountLb.text = model.totalAmount?([model.totalAmount jk_toDisplayNumberWithDigit:0]):([model.totalAmount1 jk_toDisplayNumberWithDigit:0]);
        }
        return cell;
    }
}

@end
