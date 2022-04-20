//
//  CNTradeRecodeVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/28.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNTradeRecodeVC.h"
#import "segmentHeaderView.h"
#import "CNTradeRecordTCell.h"
#define kCNTradeRecordTCellID  @"CNTradeRecordTCell"

#import "CNNoDataView.h"
#import "CNRecordTypeSelectorView.h"
#import "CNRecordDetailVC.h"
#import "CNBaseNetworking.h"
#import "HYTextAlertView.h"

#import <UIImageView+WebCache.h>
#import "NSURL+HYLink.h"
#import <MJRefresh/MJRefresh.h>

#import "CNMatchDepositStatusVC.h"
#import "KYMMatchWithdrewSuccessVC.h"

@interface CNTradeRecodeVC () <segmentHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource>
// 记录类型标签
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (nonatomic, assign) NSInteger gameTypeIdx;// 0-5
// 记录时间 3 7 30
@property (weak, nonatomic) IBOutlet UILabel *dayLb;
@property (nonatomic, assign) NSInteger dayParm;
// 页码
@property (nonatomic, assign) NSInteger currentPage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) segmentHeaderView *menuView;
@property (nonatomic, copy) NSArray *titleList;
@property (nonatomic, strong) CNNoDataView *noDataView;

@property (nonatomic, strong) CreditQueryResultModel *resultModel;
@property (nonatomic, strong) NSMutableArray <CreditQueryDataModel*> *dataList;
@end

@implementation CNTradeRecodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易记录";
    self.topView.backgroundColor = self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self initHeaderView];
    [self configTableView];
    
    self.gameTypeIdx = 0;
    self.dayParm = 3;
    self.dataList = @[].mutableCopy;
    if (self.recoType == 0) {
        self.recoType = transactionRecord_rechargeType;
    }
    switch (self.recoType) {
        case transactionRecord_rechargeType:
            self.typeLb.text = [CNUserManager shareManager].isUsdtMode?@"充币":@"充值";
            break;
        case transactionRecord_XMType:
            self.typeLb.text = @"洗码";
            break;
        case transactionRecord_withdrawType:
            self.typeLb.text = [CNUserManager shareManager].isUsdtMode?@"提币":@"提现";
            break;
        case transactionRecord_activityType:
            self.typeLb.text = @"优惠领取";
            break;
        case transactionRecord_betRecordType:
            self.typeLb.text = @"投注记录";
            break;
        case transactionRecord_yuEBaoDeposit:
            self.typeLb.text = @"余额宝转入";
            break;
        case TransactionRecord_yuEBaoWithdraw:
            self.typeLb.text = @"余额宝转出";
            break;
        default:
            break;
    }
    
    [self requestNewData];
}

// 第一页数据
- (void)requestNewData {
    self.currentPage = 1;
    self.dataList = @[].mutableCopy;
    [self requestData];
}

#pragma mark - ACTION

- (IBAction)choseRecordType:(UIButton *)sender {
    [CNRecordTypeSelectorView showSelectorWithSelcType:self.recoType
                                               dayParm:self.dayParm
                                              callBack:^(NSString * _Nonnull type, NSString * _Nonnull day) {
        self.typeLb.text = type;
        self.dayLb.text = day;
        if ([day isEqualToString:@"近3天"]) {
            self.dayParm = 3;
        } else if ([day isEqualToString:@"近7天"]) {
            self.dayParm = 7;
        } else if ([day isEqualToString:@"近30天"]){
            self.dayParm = 30;
        }
        
        self.topViewHeight.constant = 0;
        self.topView.hidden = YES;
        if ([type containsString:@"充"]) {
            self.recoType = transactionRecord_rechargeType;
        } else if ([type containsString:@"提"]) {
            self.recoType = transactionRecord_withdrawType;
        } else if ([type containsString:@"洗码"]) {
            self.recoType = transactionRecord_XMType;
        } else if ([type containsString:@"优惠领取"]) {
            self.recoType = transactionRecord_activityType;
        } else if ([type containsString:@"投注记录"]) {
            self.recoType = transactionRecord_betRecordType;
            self.topViewHeight.constant = 30;
            self.topView.hidden = NO;
        } else if ([type containsString:@"余额宝转入"]) {
            self.recoType = transactionRecord_yuEBaoDeposit;
        } else if ([type containsString:@"余额宝转出"]) {
            self.recoType = TransactionRecord_yuEBaoWithdraw;
        }
        // 请求接口，刷新表格数据
        self.currentPage = 1;
        [self.tableView.mj_footer resetNoMoreData];
        [self requestData];
    }];

}

// 请求第currentPage页数据 page自动加一
- (void)requestData {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:@(self.currentPage) forKey:@"pageNo"];
    [param setObject:@(self.dayParm) forKey:@"lastDays"];
    [param setObject:@(10) forKey:@"pageSize"];
    
    NSString *path;
    switch (_recoType) {
        case transactionRecord_rechargeType: {
            path = config_queryTrans;
            break;
        }
        case transactionRecord_withdrawType: {
            path = config_queryWithDraw;
            break;
        }
        case transactionRecord_XMType: {
            path = config_queryWithXM;
            break;
        }
        case transactionRecord_activityType: {
            path = config_queryWithPromo;
            break;
        }
        case TransactionRecord_yuEBaoWithdraw: {
            path = config_yebTransferLogs;
            param[@"transferType"] = @2;
            break;
        }
        case transactionRecord_yuEBaoDeposit: {
            path = config_yebTransferLogs;
            param[@"transferType"] = @1;
            break;
        }
        case transactionRecord_betRecordType: {
            path = config_queryBets;
            NSDate *befDate = [NSDate jk_dateWithDaysBeforeNow:self.dayParm];
            [befDate jk_zeroDate];
            NSString *befDateStr = [befDate jk_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            [param setObject:befDateStr forKey:@"beginDate"];
            [param setObject:@(self.dayParm) forKey:@"lastDays"];
            NSDate *endDate = [NSDate date];
            NSString *endDateStr = [endDate jk_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
            [param setObject:endDateStr forKey:@"endDate"];
            [param setObject:@[@"004",@"035",@"031",@"026",@"027",@"036",@"051",@"052",@"039",@"017",@"062",@"064",@"065",@"067",@"003",@"088",@"080",@"006"] forKey:@"platformCodes"]; //厅方编码[MG-035,TTG-027,BSG-051,PNG-052、PT-039、BBIN-017、NT-065、PP-067,AG-26
            
            NSArray *gameKinds;
            switch (self.gameTypeIdx) {
                case 0:
                    gameKinds = @[@1,@2,@3,@5,@7,@8,@9,@12];
                    break;
                case 1:
                    gameKinds = @[@3];
                    break;
                case 2:
                    gameKinds = @[@5,@8];
                    break;
                case 3:
                    gameKinds = @[@1];
                    break;
                case 4:
                    gameKinds = @[@12];
                    break;
                case 5:
                    gameKinds = @[@7];
                    break;
                default:
                    break;
            }
            [param setObject:gameKinds forKey:@"gameKind"]; //大类ID[1:体育,2:电投,3:真人,12:彩票,5:电游,7:扑克（棋牌）,8:捕鱼]
            break;
        }
        default:
            break;
    }
    
    [CNBaseNetworking POST:path parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            CreditQueryResultModel *resultModel = [CreditQueryResultModel cn_parse:responseObj];
            self.resultModel = resultModel;
            
            // 洗码不显示 等待&拒绝
            if (self.recoType == transactionRecord_XMType) {
                NSMutableArray *arr = [resultModel.data mutableCopy];
                [arr enumerateObjectsUsingBlock:^(CreditQueryDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *flag = obj.flagDesc;
                    if ([flag isEqualToString:@"等待"] || [flag containsString:@"拒绝"]) {
                        [arr removeObject:obj];
                    }
                }];
                resultModel.data = arr.copy;
            }
            
            if (self.currentPage == 1) {
                self.dataList = [resultModel.data mutableCopy];
            } else {
                [self.dataList addObjectsFromArray:resultModel.data];
            }
            if (resultModel.data.count > 0) {
                [self.tableView.mj_footer endRefreshing];
                self.currentPage += 1;
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self relaodData];
    }];
    
}

- (void)relaodData {
    // 没有数据，tableview不显示，显示没有数据视图
    if (self.dataList.count == 0) {
        [self.view addSubview:self.noDataView];
        self.tableView.hidden = YES;
    } else {
        [self.noDataView removeFromSuperview];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
}

- (void)requestDeleteModelRow:(NSInteger)row{
    NSMutableDictionary *paramDic = [kNetworkMgr baseParam];
    if (self.dataList.count > row) {
        CreditQueryDataModel *model = self.dataList[row];
        [paramDic setObject:@[model.requestId] forKey:@"requestIds"];
    }
    
    // 充 提 洗 三个不同接口
    NSString *URLPath = config_deleteTrans;
    if (_recoType == transactionRecord_XMType) {
        URLPath = config_xmdeleteRequest;
    } else if (_recoType == transactionRecord_withdrawType) {
        URLPath = config_deleteWithdraw;
    }
    
    [CNBaseNetworking POST:URLPath parameters:paramDic completionHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            [CNTOPHUB showSuccess:@"记录已删除"];
            [self manualDeleteModelAndUpdateTableView:row];
        }
    }];

}

// 手动删除数据 => 刷新tableview
- (void)manualDeleteModelAndUpdateTableView:(NSInteger)row {
    [self.tableView beginUpdates];
    
    [self.dataList removeObjectAtIndex:row];
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma - mark UITableViewDataSource, UITableViewDelegate

- (void)configTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCNTradeRecordTCellID bundle:nil] forCellReuseIdentifier:kCNTradeRecordTCellID];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditQueryDataModel *model = self.dataList[indexPath.row];
    CNTradeRecordTCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNTradeRecordTCellID forIndexPath:indexPath];
    
    // 数据
    cell.titleLb.text = model.title;
    cell.amountLb.text = model.amount;
    cell.timeLb.text = model.createDate?:model.createdTime;
    cell.statusLb.text = model.flagDesc;
    cell.statusLb.textColor = model.statsColor;
    cell.currencyLb.text = model.currency?:[CNUserManager shareManager].userInfo.currency;
    // 游戏独特数据
    if (_recoType == transactionRecord_betRecordType) {
        cell.titleLb.text = model.gameType?:@"    ";
        cell.timeLb.text = model.billTime;
        cell.amountLb.text = model.payoutAmount;
    }
    if (_recoType == transactionRecord_rechargeType) {
        cell.amountLb.text = model.arrivalAmount;
    }
    if (_recoType == transactionRecord_yuEBaoDeposit || _recoType == TransactionRecord_yuEBaoWithdraw) {
        cell.titleLb.text = @"余额宝";
        cell.statusLb.text = model.yebStatusTxt;
    }
    
    // ICON
    switch (_recoType) {
        case transactionRecord_yuEBaoDeposit:
        case TransactionRecord_yuEBaoWithdraw:
        case transactionRecord_rechargeType:
        case transactionRecord_withdrawType:
            [cell.icon sd_setImageWithURL:[NSURL getUrlWithString:model.itemIcon] placeholderImage:[UIImage imageNamed:[CNUserManager shareManager].isUsdtMode?@"usdt":@"cny"]];
            break;
        case transactionRecord_XMType:
            [cell.icon sd_setImageWithURL:[NSURL getUrlWithString:model.itemIcon] placeholderImage:[UIImage imageNamed:@"chouma1"]];
            break;
        case transactionRecord_activityType:
            [cell.icon sd_setImageWithURL:[NSURL getUrlWithString:model.itemIcon] placeholderImage:[UIImage imageNamed:@"youhui_g"]];
            break;
        case transactionRecord_betRecordType:
            switch ([model.gameKind integerValue]) {
                case 1:
                    [cell.icon setImage:[UIImage imageNamed:@"tiyu"]];
                    break;
                case 2:
                case 5:
                case 8:
                    [cell.icon setImage:[UIImage imageNamed:@"dianz"]];
                    break;
                case 3:
                    [cell.icon setImage:[UIImage imageNamed:@"zhenren"]];
                    break;
                case 7:
                    [cell.icon setImage:[UIImage imageNamed:@"qipai"]];
                    break;
                case 12:
                    [cell.icon setImage:[UIImage imageNamed:@"caipiao"]];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditQueryDataModel *model = self.dataList[indexPath.row];
    
    CNRecordDetailType dtype;
    switch (_recoType) {
        case transactionRecord_rechargeType: {
            dtype = CNRecordTypeDeposit;
            if (model.mmStatus == 2 || model.mmStatus == 5) {
                CNMatchDepositStatusVC *statusVC = [[CNMatchDepositStatusVC alloc] init];
                statusVC.transactionId = model.requestId;
                statusVC.backToLastVC = YES;
                [self.navigationController pushViewController:statusVC animated:YES];
                return;
            }
        }
            break;
        case transactionRecord_withdrawType: {
            dtype = CNRecordTypeWithdraw;
            if (model.mmStatus == 2 || model.mmStatus == 5) {
                KYMMatchWithdrewSuccessVC *vc = [[KYMMatchWithdrewSuccessVC alloc] init];
                vc.transactionId = model.requestId;
                vc.amountStr = model.amount;
                vc.backToLastVC = YES;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
            break;
        case transactionRecord_betRecordType:
            dtype = CNRecordTypeTouZhu;
            break;
        case transactionRecord_activityType:
            dtype = CNRecordTypePromo;
            break;;
        case transactionRecord_XMType:
            dtype = CNRecordTypeXima;
            break;
        case transactionRecord_yuEBaoDeposit:
            dtype = CNRecordTypeYEBDeposit;
            break;
        case TransactionRecord_yuEBaoWithdraw:
            dtype = CNRecordTypeYEBWithdraw;
            break;
        default:
            break;
    }
        
    CNRecordDetailVC *vc = [[CNRecordDetailVC alloc] initWithType:dtype];
    vc.model = model;
    vc.navPopupBlock = ^(id obj) {
        if ([obj isEqual:@(1)]) {
            [self requestNewData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark 删除数据

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_recoType == transactionRecord_rechargeType ||
        _recoType == transactionRecord_withdrawType ||
        _recoType == transactionRecord_XMType) {
        return YES;
    } else {
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// iOS8以下？
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self requestDeleteModelRow:indexPath.row];
//    }
//}

// iOS10 可点击 OK
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF_DEFINE
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@" 删除 " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [HYTextAlertView showWithTitle:@"确定删除吗?" content:@"仅会删除该条记录" comfirmText:@"确认" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm){
            STRONGSELF_DEFINE
            if (isComfirm) {
                [strongSelf requestDeleteModelRow:indexPath.row];
            }
        }];
    }];
    return @[delAction];
}

// >=iOS11 一直往左划
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    WEAKSELF_DEFINE
    UIContextualAction * delAct = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [HYTextAlertView showWithTitle:@"确定删除吗?" content:@"仅会删除该条记录" comfirmText:@"确认" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm){
            STRONGSELF_DEFINE
            if (isComfirm) {
                [strongSelf requestDeleteModelRow:indexPath.row];
            }
        }];
    }];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[delAct]];
//    config.performsFirstActionWithFullSwipe = NO;
    return config;
}


#pragma mark - menuView

- (void)initHeaderView {
    self.topViewHeight.constant = 0;
    self.topView.hidden = YES;
    self.titleList = @[@"全部",@"真人",@"电游",@"体育",@"彩票",@"棋牌"];
    
    self.menuView = [[segmentHeaderView alloc] initWithFrame:self.topView.bounds titles:self.titleList];
    self.menuView.underLineColor = [UIColor whiteColor];
    self.menuView.isShowUnderLine = YES;
    self.menuView.delegate = self;
    [self.topView addSubview:self.menuView];
}

#pragma - mark segmentHeaderViewDelegate

- (void)hl_didSelectWithIndex:(NSInteger)index withIsClick:(BOOL)isClick {
    //isclick是为了区分当前操作是滑动还是点击
    if (isClick == YES) {
        NSLog(@"点击%@",self.titleList[index]);
        // 请求接口，刷新表格数据
        self.currentPage = 1;
        self.gameTypeIdx = index;
        [self.tableView.mj_footer resetNoMoreData];
        [self requestData];
    }
}

- (CNNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[CNNoDataView alloc] initWithFrame:CGRectMake(0, 0, 80, 100)];
        _noDataView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    }
    return _noDataView;
}

@end
