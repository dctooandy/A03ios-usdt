//
//  HYWithdrawViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYWithdrawViewController.h"
#import "HYXiMaTopView.h"
#import "CNTwoStatusBtn.h"
#import "HYWideOneBtnAlertView.h"
#import <MJRefresh.h>
#import "HYWithdrawCardCell.h"
#import "HYWithdrawAddCardFooter.h"
#import "HYWithdrawComfirmView.h"
#import "CNCompleteInfoVC.h"

#import "CNWithdrawRequest.h"
#import "CNWDAccountRequest.h"
#import "CNUserCenterRequest.h"


@interface HYWithdrawViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet HYXiMaTopView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *sumitBtn;
@property (nonatomic, assign) NSInteger selectedIdx;
@property (nonatomic, strong) NSMutableArray<AccountModel *> *elecCardsArr;//所有卡
@property (nonatomic, strong) AccountMoneyDetailModel *moneyModel;

@property (nonatomic, weak) HYWithdrawComfirmView *comfirmView;
@end

@implementation HYWithdrawViewController
static NSString * const KCardCell = @"HYWithdrawCardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [CNUserManager shareManager].isUsdtMode ? @"提币" : @"提现";
    [self.sumitBtn setTitle:[CNUserManager shareManager].isUsdtMode ? @"提币" : @"提现" forState:UIControlStateNormal];
    [self addNaviRightItemWithImageName:@"service"];
    
    self.selectedIdx = 0;
    [self setupTopView];
    [self setupTableView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self bunchRequest];
    
    if (![CNUserManager shareManager].userDetail.mobileNoBind || ![CNUserManager shareManager].userDetail.realName) {
        [HYTextAlertView showWithTitle:@"完善信息" content:@"对不起！系统发现您还没有完成实名认证，请先完成实名认证，再进行提现操作。" comfirmText:@"去认证" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm){
            if (isComfirm) {
                [self.navigationController pushViewController:[CNCompleteInfoVC new] animated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)bunchRequest {
    [self requestBalance];
    [self requestWithdrawAddress];
}

- (void)rightItemAction {
    [NNPageRouter jump2Live800Type:CNLive800TypeDeposit];
}


- (void)setupTopView {
    self.topView.lblTitle.text = @"可提现金额";
    [self.topView.ruleBtn setTitle:@" 说明" forState:UIControlStateNormal];
    self.topView.clickBlock = ^{
        NSString *content = [NSString stringWithFormat:@"根据《菲律宾反洗钱法》规定：\n1. 提币需达到充币的1倍有效投注额\n2. 可提币金额＝总资产 - 各厅不足1%@下的金额\n3. 如参与了网站的优惠活动，提币需根据相关活动规则有效投注额\n\n具体提币情况以审核完结果为准。", [CNUserManager shareManager].userInfo.currency];
        [HYWideOneBtnAlertView showWithTitle:@"提现说明" content:content comfirmText:@"我知道了" comfirmHandler:^{
        }];
    };
}

- (void)setupTableView {
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 106;
    [self.tableView registerNib:[UINib nibWithNibName:KCardCell bundle:nil] forCellReuseIdentifier:KCardCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(bunchRequest)];
    
    UINib *nib = [UINib nibWithNibName:@"HYWithdrawAddCardFooter" bundle:nil];
    HYWithdrawAddCardFooter *footer = [nib instantiateWithOwner:nil options:nil].firstObject;
    footer.frame = CGRectMake(0, 0, kScreenWidth, 106);
    self.tableView.tableFooterView = footer;
    
    self.sumitBtn.enabled = YES;
    self.sumitBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sumitBtn.layer.shadowOffset = CGSizeMake(2.0, 2.0f);
    self.sumitBtn.layer.shadowOpacity = 0.13f; //透明度

}


#pragma mark - ACTION
- (IBAction)didTapWithdrawBtn:(id)sender {
    WEAKSELF_DEFINE
    HYWithdrawComfirmView *view = [[HYWithdrawComfirmView alloc] initWithAmountModel:self.moneyModel sumbitBlock:^(NSString * withdrawAmout) {
        STRONGSELF_DEFINE
        [strongSelf sumbimtWithdrawAmount:withdrawAmout];
    }];
    self.comfirmView = view;
    [kKeywindow addSubview:view];
}


#pragma mark - REQUEST
- (void)requestBalance {
    [CNUserCenterRequest requestAccountBalanceHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg)) {
            AccountMoneyDetailModel *moneyModel = [AccountMoneyDetailModel cn_parse:responseObj];
            self.moneyModel = moneyModel;
            self.topView.lblAmount.text = [moneyModel.withdrawBal jk_toDisplayNumberWithDigit:2];
        }
    }];
}

- (void)requestWithdrawAddress {
    WEAKSELF_DEFINE
    [CNWDAccountRequest queryAccountHandler:^(id responseObj, NSString *errorMsg) {
        [self.tableView.mj_header endRefreshing];
        STRONGSELF_DEFINE
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *accountArr = responseObj[@"accounts"];
            NSArray *accounts = [AccountModel cn_parse:accountArr];
            //手动筛选
            strongSelf.elecCardsArr = @[].mutableCopy;

            for (AccountModel *subModel in accounts) {
                if ([subModel.bankName isEqualToString:@"BTC"]) {
                    
                    // usdt卡
                } else if (([subModel.bankName isEqualToString:@"USDT"] || [subModel.bankName isEqualToString:@"DCBOX"] || [subModel.bankName isEqualToString:@"BITOLL"])
                           && [CNUserManager shareManager].isUsdtMode) {
                    if ([subModel.bankName isEqualToString:@"DCBOX"]) {
                        subModel.bankName = @"小金库";
                    }
                    [strongSelf.elecCardsArr addObject:subModel];
                    
                    // 银行卡
                } else if (!([subModel.bankName isEqualToString:@"USDT"] || [subModel.bankName isEqualToString:@"DCBOX"] || [subModel.bankName isEqualToString:@"BITOLL"])
                           && ![CNUserManager shareManager].isUsdtMode) {
                    [strongSelf.elecCardsArr addObject:subModel];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

- (void)sumbimtWithdrawAmount:(NSString *)amout {
    AccountModel *model = self.elecCardsArr[self.selectedIdx];
    NSNumber *amount = [NSNumber numberWithDouble:[amout doubleValue]];
    WEAKSELF_DEFINE
    [CNWithdrawRequest submitWithdrawRequestAmount:amount
                                         accountId:model.accountId
                                          protocol:model.protocol
                                           remarks:@""
                                           handler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (KIsEmptyString(errorMsg)) {
            [strongSelf.comfirmView showSuccessWithdraw];
        }
    }];
}

#pragma mark - TABLEVIEW

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = self.view.backgroundColor;
    bgView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    UILabel *lblTitle = [[UILabel alloc] init];
    [bgView addSubview:lblTitle];
    lblTitle.frame = CGRectMake(30, 60-15-17, 100, 17);
    lblTitle.text = [CNUserManager shareManager].isUsdtMode ? @"提现地址" : @"提现至";
    lblTitle.textColor = kHexColorAlpha(0xFFFFFF, 0.4);
    lblTitle.font = [UIFont fontPFR15];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.elecCardsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYWithdrawCardCell *cell = [tableView dequeueReusableCellWithIdentifier:KCardCell];
    cell.model = self.elecCardsArr[indexPath.row];
    //tableView reloadDate会将所有的cell恢复成未选中状态,任何在reloadData方法执行完毕之前设置的选中状态都会失效.所以使用异步的方式将设置选中状态推迟到下一次runLoop,这样cell的选中状态就不会被tableView重置
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.selectedIdx == indexPath.row) {
            [cell setSelected:YES animated:YES];
        } else {
            [cell setSelected:NO animated:YES];
        }
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger oldSel = self.selectedIdx;
    self.selectedIdx = indexPath.row;
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldSel inSection:0],indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
