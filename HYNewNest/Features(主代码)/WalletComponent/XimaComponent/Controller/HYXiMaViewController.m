//
//  HYXiMaViewController.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "HYXiMaViewController.h"
#import "HYXiMaTopView.h"
#import "HYXiMaCell.h"
#import "CNTwoStatusBtn.h"
#import "CNXiMaRequest.h"
#import <MJRefresh.h>
#import "HYXiMaSuccViewController.h"
#import "HYWideOneBtnAlertView.h"
#import "HYOneBtnAlertView.h"
#import "HYTextAlertView.h"

@interface HYXiMaViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet HYXiMaTopView *topView;
//@property (nonatomic, strong) XmPlatformModel *xmPlatfModel;
@property (nonatomic, strong) NSArray<XmPlatformListItem *> *xmPlfListItems;
@property (nonatomic, strong) XmCalcAmountModel *xmCalAmountModel;
@property (nonatomic, strong) NSArray<XmTypesItem *> *xmTypeItems;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *washBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, strong) NSMutableArray *selectedIndexs;
@end

@implementation HYXiMaViewController
static NSString * const KXiMaCell = @"HYXiMaCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"洗码";
    [self addNaviRightItemWithImageName:@"service"];
    
    self.amount = 0.f;
    self.selectedIndexs = @[].mutableCopy;
    
    [self setupTopView];
    [self setupTableView];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)rightItemAction {
    [NNPageRouter presentOCSS_VC];
}

- (void)setupTopView {
    self.topView.lblTitle.text = @"洗码总额";
    self.topView.clickBlock = ^{
        NSString *content;
        if ([CNUserManager shareManager].isUsdtMode) {
            content = @"1. 洗码金额不足1 USDT不予添加；\n\n2. 周一16点之前系统会自动结算洗码；\n\n3. 新会员首次需由系统自动洗码，不能手动洗码；\n\n4. 所有游戏都需满足1倍流水才能提币；\n\n5. 币游保留对洗码优惠的最终解释权，一旦发现套利行为，币游有权扣除其所得额度。";
        } else {
            content = @"1. 洗码金额不足5元无法洗出，周洗码不足1元不予添加；\n\n2. 周一16点之前系统会自动结算洗码；\n\n3. 新会员首次需由系统自动洗码，不能手动洗码；\n\n4. 所有游戏都需满足1倍流水才能提币；\n\n5. 币游保留对洗码优惠的最终解释权，一旦发现套利行为，币游有权扣除其所得额度。";
        }
        [HYWideOneBtnAlertView showWithTitle:@"洗码规则" content:content comfirmText:@"我知道了" comfirmHandler:^{
        }];
    };
}

- (void)setupTableView {
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = 149;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kSafeAreaHeight+24+48, 0);
    [self.tableView registerNib:[UINib nibWithNibName:KXiMaCell bundle:nil] forCellReuseIdentifier:KXiMaCell];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    self.washBtn.enabled = NO;
    self.washBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.washBtn.layer.shadowOffset = CGSizeMake(2.0, 2.0f);
    self.washBtn.layer.shadowOpacity = 0.13f; //透明度

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //底部渐变遮罩
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, kScreenWidth, self.view.height);
    gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor,(__bridge id)[UIColor clearColor].CGColor];
    gradientLayer.locations = @[@(0.93),@(1)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);

    UIView *gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height)];
    [gradientView.layer addSublayer:gradientLayer];
    self.view.maskView = gradientView;
}


#pragma mark - ACTION
/// 全部洗码
- (IBAction)allWashClick:(id)sender {
    NSMutableArray *selTypeItems = @[].mutableCopy;
    for (NSNumber *idxNum in self.selectedIndexs) {
        XmTypesItem *item = self.xmTypeItems[[idxNum intValue]];
        [selTypeItems addObject:item];
    }
    WEAKSELF_DEFINE
    [CNXiMaRequest xmCheckAvaliableHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            if ([responseObj[@"flag"] isEqualToNumber:@(1)]) { //可以自主洗码
                [CNXiMaRequest xmCreateRequestXmBeginDate:self.xmCalAmountModel.xmBeginDate
                                                xmEndDate:self.xmCalAmountModel.xmEndDate
                                               xmRequests:selTypeItems
                                                  handler:^(id responseObj, NSString *errorMsg) {
                    STRONGSELF_DEFINE
                    if (KIsEmptyString(errorMsg)) {
                        [CNTOPHUB showSuccess:@"洗码成功"];
                        [strongSelf.selectedIndexs removeAllObjects];
                        [strongSelf requestData];
                        // 到洗码完成
                        HYXiMaSuccViewController *vc = [HYXiMaSuccViewController new];
                        vc.totalAmount = self.amount;
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    }
                }];

            } else {
                [HYOneBtnAlertView showWithTitle:@"温馨提示" content:@"新用户当周无法自主洗码，请等待下周一系统周洗码" comfirmText:@"我知道了" comfirmHandler:^{
                }];
            }
        }
        
        
    }];
    
}


#pragma mark - DATA

- (void)requestData {
    [CNXiMaRequest xmQueryXmpPlatformHandler:^(id responseObj, NSString *errorMsg) {
        if (errorMsg) {
            [self.tableView.mj_header endRefreshing];
            return;
        }
        
        NSArray<XmPlatformModel *> * platfModels = [XmPlatformModel cn_parse:responseObj];        
        NSMutableArray *allItem = @[].mutableCopy;
        NSMutableArray *allType = @[].mutableCopy;//类型数组
        for (XmPlatformModel *model in platfModels) {
            
            for (XmPlatformListItem *item in model.xmPlatformList) {
                if (!KIsEmptyString(item.xmType)) {
                    NSString *type = item.xmType;
                    [allType addObject:type];
                    [allItem addObject:item];
                }
            }
        }
        self.xmPlfListItems = allItem; //下个方法就无用了
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [CNXiMaRequest xmCalcAmountV3WithXmTypes:allType.copy handler:^(id responseObj, NSString *errorMsg) {
                if (errorMsg || ![responseObj isKindOfClass:[NSDictionary class]]) {
                    [self.tableView.mj_header endRefreshing];
                    return;
                }
                
                XmCalcAmountModel *amoutModel = [XmCalcAmountModel cn_parse:responseObj];
                self.xmCalAmountModel = amoutModel;
                
                NSMutableArray *allTypeItem = @[].mutableCopy;
                NSInteger i = 0;
                for (XmListItem *listItem in amoutModel.xmList) {
                    //避免Server资料错误
                    if (listItem.xmTypes != nil && self.xmPlfListItems.count > 0) {
                        for (XmTypesItem *typeItem in listItem.xmTypes) {
                            XmPlatformListItem *item = self.xmPlfListItems[i];
                            typeItem.xmName = item.xmName;
                            [allTypeItem addObject:typeItem];
                            i ++;
                        }
                    }
                }
                //有金额的排到前面
                NSArray <XmTypesItem *>*data = [allTypeItem sortedArrayUsingComparator:^NSComparisonResult(XmTypesItem * obj1, XmTypesItem * obj2) {
                    return obj1.xmAmount < obj2.xmAmount;
                }];
                self.xmTypeItems = data;
                
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }];
        });
        
    }];
    
}


#pragma mark - TABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.xmTypeItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYXiMaCell * cell = [tableView dequeueReusableCellWithIdentifier:KXiMaCell];
//    XmPlatformListItem *item = self.xmPlfListItems[indexPath.row];
    XmTypesItem *type = self.xmTypeItems[indexPath.row];
    cell.lblName.text = type.xmName;
    cell.lblXimaAmount.text = [NSString stringWithFormat:@"%.2f", type.xmAmount];
    cell.lblBetAmount.text = [NSString stringWithFormat:@"%.2f", type.betAmount];
    cell.lblRate.text = [NSString stringWithFormat:@"%.1f%%", type.xmRate];
    
    if ([self.selectedIndexs containsObject:@(indexPath.row)]) {
        cell.isChoose = YES;
    }else{
        cell.isChoose = NO;
    }
    // cell 置灰 不可点击状态 不做
//    if ([model.xmAmount integerValue] < 5) {
//        [cell setUnenableState];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XmTypesItem *typeItem = [self.xmTypeItems objectAtIndex:indexPath.row];
    
    if ([self.selectedIndexs containsObject:@(indexPath.row)]) {
        [self.selectedIndexs removeObject:@(indexPath.row)];
        self.amount -= typeItem.xmAmount;
        self.topView.lblAmount.text = [NSString stringWithFormat:@"%.2f", self.amount];
    }else{
        [self.selectedIndexs addObject:@(indexPath.row)];
        self.amount += typeItem.xmAmount;
        self.topView.lblAmount.text = [NSString stringWithFormat:@"%.2f", self.amount];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.amount > 0) {
        self.washBtn.enabled = YES;
    }else{
        self.washBtn.enabled = NO;
    }
}

@end
