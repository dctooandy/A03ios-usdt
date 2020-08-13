//
//  HYRechargeSwitchPayWayController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYRechargePayWayController.h"
#import "HYRechargePayWayCell.h"

@interface HYRechargePayWayController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) PaywayType type;
@property (nonatomic, assign) NSInteger selcPayWayIdx;
@property (nonatomic, strong) NSArray<DepositsBankModel *> *depositModels;
@property (nonatomic, strong) NSArray<PayWayV3PayTypeItem *> *paywayItems;
@property (nonatomic, strong) NSArray<BQBankModel *> *bqBanks;

@end

@implementation HYRechargePayWayController
static NSString *const KRechargeCell = @"HYRechargePayWayCell";

- (instancetype)initWithDepositModels:(NSArray<DepositsBankModel *> *)models
                              selcIdx:(NSInteger)selcIdx {
    self = [super init];
    self.title = @"选择支付方式";
    self.type = PaywayTypeDepositBank;
    self.depositModels = models;
    self.selcPayWayIdx = selcIdx;
    return self;
}

- (instancetype)initWithPaywayItems:(NSArray<PayWayV3PayTypeItem *> *)models
                            selcIdx:(NSInteger)selcIdx {
    self = [super init];
    self.title = @"选择支付方式";
    self.type = PaywayTypePaywayV3;
    self.paywayItems = models;
    self.selcPayWayIdx = selcIdx;
    return self;
}

- (instancetype)initWithBQbanks:(NSArray<BQBankModel *> *)models
                        selcIdx:(NSInteger)selcIdx {
    self = [super init];
    self.title = @"选择收款银行";
    self.type = PaywayTypeBQBank;
    self.bqBanks = models;
    self.selcPayWayIdx = selcIdx;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNaviRightItemWithImageName:@"service"];
    
    [self setupTableView];
}

- (void)rightItemAction {
    [NNPageRouter jump2Live800Type:CNLive800TypeDeposit];
}

- (void)setupTableView {
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:KRechargeCell bundle:nil] forCellReuseIdentifier:KRechargeCell];
    
}


#pragma mark - TableVIew
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.type) {
        case PaywayTypePaywayV3:
            return self.paywayItems.count;
            break;
        case PaywayTypeDepositBank:
            return self.depositModels.count;
            break;
        case PaywayTypeBQBank:
            return self.bqBanks.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYRechargePayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:KRechargeCell];
    switch (self.type) {
        case PaywayTypePaywayV3:
            cell.paywayModel = self.paywayItems[indexPath.row];
            break;
        case PaywayTypeDepositBank:
            cell.deposModel = self.depositModels[indexPath.row];
            break;
        case PaywayTypeBQBank:
            cell.bqBank = self.bqBanks[indexPath.row];
            break;
        default:
            break;
    }
    if (self.selcPayWayIdx == indexPath.row) {
        [cell.imgvStatus setImage:[UIImage imageNamed:@"select"]];
    } else {
        [cell.imgvStatus setImage:[UIImage imageNamed:@"unSelect"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UI
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger oldIdx = self.selcPayWayIdx;
    self.selcPayWayIdx = indexPath.row;
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldIdx inSection:0], [NSIndexPath indexPathForRow:self.selcPayWayIdx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
    //DATA
    if (self.navPopupBlock) {
        self.navPopupBlock(@(indexPath.row));
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
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
