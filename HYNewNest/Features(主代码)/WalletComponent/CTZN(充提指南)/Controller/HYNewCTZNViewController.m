//
//  HYNewCTZNViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/2.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYNewCTZNViewController.h"
#import "HYNewCTZNCell.h"
#import "CNBaseNetworking.h"
#import "CTZNModel.h"
//#import "BYRechargeUsdtVC.h"
#import "HYWithdrawViewController.h"
#import "HYWideOneBtnAlertView.h"
#import "HYCTZNPlayerViewController.h"
#import "HYOneBtnAlertView.h"

@interface HYNewCTZNViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *btnNowShow;
@property (strong,nonatomic) NSArray<CTZNModel *> *models; //!<主内容

@end

@implementation HYNewCTZNViewController

static NSString * const KCTZNCELL = @"HYNewCTZNCell";

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 62, kScreenWidth, self.view.height-62);
        _tableView.contentInset = UIEdgeInsetsMake(15, 0, kSafeAreaHeight+62, 0);
        _tableView.rowHeight = 228;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:KCTZNCELL bundle:nil] forCellReuseIdentifier:KCTZNCELL];
    }
    return _tableView;
}

- (instancetype)init {
    self = [super init];
    _type = -1;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kHexColor(0x212137);
    [self setupViews];
    [self getDynamicData];
}

- (void)setupViews {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.frame = self.view.bounds;
    self.view.layer.mask = layer;
    
    UILabel *title = [[UILabel alloc] init];
    title.textColor = kHexColor(0xFFFFFF);
    title.text = @"充提指南";
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, kScreenWidth, 62);
    [title addLineDirection:LineDirectionBottom color:kHexColorAlpha(0xFFFFFF, 0.1) width:0.5];
    [self.view addSubview:title];
    
    UIButton *btnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancle setImage:[UIImage imageNamed:@"modal-close"] forState:UIControlStateNormal];
    btnCancle.frame = CGRectMake(kScreenWidth-30-18, 16, 30, 30);
    [btnCancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCancle];
    
    UIButton *btnNotShow = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNotShow setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
    [btnNotShow setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [btnNotShow setTitle:@" 不再提醒" forState:UIControlStateNormal];
    btnNotShow.titleLabel.font = [UIFont fontPFR12];
    btnNotShow.frame = CGRectMake(20, 0, 75, 62);
    [btnNotShow addTarget:self action:@selector(didClickNotShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNotShow];
    self.btnNowShow = btnNotShow;
    self.btnNowShow.selected = [[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowCTZNEUserDefaultKey];
    
    [self.view addSubview:self.tableView];
}

- (void)setType:(NSInteger)type {
    _type = type;
}

- (void)getDynamicData {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:@"DEPOSIT_GUIDE" forKey:@"bizCode"];
    WEAKSELF_DEFINE
    [CNBaseNetworking POST:(config_dynamicQuery) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *data = [responseObj objectForKey:@"data"];
            NSArray *models = [CTZNModel cn_parse:data];
            NSMutableArray *aaa = @[].mutableCopy;
            for (CTZNModel *model in models) {
                if (![model.type isEqualToString:@"banner"]) {
                    [aaa addObject:model];
                }
            }
            strongSelf.models = aaa;
            [strongSelf.tableView reloadData];
            if (strongSelf.type != -1) {
                // 自动播放
//                CTZNModel *model = self.models[strongSelf.type];
//                HYCTZNPlayerViewController *playVC = [[HYCTZNPlayerViewController alloc] init];
//                playVC.sourceUrl = model.video;
//                playVC.tit = model.title;
//                playVC.modalPresentationStyle = UIModalPresentationFullScreen;
//                [self presentViewController:playVC animated:YES completion:nil];
                
                // 滚动&高亮
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:strongSelf.type inSection:0];
                [strongSelf.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

                HYNewCTZNCell *cell = [strongSelf.tableView cellForRowAtIndexPath:idxPath];
                cell.isCusSelc = YES;
            }
        }
    }];
    
}

#pragma mark - ACTION

- (void)didClickNotShow:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [HYOneBtnAlertView showWithTitle:@"温馨提示" content:@"充提指南不会再强制提醒，您仍可以通过“买币-教程引导-网站充提教学”打开" comfirmText:@"我知道了" comfirmHandler:^{
        }];
    }
}

- (void)dismiss {
    [self dismissSelf:nil];
}

- (void)dismissSelf:(nullable void(^)(void))handler {
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[NSUserDefaults standardUserDefaults] setBool:self.btnNowShow.selected forKey:HYNotShowCTZNEUserDefaultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (handler) {
            handler();
        }
    }];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYNewCTZNCell *cell = [tableView dequeueReusableCellWithIdentifier:KCTZNCELL];
    CTZNModel *model = self.models[indexPath.row];
    cell.model = model;
    
    cell.playBlock = ^{
        HYCTZNPlayerViewController *playVC = [[HYCTZNPlayerViewController alloc] init];
        playVC.sourceUrl = model.video;
        playVC.tit = model.title;
        playVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:playVC animated:YES completion:nil];
    };
    
    cell.actionBlock = ^(NSString * _Nonnull type) {
        if ([type isEqualToString:@"充币"]) {
            [self dismissSelf:^{
//                [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:[BYRechargeUsdtVC new] animated:YES];
            }];
            
        } else if ([type isEqualToString:@"买币"]) {
            [self dismissSelf:^{
                [NNPageRouter openExchangeElecCurrencyPage];
            }];
            
        } else if ([type isEqualToString:@"提币"]) {
            [self dismissSelf:^{
                [[NNControllerHelper currentTabbarSelectedNavigationController] pushViewController:[HYWithdrawViewController new] animated:YES];
            }];
            
        } else if ([type isEqualToString:@"卖币"]) {
            [HYWideOneBtnAlertView showWithTitle:@"卖币跳转" content:@"在交易所卖出数字货币，买家会将金额支付到您的银行卡，方便快捷。" comfirmText:@"我知道了，帮我跳转" comfirmHandler:^{
                
                [self dismissSelf:^{
                    [NNPageRouter openExchangeElecCurrencyPage];
                }];
            }];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *cells = [tableView visibleCells];
    [cells enumerateObjectsUsingBlock:^(HYNewCTZNCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isCusSelc = NO;
    }];
    
    HYNewCTZNCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isCusSelc = YES;
}

@end
