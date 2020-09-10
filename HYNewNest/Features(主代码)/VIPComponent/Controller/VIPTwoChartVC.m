//
//  VIPTwoChartVC.m
//  HYNewNest
//
//  Created by zaky on 9/7/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPTwoChartVC.h"
#import "VIPChartHeaderView.h"
#import "VIPChartDJTQCell.h"
#import "VIPChartDSBHeaderView.h"
#import "VIPChartDSBCell.h"
#import "CNVIPRequest.h"

static NSString * const VIPDJTQCell = @"VIPChartDJTQCell";//等级特权cell
static NSString * const VIPDJTQChartHeader = @"VIPChartHeaderView";//头部标题
static NSString * const VIPDSBCell = @"VIPChartDSBCell";//大神版cell
static NSString * const VIPDSBChartHeader = @"VIPChartDSBHeaderView";//头部标题

@interface VIPTwoChartVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginCons;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic) VIPChartType type;
@property (nonatomic, strong) NSArray <VIPDSBUsrModel *>*dsbModels;
@end

@implementation VIPTwoChartVC

- (id)initWithType:(VIPChartType)type {
    self = [super init];
    _type = type;

    return self;
}

- (void)requestBoard {
    [CNVIPRequest vipsxhBigGodBoardHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            self.dsbModels = [VIPDSBUsrModel cn_parse:responseObj[@"rankData"]];
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.backgroundColor = kHexColor(0x0A1D25);
    if (_type == VIPChartTypeRankRight) {
        self.lbTitle.text = @"等级特权(usdt)";
        [self.tableView registerNib:[UINib nibWithNibName:VIPDJTQCell bundle:nil] forCellReuseIdentifier:VIPDJTQCell];
        [self.tableView registerNib:[UINib nibWithNibName:VIPDJTQChartHeader bundle:nil] forHeaderFooterViewReuseIdentifier:VIPDJTQChartHeader];
        [self.tableView reloadData];
    } else {
        self.lbTitle.text = @"私享会大神榜(usdt)";
        [self.tableView registerNib:[UINib nibWithNibName:VIPDSBCell bundle:nil] forCellReuseIdentifier:VIPDSBCell];
        [self.tableView registerNib:[UINib nibWithNibName:VIPDSBChartHeader bundle:nil] forHeaderFooterViewReuseIdentifier:VIPDSBChartHeader];
        [self requestBoard];
    }

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_type == VIPChartTypeRankRight) {
        self.topMarginCons.constant = self.view.height - (45*7 + 60) - kSafeAreaHeight;
    }
}

#pragma mark - ACTION
- (IBAction)didTapDismissBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == VIPChartTypeRankRight) {
        return self.equityData.count;
    } else {
        return self.dsbModels.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == VIPChartTypeRankRight) {
        NSDictionary *dict = @{@"2":@"赌侠",@"3":@"赌霸",@"4":@"赌王",@"5":@"赌圣",@"6":@"赌神",@"7":@"赌尊"};
        EquityDataItem *item = self.equityData[indexPath.row];
        
        VIPChartDJTQCell *cell = (VIPChartDJTQCell *)[tableView dequeueReusableCellWithIdentifier:VIPDJTQCell];
        cell.lbFirst.text = dict[item.clubLevel];
        cell.lbSecond.text = [item.rhljAmount jk_toDisplayNumberWithDigit:0];
        cell.lbThird.text = [item.ydfhAmount jk_toDisplayNumberWithDigit:0];
        cell.lbFourth.text = item.zzzpTime;
        return cell;
        
    } else {
        VIPDSBUsrModel *model = self.dsbModels[indexPath.row];
        
        VIPChartDSBCell *cell = (VIPChartDSBCell *)[tableView dequeueReusableCellWithIdentifier:VIPDSBCell];
        cell.lbUsrName.text = model.loginName;
        cell.lbBetAmount.text = [model.totalBetAmount jk_toDisplayNumberWithDigit:0];
        cell.lbDepositAmount.text = [model.totalDepositAmount jk_toDisplayNumberWithDigit:0];
        cell.lbLevelName.text = model.clubName;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *view;
    if (_type == VIPChartTypeRankRight) {
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:VIPDJTQChartHeader];
    } else {
        view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:VIPDSBChartHeader];
    }
    return view;
}


@end
