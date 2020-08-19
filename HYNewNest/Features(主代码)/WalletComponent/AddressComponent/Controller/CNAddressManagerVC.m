//
//  CNAddressManagerVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNAddressManagerVC.h"
#import "CNAddAddressVC.h"
#import "CNAddBankCardVC.h"

#import "CNAddressAddTCell.h"
#define kCNAddressAddTCellID  @"CNAddressAddTCell"
#import "CNAddressInfoTCell.h"
#define kCNAddressInfoTCellID  @"CNAddressInfoTCell"
#import "CNAddressDownloadTCell.h"
#define kCNAddressDownloadTCellID  @"CNAddressDownloadTCell"

#import "CNWDAccountRequest.h"
#import "ABCOneKeyRegisterBFBHelper.h"
#import <IVLoganAnalysis/IVLAManager.h>

@interface CNAddressManagerVC () <UITableViewDelegate, UITableViewDataSource>
// 顶部页签
@property (weak, nonatomic) IBOutlet UIButton *goldBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentViewH;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

/// 卡列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 区分当前是小金库地址还是其他地址
@property (nonatomic, assign) HYAddressType addrType;
/// 数据源
@property (nonatomic, strong) NSArray<AccountModel *> *bankAccounts;
@property (nonatomic, strong) NSArray<AccountModel *> *dcboxAccounts;
@property (nonatomic, strong) NSArray<AccountModel *> *usdtAccounts;
@end

@implementation CNAddressManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [CNUserManager shareManager].isUsdtMode ? @"提币地址管理" : @"银行卡管理";
    
    [self configUI];
    
    if ([CNUserManager shareManager].isUsdtMode) {
        //usdt模式
        self.addrType = HYAddressTypeDCBOX;
    } else {
        //RMB模式
        self.addrType = HYAddressTypeBANKCARD;
        self.segmentView.hidden = YES;
        self.segmentViewH.constant = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self queryAccounts];
}

- (void)configUI {
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:kCNAddressAddTCellID bundle:nil] forCellReuseIdentifier:kCNAddressAddTCellID];
    [self.tableView registerNib:[UINib nibWithNibName:kCNAddressInfoTCellID bundle:nil] forCellReuseIdentifier:kCNAddressInfoTCellID];
    [self.tableView registerNib:[UINib nibWithNibName:kCNAddressDownloadTCellID bundle:nil] forCellReuseIdentifier:kCNAddressDownloadTCellID];
    
}
 
// 小金库地址
- (IBAction)goldAddress:(UIButton *)sender {
    sender.selected = YES;
    self.otherBtn.selected = NO;
    self.bottomLine.centerX = sender.centerX;
    
    // 切换数据源为公告，reload
    self.addrType = HYAddressTypeDCBOX;
    [self.tableView reloadData];
}

// 其他地址
- (IBAction)otherAddress:(UIButton *)sender {
    sender.selected = YES;
    self.goldBtn.selected = NO;
    self.bottomLine.centerX = sender.centerX;
    
    // 切换数据源为站内信，reload
    self.addrType = HYAddressTypeUSDT;
    [self.tableView reloadData];
}


#pragma mark - REQUEST
- (void)queryAccounts {
    [CNWDAccountRequest queryAccountHandler:^(id responseObj, NSString *errorMsg) {
        if (!KIsEmptyString(errorMsg) || ![responseObj isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSArray<AccountModel *> *accounts = [AccountModel cn_parse:responseObj[@"accounts"]];
        NSMutableArray *banks = @[].mutableCopy;
        NSMutableArray *usdts = @[].mutableCopy;
        NSMutableArray *dcboxs = @[].mutableCopy;
        for (AccountModel *model in accounts) {
            //筛选
            if ([model.bankName isEqualToString:@"BTC"]) {
            }
            else if ([model.bankName isEqualToString:@"BITOLL"]) {
                [usdts addObject:model];
            }
            else if ([model.bankName isEqualToString:@"USDT"]) {
                [usdts addObject:model];
            }
            else if ([model.bankName isEqualToString:@"DCBOX"]) {
                model.bankName = @"小金库";
                [dcboxs addObject:model];
            }
            else { // 银行卡
                [banks addObject:model];
            }
        }
        self.bankAccounts = banks.copy;
        self.usdtAccounts = usdts.copy;
        self.dcboxAccounts = dcboxs.copy;
        [self.tableView reloadData];
    }];
}

- (void)deleteAccountIdx:(NSInteger)idx {
    [HYTextAlertView showWithTitle:@"确定删除？" content:@"删除后不可恢复，只能重新添加" comfirmText:@"删除" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm){
        if (!isComfirm) {
            return;
        }
        AccountModel *model;
        switch (self.addrType) {
            case HYAddressTypeBANKCARD:
                model = self.bankAccounts[idx];
                break;
            case HYAddressTypeDCBOX:
                model = self.dcboxAccounts[idx];
                break;
            case HYAddressTypeUSDT:
                model = self.usdtAccounts[idx];
                break;
        }
        [CNWDAccountRequest deleteAccountId:model.accountId handler:^(id responseObj, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg)) {
                [CNHUB showSuccess:@"删除成功"];
                [self queryAccounts];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [IVLAManager singleEventId:@"A03_bankcard_update"];
                });
            }
        }];
        
    }];
}


#pragma - mark UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_addrType == HYAddressTypeDCBOX && self.dcboxAccounts.count == 0 && indexPath.row == 1) {
        return 180;
    } else {
        return 115;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_addrType) {
        case HYAddressTypeBANKCARD:
            //有卡：显示卡和添加；无卡：显示添加
            return self.bankAccounts.count>0 ? self.bankAccounts.count+1 : 1;
            break;
        case HYAddressTypeDCBOX:
//            //有卡：显示卡和一个添加；无卡：显示一键绑定和下载
//            return self.dcboxAccounts.count>0 ? self.dcboxAccounts.count+1 : 2;
            return self.dcboxAccounts.count + 2;;
            break;
        case HYAddressTypeUSDT:
            //有卡：显示卡和添加；无卡：显示添加
            return self.usdtAccounts.count>0 ? self.usdtAccounts.count+1 : 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (_addrType) {
        case HYAddressTypeBANKCARD:
            if (indexPath.row == self.bankAccounts.count) {
                CNAddressAddTCell *addCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressAddTCellID forIndexPath:indexPath];
                addCell.titleLb.text = @"添加银行卡";
                return addCell;
                
            } else {
                AccountModel *model = self.bankAccounts[indexPath.row];
                CNAddressInfoTCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressInfoTCellID forIndexPath:indexPath];
                infoCell.model = model;
                infoCell.deleteBlock = ^{
                    [self deleteAccountIdx:indexPath.row];
                };
                return infoCell;
            }
            break;
            
        case HYAddressTypeDCBOX:
//            if (self.dcboxAccounts.count == 0) { //无卡
//                if (indexPath.row == self.dcboxAccounts.count) { //倒数第二个cell：一键注册/绑定小金库
//                    CNAddressAddTCell *addCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressAddTCellID forIndexPath:indexPath];
//                    addCell.titleLb.text = @"一键注册/绑定小金库";
//                    return addCell;
//
//                } else { //最后一个cell：下载小金库
//                    CNAddressDownloadTCell *downloadCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressDownloadTCellID forIndexPath:indexPath];
//                    return downloadCell;
//                }
//
//            } else { //有卡
//                if (indexPath.row == self.dcboxAccounts.count) { //最后一个cell：添加小金库
//                    CNAddressAddTCell *addCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressAddTCellID forIndexPath:indexPath];
//                    addCell.titleLb.text = @"添加小金库";
//                    return addCell;
//
//                } else { //卡列表
//                    AccountModel *model = self.dcboxAccounts[indexPath.row];
//                    CNAddressInfoTCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressInfoTCellID forIndexPath:indexPath];
//                    infoCell.model = model;
//                    infoCell.deleteBlock = ^{
//                        [self deleteAccountIdx:indexPath.row];
//                    };
//                    return infoCell;
//                }
//            }
            if (indexPath.row == self.dcboxAccounts.count) { //倒数第二个
                CNAddressAddTCell *addCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressAddTCellID forIndexPath:indexPath];
                addCell.titleLb.text = self.dcboxAccounts.count>2?@"添加小金库":@"一键注册/绑定小金库";
                return addCell;
            } else if (indexPath.row == self.dcboxAccounts.count+1) { //倒数第一个
                CNAddressDownloadTCell *downloadCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressDownloadTCellID forIndexPath:indexPath];
                return downloadCell;
            } else {
                 //卡列表
                AccountModel *model = self.dcboxAccounts[indexPath.row];
                CNAddressInfoTCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressInfoTCellID forIndexPath:indexPath];
                infoCell.model = model;
                infoCell.deleteBlock = ^{
                    [self deleteAccountIdx:indexPath.row];
                };
                return infoCell;
            }
            break;
            
            
        case HYAddressTypeUSDT:
            if (indexPath.row == self.usdtAccounts.count) {
                CNAddressAddTCell *addCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressAddTCellID forIndexPath:indexPath];
                addCell.titleLb.text = @"添加USDT钱包";
                return addCell;
                
            } else {
                AccountModel *model = self.usdtAccounts[indexPath.row];
                CNAddressInfoTCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressInfoTCellID forIndexPath:indexPath];
                infoCell.model = model;
                infoCell.deleteBlock = ^{
                    [self deleteAccountIdx:indexPath.row];
                };
                return infoCell;
            }
            break;
            
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (_addrType) {
        case HYAddressTypeBANKCARD:
            if (indexPath.row == self.bankAccounts.count) { // 添加卡
                CNAddBankCardVC *vc = [CNAddBankCardVC new];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        case HYAddressTypeDCBOX:
//            if (self.dcboxAccounts.count == 0 && indexPath.row == self.dcboxAccounts.count) { //一键注册/绑定小金库
//                WEAKSELF_DEFINE
//                [[ABCOneKeyRegisterBFBHelper shareInstance] startOneKeyRegisterBFBHandler:^{
//                    STRONGSELF_DEFINE
//                    [strongSelf queryAccounts];
//                }];
//
//            } else if (self.dcboxAccounts.count > 0 && indexPath.row == self.dcboxAccounts.count) { // 添加卡
//                CNAddAddressVC *vc = [CNAddAddressVC new];
//                vc.addrType = self.addrType;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
            if (indexPath.row == self.dcboxAccounts.count) { //倒数第二个
                if (self.dcboxAccounts.count > 2) {
                    CNAddAddressVC *vc = [CNAddAddressVC new];
                    vc.addrType = self.addrType;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [[ABCOneKeyRegisterBFBHelper shareInstance] startOneKeyRegisterBFBHandler:^{
                        [self queryAccounts];
                    }];
                }
            }
            break;
            
        case HYAddressTypeUSDT:
            if (indexPath.row == self.usdtAccounts.count) { // 添加卡
                CNAddAddressVC *vc = [CNAddAddressVC new];
                vc.addrType = self.addrType;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        default:
            break;
    }
}

@end
