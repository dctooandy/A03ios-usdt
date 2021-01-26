//
//  DSBProfitBoardDataSource.m
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "DSBProfitBoardDataSource.h"
#import "DSBProfitBoardCell.h"
#import "DSBProfitFooter.h"
#import "DSBProfitHeader.h"
#import "DashenBoardRequest.h"
#import "HYInGameHelper.h"

NSString *const ProfitCellId = @"DSBProfitBoardCell";
NSString *const ProfitFooterId = @"DSBProfitFooter";
NSString *const ProfitHeaderId = @"DSBProfitHeader";

@interface DSBProfitBoardDataSource () <UITableViewDelegate, UITableViewDataSource>

@property (weak,nonatomic) id<DashenBoardAutoHeightDelegate> delegate; // 高度代理
@property (weak,nonatomic) UITableView *tableView;

// 请求一次就好了
@property (strong,nonatomic) NSArray <DSBProfitBoardUsrModel *> *usrModels;

@end

@implementation DSBProfitBoardDataSource

- (instancetype)initWithDelegate:(id)delegate TableView:(UITableView *)tableView{
    
    self = [super init];
    _delegate = delegate;
    _curPage = 0;
    
    // setup tableview
    tableView.backgroundColor = kHexColor(0x1C1B34);
    [tableView registerNib:[UINib nibWithNibName:ProfitCellId bundle:nil] forCellReuseIdentifier:ProfitCellId];
    [tableView registerNib:[UINib nibWithNibName:ProfitFooterId bundle:nil] forHeaderFooterViewReuseIdentifier:ProfitFooterId];
    [tableView registerNib:[UINib nibWithNibName:ProfitHeaderId bundle:nil] forHeaderFooterViewReuseIdentifier:ProfitHeaderId];
    tableView.dataSource = self;
    tableView.delegate = self;
    _tableView = tableView;
    
    // setup timer
    // GCD定时器
    static dispatch_source_t _timer;
    //设置时间间隔 30 分钟
    NSTimeInterval period = 60*5.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestYinliRank];
        });
    });
    // 开启定时器
    dispatch_resume(_timer);

        
    return self;
}

- (void)setType:(DashenBoardType)type {
    _type = type;
    
//    [self requestYinliRank];
    if (self.delegate) {
        [self.delegate didSetupDataGetTableHeight:(626.0)];
    }
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DSBProfitBoardUsrModel *usr = self.usrModels[_curPage];
    return usr.prList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSBProfitBoardCell *cell = (DSBProfitBoardCell*)[tableView dequeueReusableCellWithIdentifier:ProfitCellId];
    DSBProfitBoardUsrModel *usr = self.usrModels[_curPage];
    PrListItem *item = usr.prList[indexPath.row];
    [cell setupPrListItem:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;//固定
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MyLog(@"点了%@", indexPath);
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DSBProfitHeader *header = (DSBProfitHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:ProfitHeaderId];
    //TODO: =
    
    //user
    DSBProfitBoardUsrModel *usr = self.usrModels[_curPage];
    header.nameLbl.text = usr.loginName;
    header.tableCodeLbl.text = [NSString stringWithFormat:@"经典百家乐 D051桌"];//动态表单取
    header.rankLbl.text = usr.writtenLevel;
    header.profitCucLbl.text = [NSString stringWithFormat:@"%@%@",
                                [usr.cusAmountSum jk_toDisplayNumberWithDigit:2],
                                usr.prList[0].currency.lowercaseString];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 309;//固定
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DSBProfitBoardUsrModel *usr = self.usrModels[_curPage];
    
    DSBProfitFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ProfitFooterId];
    if (usr.prList.count == 0) {
        footer.isUsrOnline = NO;
        footer.btmBtnClikBlock = ^{
        };
    } else {
        footer.isUsrOnline = usr.prList[0].isOnline;
        footer.btmBtnClikBlock = ^{
            NSString *tuij = @"D051";//动态表单取
            [[HYInGameHelper sharedInstance] inBACGameTableCode:tuij];
        };
    }
    return footer;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 88;//固定
}


#pragma mark - Request

/// 盈利榜
- (void)requestYinliRank {

    [DashenBoardRequest requestProfitPageNo:1 handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *orgData = responseObj[@"data"];
            self.usrModels = [DSBProfitBoardUsrModel cn_parse:orgData];
            [self.tableView reloadData];
        }
    }];
        
}


#pragma mark - Setter
- (void)setCurPage:(NSInteger)curPage {
    if (!self.usrModels.count) {
        return;
    }
    
    if (curPage < 0) {
        curPage = self.usrModels.count - 1;
    } else if (curPage > self.usrModels.count) {
        curPage = 0;
    }
    MyLog(@"CURPAGE:%ld", curPage);
    _curPage = curPage;
    
    [self.tableView reloadData];
    [LoadingView hideLoadingViewForView:self.tableView];
}


@end
