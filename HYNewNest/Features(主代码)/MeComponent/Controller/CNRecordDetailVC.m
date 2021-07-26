//
//  CNRecordDetailVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNRecordDetailVC.h"
#import "CNXimaRecordTCell.h"
#import "CNTwoStatusBtn.h"
#import "CNUserCenterRequest.h"
#import "UILabel+Gradient.h"
#import "BYDepositUsdtVC.h"
#import "HYRechargeCNYViewController.h"
#import "BYYuEBaoVC.h"

#define kCNXimaRecordTCellID  @"CNXimaRecordTCell"

@interface CNRecordDetailVC () <UITableViewDataSource>

#pragma - mark UI不同
/// 流水视图
@property (weak, nonatomic) IBOutlet UIView *flowView;
/// 流水视图高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowViewH;

/// 投注视图
@property (weak, nonatomic) IBOutlet UIView *touZhuView;
/// 投注视图高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touZhuViewH;

/// 进度视图
@property (weak, nonatomic) IBOutlet UIView *processView;
/// 进度视图高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processViewH;

/// 洗码视图（带标题）
@property (weak, nonatomic) IBOutlet UIView *xiMaView;
/// 洗码列表内容
@property (weak, nonatomic) IBOutlet UITableView *xiMaTabelView;
/// 洗码列表视图高（不带标题，仅内容）
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xiMaContentH;
@property (weak, nonatomic) IBOutlet CNTwoStatusBtn *btnBtm;


#pragma - mark 数据展示
/// 单位
@property (weak, nonatomic) IBOutlet UILabel *currencyLb;
/// 金额
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
/// 订单状态，颜色值（已到账、充值完成：5A9F7C；等待支付：AEA876；交易失败：BD4848）最好和数据源绑定
@property (weak, nonatomic) IBOutlet UILabel *recordStatusLb;
/// 交易类型
@property (weak, nonatomic) IBOutlet UILabel *tradeTypeLb;
/// 流水号
@property (weak, nonatomic) IBOutlet UILabel *flowLb;
/// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
/// 局号
@property (weak, nonatomic) IBOutlet UILabel *juHaoLb;
/// 下注厅
@property (weak, nonatomic) IBOutlet UILabel *touZhuTingLb;
/// 游戏名称
@property (weak, nonatomic) IBOutlet UILabel *gameNameLb;
/// 派彩
@property (weak, nonatomic) IBOutlet UILabel *paiCaiLb;
/// 处理进度
@property (weak, nonatomic) IBOutlet UIButton *processbtn;


@property (nonatomic, assign) CNRecordDetailType detailType;
@property (nonatomic, assign) NSInteger ximaItem;
@end

@implementation CNRecordDetailVC

- (instancetype)initWithType:(CNRecordDetailType)detailType {
    if (self = [super init]) {
        self.detailType = detailType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self configUI];
    
    // 洗码数据类别个数
    self.ximaItem = 5;
    [self reloadXiMaTabelView];
}

- (void)configUI {
    /// 通用参数
    self.currencyLb.text = [CNUserManager shareManager].userInfo.currency;
    self.amountLb.text = self.model.amount?:self.model.betAmount;
    [self.amountLb setupGradientColorDirection:BYLblGrdtColorDirectionTopRightBtmLeft From:kHexColor(0x19CECE) toColor:kHexColor(0x10B4DD)];
    self.recordStatusLb.text = self.model.flagDesc;
    self.recordStatusLb.textColor = self.model.statsColor;
    self.tradeTypeLb.text = self.model.title;
    self.flowLb.text = self.model.referenceId?:self.model.requestId;
    self.timeLb.text = self.model.createDate?:self.model.createdTime;
    
    // 存取款才有
    NSString *flag = @"";
    if (self.model.flag == transactionProgress_processingState || self.model.flag == transactionProgress_waitPayState ||
        self.model.flag == transactionProgress_waitCheckState) {
        flag = @"等不及了，催客服";
        self.processbtn.tag = 111;
    }else{
        flag = @"有疑问？联系客服";
        self.processbtn.tag = 222;
    }
    [self.processbtn setTitle:flag forState:UIControlStateNormal];
    [self.processbtn addTarget:self action:@selector(clickSpecialBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.xiMaTabelView.backgroundColor = self.touZhuView.backgroundColor = self.view.backgroundColor;
    
    self.xiMaTabelView.dataSource = self;
    [self.xiMaTabelView registerNib:[UINib nibWithNibName:kCNXimaRecordTCellID bundle:nil] forCellReuseIdentifier:kCNXimaRecordTCellID];
    
    switch (self.detailType) {
        case CNRecordTypeYEBDeposit:
            self.title = @"余额宝转入详情";
            self.touZhuView.hidden = YES;
            self.touZhuViewH.constant = 0;
            self.recordStatusLb.text = self.model.yebStatusTxt;
            self.xiMaView.hidden = YES;
            self.tradeTypeLb.text = @"USDT支付";
            self.processView.hidden = YES;
            self.processViewH.constant = 0;
            break;
            
        case CNRecordTypeYEBWithdraw:
            self.title = @"余额宝转出详情";
            self.touZhuView.hidden = YES;
            self.touZhuViewH.constant = 0;
            self.recordStatusLb.text = self.model.yebStatusTxt;
            self.xiMaView.hidden = YES;
            self.tradeTypeLb.text = @"USDT支付";
            self.processView.hidden = YES;
            self.processViewH.constant = 0;
            break;
            
        case CNRecordTypeDeposit:
            self.title = [CNUserManager shareManager].isUsdtMode?@"充币详情":@"充值详情";
            self.touZhuView.hidden = YES;
            self.touZhuViewH.constant = 0;
            
            self.xiMaView.hidden = YES;
            
            [self.btnBtm setTitle:@"继续充值" forState:UIControlStateNormal];
            self.btnBtm.hidden = NO;
            self.btnBtm.enabled = YES;
            break;
            
        case CNRecordTypeWithdraw:
            self.title = [CNUserManager shareManager].isUsdtMode?@"提币详情":@"提现详情";
            self.touZhuView.hidden = YES;
            self.touZhuViewH.constant = 0;
            
            self.xiMaView.hidden = YES;
            
            if (self.model.flag == transactionProgress_waitCheckState ||
                self.model.flag == transactionProgress_waitPayState) {
                [self.btnBtm setTitle:@"取消订单" forState:UIControlStateNormal];
                self.btnBtm.hidden = NO;
                self.btnBtm.enabled = YES;
            }
            break;
            
        case CNRecordTypeXima:
            self.title = @"洗码详情";
            self.flowView.hidden = YES;
            self.flowViewH.constant = 0;
            
            self.touZhuView.hidden = YES;
            self.touZhuViewH.constant = 0;
            
            self.xiMaView.hidden = YES;//暂时不知道用什么数据
            
            break;
            
        case CNRecordTypePromo:
            self.title = @"优惠领取详情";
            
            self.touZhuView.hidden = YES;
            self.touZhuViewH.constant = 0;
            
            self.xiMaView.hidden = YES;
            
            self.processView.hidden = YES;
            self.processViewH.constant = 0;
            break;
            
        case CNRecordTypeTouZhu:
            self.title = @"投注详情";
            self.flowView.hidden = YES;
            self.flowViewH.constant = 0;
            
            self.xiMaView.hidden = YES;
            
            self.processView.hidden = YES;
            self.processViewH.constant = 0;
            
            // 投注的数据不同
            self.tradeTypeLb.text = _model.gameKindName;
            self.timeLb.text = _model.billTime;
            self.juHaoLb.text = _model.gmCode;
            self.gameNameLb.text = _model.gameType;
            self.touZhuTingLb.text = _model.gamePlatName;
            self.paiCaiLb.text = [_model.payoutAmount stringByAppendingString:[CNUserManager shareManager].isUsdtMode?@" USDT":@" CNY"];
            break;
    }
}

// xima展开隐藏
- (IBAction)xiMaShowHide:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.xiMaContentH.constant = 30 * self.ximaItem;
        self.xiMaTabelView.hidden = NO;
    } else {
        self.xiMaContentH.constant = 0;
        self.xiMaTabelView.hidden = YES;
    }
}

- (IBAction)btmButtonClick:(id)sender {
    if (self.detailType == CNRecordTypeDeposit) {
        if ([CNUserManager shareManager].isUsdtMode) {
            [self.navigationController pushViewController:[BYDepositUsdtVC new] animated:YES];
        } else {
            [self.navigationController pushViewController:[HYRechargeCNYViewController new] animated:YES];
        }
        
    } else if (self.detailType == CNRecordTypeWithdraw || self.detailType == CNRecordTypeYEBWithdraw) {
        //TODO: 不知道能不能取消 等接口数据出来
        [CNUserCenterRequest cancelWithdrawBillRequestId:self.model.requestId handler:^(id responseObj, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg)) {
                [CNTOPHUB showSuccess:@"订单取消成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:HYSwitchAcoutSuccNotification object:nil]; // 让首页和我的余额刷新
                self.btnBtm.enabled = NO;
                self.navPopupBlock(@(1)); //需要刷新
            }
        }];
        
    } else if (self.detailType == CNRecordTypeYEBDeposit) {
        [self.navigationController pushViewController:[BYYuEBaoVC new] animated:YES];
        
    }
}

- (void)reloadXiMaTabelView {
    self.xiMaContentH.constant = 30 * self.ximaItem;
}

/// 催单 & 跳客服
- (void)clickSpecialBtn:(UIButton *)btn {
    if (btn.tag == 111) {
        [CNUserCenterRequest reminderBillReferenceId:self.model.requestId
                                                type:self.detailType == CNRecordTypeDeposit?1:2
                                             handler:^(id responseObj, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg)) {
                [self.view jk_makeToast:@"客服已收到您的订单请求，请再稍等一下，马上就好" duration:4 position:JKToastPositionCenter];
            }
        }];
    } else {
        [NNPageRouter presentOCSS_VC];
    }
}

#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ximaItem;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CNXimaRecordTCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNXimaRecordTCellID forIndexPath:indexPath];
    return cell;
}

@end
