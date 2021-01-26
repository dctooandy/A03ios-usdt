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
#import "DSBGameRoundResModel.h"

#import "DashenBoardRequest.h"
#import "HYInGameHelper.h"
#import "SocketRocketUtility.h"
#import "BYJSONHelper.h"

NSString *const ProfitCellId = @"DSBProfitBoardCell";
NSString *const ProfitFooterId = @"DSBProfitFooter";
NSString *const ProfitHeaderId = @"DSBProfitHeader";

@interface DSBProfitBoardDataSource () <UITableViewDelegate, UITableViewDataSource>

@property (weak,nonatomic) id<DashenBoardAutoHeightDelegate> delegate; // 高度代理
@property (weak,nonatomic) UITableView *tableView;

// 请求一次就好了
@property (strong,nonatomic) NSArray <DSBProfitBoardUsrModel *> *usrModels;
// 推荐桌台
@property (copy,nonatomic) NSString *recomTableId;
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
    NSTimeInterval period = 60*10.0;
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

- (void)setupWebSocket {
//    NSString *wsURL = @"wss://roadmap.9mbv.com:7070/socket.io/?EIO=4&transport=websocket"; //https
    NSString *wsURL = @"ws://roadmap.9mbv.com:8080/socket.io/?EIO=4&transport=websocket";
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:wsURL];
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:BYWebSocketDidReceivedNoti object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSString *dictStr = note.object;
        if (dictStr.length < 10) {
            return;
        }
        NSRange startRng = [dictStr rangeOfString:@"["];
        NSString *jsonStr = [dictStr substringFromIndex:startRng.location];
        id fullArr = [BYJSONHelper dictOrArrayWithJsonString:jsonStr];
        // 如果是字典 无用数据
        if ([fullArr isKindOfClass:[NSDictionary class]]) {
            return;
        }
        // 数组只有两个参数 第二个是主要数据
        if ([fullArr[0] isEqualToString:@"result list"]) { // 所有游戏数据
            //TODO: 只保存推荐桌台数据
            MyLog(@"------------------------ save to DB");
            
        } else if ([fullArr[0] containsString:@"close round"]){ // 更新游戏数据
            //TODO: 只处理推荐桌台数据
            RoundPushModel *round = [RoundPushModel cn_parse:fullArr[1]];
            if ([self.recomTableId isEqualToString:round.vid]) {
                MyLog(@"------------------------ update DB and RefreshView");
            } else {
                MyLog(@"------------------------ drop data");
            }
        }
    }];
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
    header.tableCodeLbl.text = [NSString stringWithFormat:@"经典百家乐 %@桌", self.recomTableId];
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
            if (!self.recomTableId) {
                [CNHUB showWaiting:@"正在获取推荐桌台号.."];
                return;
            }
            [[HYInGameHelper sharedInstance] inBACGameTableCode:self.recomTableId];
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
    
    [DashenBoardRequest requestRecommendTableHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSString class]]) {
            /// 推荐桌台号
            self.recomTableId = responseObj;
            
            [DashenBoardRequest requestProfitPageNo:1 handler:^(id responseObj, NSString *errorMsg) {
                if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
                    NSArray *orgData = responseObj[@"data"];
                    self.usrModels = [DSBProfitBoardUsrModel cn_parse:orgData];
                    [self.tableView reloadData];
                    
                    // setup webSocket
                    [self setupWebSocket];
                }
            }];
        }
    }];
        
}


#pragma mark - Setter

- (void)setType:(DashenBoardType)type {
    _type = type;
    
    if (self.delegate) {
        [self.delegate didSetupDataGetTableHeight:(626.0)];
    }
}

- (void)setCurPage:(NSInteger)curPage {
    [LoadingView hideLoadingViewForView:self.tableView];
    if (!self.usrModels.count) {
        _curPage = 0;
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
}


@end
