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
#import "BYModifyPhoneVC.h"

#import "CNAddressAddTCell.h"
#define kCNAddressAddTCellID  @"CNAddressAddTCell"
#import "CNAddressInfoTCell.h"
#define kCNAddressInfoTCellID  @"CNAddressInfoTCell"
#import "CNAddressDownloadTCell.h"
#define kCNAddressDownloadTCellID  @"CNAddressDownloadTCell"

#import "HYTextAlertView.h"

#import "CNWDAccountRequest.h"
#import "ABCOneKeyRegisterBFBHelper.h"
#import <IVLoganAnalysis/IVLAManager.h>

#import "BYDeleteBankCardVC.h"

@interface CNAddressManagerVC () <UITableViewDelegate, UITableViewDataSource>
// 顶部页签
@property (weak, nonatomic) IBOutlet UIButton *goldBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentViewH;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

/// 卡列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 底部提示文字
@property (nonatomic, strong) UIView *btmBFBTipLb;
@property (strong,nonatomic) UIView *btmBankTipLb;

/// 区分当前是小金库地址还是其他地址
@property (nonatomic, assign) HYAddressType addrType;
/// 数据源
@property (nonatomic, strong) NSArray<AccountModel *> *bankAccounts;
@property (nonatomic, strong) NSArray<AccountModel *> *dcboxAccounts;
@property (nonatomic, strong) NSArray<AccountModel *> *usdtAccounts;
@end

@implementation CNAddressManagerVC

#pragma mark - LazyLoad

- (UIView *)btmBFBTipLb {
    if (!_btmBFBTipLb) {
        UILabel *btmBFBTipLb = [UILabel new];
        btmBFBTipLb.numberOfLines = 0;
        btmBFBTipLb.textColor = kHexColor(0x656565);
        btmBFBTipLb.font = [UIFont systemFontOfSize:AD(12)];
        btmBFBTipLb.textAlignment = NSTextAlignmentCenter;
        btmBFBTipLb.text = @"  温馨提示：币付宝钱包地址不支持取款,请删除绑定其他钱包地址  ";
        [btmBFBTipLb sizeToFit];
        btmBFBTipLb.frame = CGRectMake(20, 0, kScreenWidth-40, 60);
//        btmBFBTipLb.backgroundColor = [UIColor clearColor];
        
        UIView *bgv = [UIView new];
        bgv.backgroundColor = [UIColor clearColor];
        bgv.frame = CGRectMake(0, 0, kScreenWidth, 60);
        [bgv addSubview:btmBFBTipLb];
        
        _btmBFBTipLb = bgv;
    }
    return _btmBFBTipLb;
}

- (UIView *)btmBankTipLb {
    if (!_btmBankTipLb) {
        UILabel *attrLb = [UILabel new];
        attrLb.numberOfLines = 0;
        UIColor *gdColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:280];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@" CNY充值时，付款人姓名必须和银行卡绑定姓名一致" attributes:@{NSFontAttributeName:[UIFont fontPFR12], NSForegroundColorAttributeName:gdColor}];
        
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"yellow exclamation"];
        attch.bounds = CGRectMake(0, 0, 12, 12);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attrStr insertAttributedString:string atIndex:0];
        
        attrLb.attributedText = attrStr;
        [attrLb sizeToFit];
        attrLb.frame = CGRectMake(30, 0, kScreenWidth-60, 60);
        
        UIView *bgv = [UIView new];
        bgv.backgroundColor = [UIColor clearColor];
        bgv.frame = CGRectMake(0, 0, kScreenWidth, 60);
        [bgv addSubview:attrLb];
        
        _btmBankTipLb = bgv;
    }
    return _btmBankTipLb;
}

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [CNUserManager shareManager].isUsdtMode ? @"提币地址管理" : @"银行卡管理";
    [self addNaviRightItemWithImageName:@"kf"];
    
    [self configUI];
    
    if ([CNUserManager shareManager].isUsdtMode) {
        //usdt模式
        self.addrType = HYAddressTypeDCBOX;
        self.tableView.tableFooterView = self.btmBFBTipLb;
    } else {
        //RMB模式
        self.addrType = HYAddressTypeBANKCARD;
        self.segmentView.hidden = YES;
        self.segmentViewH.constant = 0;
        self.tableView.tableFooterView = self.btmBankTipLb;
    }
}

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC];
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
        if (errorMsg || ![responseObj isKindOfClass:[NSDictionary class]]) {
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
    
    [BYDeleteBankCardVC modalVcWithBankModel:model handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [CNTOPHUB showSuccess:@"删除成功"];
            [self queryAccounts];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [IVLAManager singleEventId:@"A03_bankcard_update"];
            });
            
        }
    }];
//    [HYTextAlertView showWithTitle:@"确定删除？" content:@"删除后不可恢复，只能重新添加" comfirmText:@"删除" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm){
//        if (!isComfirm) {
//            return;
//        }
//        // 先封印,之后回来解开,要先绑架到另一个VC去
//        AccountModel *model;
//        switch (self.addrType) {
//            case HYAddressTypeBANKCARD:
//                model = self.bankAccounts[idx];
//                break;
//            case HYAddressTypeDCBOX:
//                model = self.dcboxAccounts[idx];
//                break;
//            case HYAddressTypeUSDT:
//                model = self.usdtAccounts[idx];
//                break;
//        }
//        [CNWDAccountRequest deleteAccountId:model.accountId handler:^(id responseObj, NSString *errorMsg) {
//            if (!errorMsg) {
//                [CNTOPHUB showSuccess:@"删除成功"];
//                [self queryAccounts];
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    [IVLAManager singleEventId:@"A03_bankcard_update"];
//                });
//            }
//        }];
//    }];
}


#pragma - mark UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_addrType == HYAddressTypeDCBOX && self.dcboxAccounts.count == 0 && indexPath.row == 1) {
        return 180; // 下载小金库高度
    } else {
        return 115;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_addrType) {
        case HYAddressTypeBANKCARD:
            //有卡：显示卡和添加；无卡：显示添加
            return self.bankAccounts.count > 0 ? (self.bankAccounts.count < 3 ? self.bankAccounts.count + 1 : self.bankAccounts.count) : 1;
            break;
        case HYAddressTypeDCBOX:
            //有卡：显示卡和添加和下载，有三张卡：没有添加；无卡：显示一键绑定和下载
            return self.dcboxAccounts.count == 3 ? self.dcboxAccounts.count+1 : self.dcboxAccounts.count+2;
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
    self.btmBFBTipLb.hidden = YES;
    
    switch (_addrType) {
        case HYAddressTypeBANKCARD:
            if (indexPath.row == self.bankAccounts.count) {
                CNAddressAddTCell *addCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressAddTCellID forIndexPath:indexPath];
                addCell.titleLb.text = @"添加银行卡";
                return addCell;
                
            } else {
                AccountModel *model = self.bankAccounts[indexPath.row];
                BOOL isShowButton = (self.bankAccounts.count > 1 ? YES : NO);
                CNAddressInfoTCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressInfoTCellID forIndexPath:indexPath];
                [infoCell setConfig:model withShowDeleteButtonFlag:isShowButton];
//                infoCell.model = model;
                infoCell.deleteBlock = ^{
                    [self deleteAccountIdx:indexPath.row];
                };
                return infoCell;
            }
            break;
            
        case HYAddressTypeDCBOX:
            if (self.dcboxAccounts.count < 3 && indexPath.row == self.dcboxAccounts.count) { //倒数第二个
                CNAddressAddTCell *addCell = [tableView dequeueReusableCellWithIdentifier:kCNAddressAddTCellID forIndexPath:indexPath];
                addCell.titleLb.text = self.dcboxAccounts.count>0?@"添加小金库":@"一键注册/绑定小金库";
                return addCell;
            } else if ((indexPath.row == self.dcboxAccounts.count+1) ||
                       (indexPath.row == self.dcboxAccounts.count && self.dcboxAccounts.count == 3)) { //倒数第一个
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
            self.btmBFBTipLb.hidden = NO;
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
            if (self.dcboxAccounts.count < 3 && indexPath.row == self.dcboxAccounts.count) { //倒数第二个
                if (self.dcboxAccounts.count > 0) {
                    CNAddAddressVC *vc = [CNAddAddressVC new];
                    vc.addrType = self.addrType;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    if (![CNUserManager shareManager].userDetail.mobileNoBind) {
                        [HYTextAlertView showWithTitle:@"手机绑定" content:@"对不起！系统发现您还没有绑定手机，请先完成手机绑定流程，再进行添加地址操作。" comfirmText:@"确定" cancelText:@"取消" comfirmHandler:^(BOOL isComfirm) {
                            if (isComfirm) {
                                [BYModifyPhoneVC modalVcWithSMSCodeType:CNSMSCodeTypeBindPhone];
                            }
                        }];
                        
                    } else {
                        [[ABCOneKeyRegisterBFBHelper shareInstance] startOneKeyRegisterBFBHandler:^{
                            [self queryAccounts];
                        }];
                    }
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
