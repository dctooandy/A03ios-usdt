//
//  CNDashenBoardVC.m
//  HYNewNest
//
//  Created by zaky on 12/3/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNDashenBoardVC.h"
#import "DSBHeaderSelectionView.h"
#import "BYMultiDataSourceTableView.h"

#import "DSBWeekMonthListDataSource.h"
#import "DSBRecharWithdrwRankDataSource.h"
#import "DSBProfitBoardDataSource.h"

@interface CNDashenBoardVC () <DashenBoardAutoHeightDelegate>
@property (weak, nonatomic) IBOutlet DSBHeaderSelectionView *headerSelecView;

@property (nonatomic, strong) DSBWeekMonthListDataSource *mlTbDataSource;
@property (strong,nonatomic) DSBRecharWithdrwRankDataSource *rwTbDataSource;
@property (strong,nonatomic) DSBProfitBoardDataSource *proTbDataSource;
@property (weak, nonatomic) IBOutlet BYMultiDataSourceTableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHCons;
@property (assign, readwrite, nonatomic) CGFloat totalHeight;
@property (weak, nonatomic) IBOutlet UILabel *btmLabel;

@end

@implementation CNDashenBoardVC
@synthesize totalHeight = _totalHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 滑动手势
    UISwipeGestureRecognizer *swipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeftRight:)];
    swipGes.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [_tableView addGestureRecognizer:swipGes];
    
    // 周榜月榜
    _mlTbDataSource = [[DSBWeekMonthListDataSource alloc] initWithDelegate:self TableView:_tableView type:DashenBoardTypeWeekBoard];
    // 充值提现
    _rwTbDataSource = [[DSBRecharWithdrwRankDataSource alloc] initWithDelegate:self TableView:_tableView type:DashenBoardTypeRechargeBoard];
    // 盈利榜
    _proTbDataSource = [[DSBProfitBoardDataSource alloc] initWithDelegate:self TableView:_tableView];
    
    // 头部点击回调
    WEAKSELF_DEFINE
    _headerSelecView.didTapBtnBlock = ^(NSString * _Nonnull rankName) {
        STRONGSELF_DEFINE
        
        if ([rankName containsString:@"大神"]) {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.proTbDataSource type:DashenBoardTypeProfitBoard];
            strongSelf.btmLabel.text = @"大神榜为当天百家乐数据，每5分钟刷新一次";
            
        } else if ([rankName containsString:@"充值"]) {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.rwTbDataSource type:DashenBoardTypeRechargeBoard];
            strongSelf.btmLabel.text = @"数据每小时刷新";
            
        } else if ([rankName containsString:@"提现"]) {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.rwTbDataSource type:DashenBoardTypeWithdrawBoard];
            strongSelf.btmLabel.text = @"数据每小时刷新";
            
        } else if ([rankName containsString:@"周总"]) {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.mlTbDataSource type:DashenBoardTypeWeekBoard];
            strongSelf.btmLabel.text = @"数据每周一凌晨更新";
            
        } else {
            [strongSelf.tableView changeDataSourceDelegate:strongSelf.mlTbDataSource type:DashenBoardTypeMonthBoard];
            strongSelf.btmLabel.text = @"数据每周一凌晨更新";
        }
    };
    
    // 默认调用一个数据源 来设定_tableViewHCons高度并触发代理回调
    [self.tableView changeDataSourceDelegate:self.proTbDataSource type:DashenBoardTypeProfitBoard];
    
}


#pragma mark - UI

- (void)didSetupDataGetTableHeight:(CGFloat)tableHeight {
    _tableViewHCons.constant = tableHeight;
    
    if (self.delegate) {
        [self.delegate didSetupDataGetTableHeight:(tableHeight + 100.0)]; //100是头部点击按钮们高度
    }
}


#pragma mark - UISwipeGesture

- (void)didSwipeLeftRight:(UISwipeGestureRecognizer *)swipe {
    if (self.tableView.type == DashenBoardTypeProfitBoard) {
//        [LoadingView showLoadingViewWithToView:self.tableView needMask:NO];
        if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
            NSLog(@"大神榜 从左往右");
            self.proTbDataSource.curPage += 1;
        }else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
            NSLog(@"大神榜 从右往左");
            self.proTbDataSource.curPage -= 1;
        }
    }
}



@end
