//
//  HYVIPCumulateIdVC.m
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYVIPCumulateIdVC.h"
#import "VIPCumulateIdCell.h"
#import "VIPCumulateIdHeader.h"
#import "HYVIPRuleAlertView.h"

static NSString * const CUMIDCELL = @"VIPCumulateIdCell";
static NSString * const CUMIDHEADER = @"VIPCumulateIdHeader";

@interface HYVIPCumulateIdVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnRule;

/// 累计身份
@property (weak, nonatomic) IBOutlet UIStackView *stackViewLJSF;
@property (weak, nonatomic) IBOutlet UIView *viewLJSF;
@property (weak, nonatomic) IBOutlet UILabel *lblDuzunNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuGodNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuSaintNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuKingNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuBaNum;
@property (weak, nonatomic) IBOutlet UILabel *lblDuXiaNum;
@property (weak, nonatomic) IBOutlet UILabel *lblPlsLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation HYVIPCumulateIdVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupUI];
    //TODO: liebiaoshuju
}

- (void)setupUI {
    self.navBarTransparent = YES;
    self.makeTranslucent = YES;
    
    self.view.backgroundColor = _tableView.backgroundColor =  kHexColor(0x181514);
    
    if ([CNUserManager shareManager].isLogin) {
        _stackViewLJSF.hidden = NO;
        _btnLogin.hidden = YES;
        _lblPlsLogin.hidden = YES;
        [self vipHomeData];
        
    } else {
        _stackViewLJSF.hidden = YES;
        _btnLogin.hidden = NO;
        _lblPlsLogin.hidden = NO;
    }
    
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 45, 37) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(18, 18)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = cornerPath.CGPath;
    layer.fillColor = [[UIColor gradientFromColor:kHexColor(0xF5E693) toColor:kHexColor(0x6D542A) withWidth:45] CGColor];
    [_btnRule.layer addSublayer:layer];
    
    _viewLJSF.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0xE1DED1) toColor:kHexColor(0x817C6D) withHeight:70];
    _viewLJSF.layer.borderColor = [UIColor jk_gradientFromColor:kHexColor(0x71572C) toColor:kHexColor(0xCCAD5D) withHeight:70].CGColor;
    _viewLJSF.layer.borderWidth = 1;
    
    [_tableView registerNib:[UINib nibWithNibName:CUMIDCELL bundle:nil] forCellReuseIdentifier:CUMIDCELL];
    [_tableView registerNib:[UINib nibWithNibName:CUMIDHEADER bundle:nil] forHeaderFooterViewReuseIdentifier:CUMIDHEADER];
}

- (void)setupUIDatas {
    _lblDuXiaNum.text = [NSString stringWithFormat:@"%ld", self.sxhModel.historyBet.betXiaCount];
    _lblDuBaNum.text = [NSString stringWithFormat:@"%ld", self.sxhModel.historyBet.betBaCount];
    _lblDuKingNum.text = [NSString stringWithFormat:@"%ld", self.sxhModel.historyBet.betKingCount];
    _lblDuSaintNum.text = [NSString stringWithFormat:@"%ld", self.sxhModel.historyBet.betSaintCount];
    _lblDuGodNum.text = [NSString stringWithFormat:@"%ld", self.sxhModel.historyBet.betGoldCount];
    _lblDuzunNum.text = [NSString stringWithFormat:@"%ld", self.sxhModel.historyBet.betZunCount];
}


#pragma mark - Request
- (void)vipHomeData {
    [CNVIPRequest vipsxhHomeHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            VIPHomeUserModel *model = [VIPHomeUserModel cn_parse:responseObj];
            self.sxhModel = model;
            [self setupUIDatas];
        }
    }];
}


#pragma mark - ACTION
- (IBAction)didTapRuleBtn:(id)sender {
    [HYVIPRuleAlertView showCumulateIdentityRule];
}

- (IBAction)didTapLoginBtn:(id)sender {
    [NNPageRouter jump2Login];
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VIPCumulateIdCell *cell = [tableView dequeueReusableCellWithIdentifier:CUMIDCELL];
    //TODO:-
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VIPCumulateIdHeader *header = (VIPCumulateIdHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:CUMIDHEADER];
    //TODO:-
    return header;
}


@end
