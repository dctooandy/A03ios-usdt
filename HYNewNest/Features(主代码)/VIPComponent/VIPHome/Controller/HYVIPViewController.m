//
//  HYVIPViewController.m
//  HYNewNest
//
//  Created by zaky on 8/24/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYVIPViewController.h"
#import "UILabel+Gradient.h"
#import "DXRadianLayerView.h"
#import "UUMarqueeView.h"
#import "CNVIPRequest.h"
#import "JLXUICollectionViewFlowLayout.h"
#import "VIPCardCCell.h"
#import "TAPageControl.h"
#import "VIPMonthlyAlertsVC.h"
#import "CNMessageBoxView.h"
#import "VIPTwoChartVC.h"
#import "CNLoginRegisterVC.h"
#import "HYVIPCumulateIdVC.h"

static NSString * const kVIPCardCCell = @"VIPCardCCell";
@interface HYVIPViewController () <UUMarqueeViewDelegate>
{
    // collectionView 起始&终止x位置
    CGFloat m_dragStartX;
    CGFloat m_dragEndX;
}
@property (nonatomic, assign) NSInteger m_currentIndex;
// 最顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginConstrain;
// 顶部背景
@property (weak, nonatomic) IBOutlet DXRadianLayerView *topRadianView;
// 底部背景
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
// vip私享会2.0
@property (weak, nonatomic) IBOutlet UIButton *vipSxhTopBtn;


// -------- 顶部卡片 --------
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCard;
@property (weak, nonatomic) IBOutlet TAPageControl *pageControl;
// 会员权益
@property (weak, nonatomic) IBOutlet UILabel *lbVipRight;


// -------- 大奖公告 --------
@property (weak, nonatomic) IBOutlet UILabel *lblDjgg;
// 获奖轮播
@property (strong,nonatomic) UUMarqueeView *marqueeView;


// -------- 本月进度 --------
@property (weak, nonatomic) IBOutlet UIView *ByjdTopBg;
@property (weak, nonatomic) IBOutlet UIView *ByjdBtmBg;
@property (weak, nonatomic) IBOutlet UILabel *lblByjdSubTitle;
@property (weak, nonatomic) IBOutlet UIView *lineDepositPrgsBG;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

// 本月流水
@property (weak, nonatomic) IBOutlet UILabel *lblThisMonthAmount;
// 下一等级流水
@property (weak, nonatomic) IBOutlet UILabel *lblNextLevelAmount;
// 流水进度条
@property (weak, nonatomic) IBOutlet UIProgressView *prgsViewAmount;

// 本月充值
@property (weak, nonatomic) IBOutlet UILabel *lblThisMonthDeposit;
// 下一等级充值
@property (weak, nonatomic) IBOutlet UILabel *lblNextLevelDeposit;
// 存款进度条
@property (weak, nonatomic) IBOutlet UIProgressView *prgsViewDeposit;
@property (weak, nonatomic) IBOutlet UILabel *lbDuzunTip;//说明：其他达标用户保持赌神

// 累计身份
@property (weak, nonatomic) IBOutlet UIStackView *rankStackView;
@property (weak, nonatomic) IBOutlet UILabel *lbDuzunTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDushenTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDushengTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDuwangTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDubaTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDuxiaTime;
@property (weak, nonatomic) IBOutlet UIView *unloginLbBGView;


// -------- 两个按钮 --------
// 至尊转盘
@property (weak, nonatomic) IBOutlet UIView *ZzzpBg;
// 累计身份
@property (weak, nonatomic) IBOutlet UIView *LjsfBg;


// -------- 数据源 --------
@property (strong, nonatomic) NSArray *cardArray;
@property (strong, nonatomic) VIPHomeUserModel *sxhModel;
@end

@implementation HYVIPViewController


#pragma mark - View Life Cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavgation = YES;
    
    // 顶部卡片部分
    [self setupCollectionView];
    self.pageControl.numberOfPages = 6;
    self.pageControl.dotSize = CGSizeMake(AD(7), AD(7));

    // 月报
    [self requestMonthReport];
    
    // 用户登录状态配置UI & 首页请求数据
    [self userStatusChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:HYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:HYLogoutSuccessNotification object:nil];
    

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 放在这里才能正常绘制
    [self setupUIAttributes];
}

- (void)userStatusChanged {
    // 首页数据
    [self vipHomeData];
    
    if ([CNUserManager shareManager].isLogin) {
        self.lblByjdSubTitle.hidden = NO;
        self.btnLogin.hidden = YES;
        self.rankStackView.hidden = NO;
        self.unloginLbBGView.hidden = YES;
        
    } else {
        self.lblByjdSubTitle.hidden = YES;
        self.btnLogin.hidden = NO;
        self.rankStackView.hidden = YES;
        self.unloginLbBGView.hidden = NO;
        self.prgsViewAmount.progress = 0.0;
        self.prgsViewDeposit.progress = 0.0;
    }
}


#pragma mark - Custom Func
- (void)setupUIAttributes {
    
    if (!KIsIphoneXSeries) {
        self.topMarginConstrain.constant = -kStatusBarHeight;
    }
    
    self.topRadianView.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0x0F2129) toColor:kHexColor(0x0C2928) withHeight:self.topRadianView.height];
    self.topRadianView.radian = 12;
    
    [self.vipSxhTopBtn setTitleColor:[UIColor jk_gradientFromColor:kHexColor(0xFFEFCB) toColor:kHexColor(0xA28455) withHeight:20]
                            forState:UIControlStateNormal];
    
    [self.bottomBgView addSubview:self.marqueeView];
    self.bottomBgView.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0x0A1D25) toColor:kHexColor(0x070D17) withHeight:self.bottomBgView.height];
    
    [self.ByjdTopBg jk_setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:4];
    self.ByjdTopBg.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0xE4D8B4) toColor:kHexColor(0xC3A370) withHeight:40];
    
    self.ByjdBtmBg.backgroundColor = self.LjsfBg.backgroundColor = self.ZzzpBg.backgroundColor = kHexColor(0x212730);
    [self.ByjdBtmBg jk_setRoundedCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:4];
    [self.LjsfBg jk_setRoundedCorners:UIRectCornerAllCorners radius:4];
    [self.ZzzpBg jk_setRoundedCorners:UIRectCornerAllCorners radius:4];
    
}

- (void)setupCollectionView {
    self.cardArray  = @[@{@"赌侠":@"江湖豪侠 出手不凡"},
                        @{@"赌霸":@"雄图霸业 大杀四方"},
                        @{@"赌王":@"赌运亨通 百战称王"},
                        @{@"赌圣":@"圣手搓牌 有叫必应"},
                        @{@"赌神":@"逢赌必赢 赌坛封神"},
                        @{@"赌尊":@"至尊无敌 无所不能"}];
    
    JLXUICollectionViewFlowLayout *layout = [[JLXUICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(AD(333), AD(148));
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = AD(10);
    layout.minimumInteritemSpacing = AD(10);
    [self.collectionViewCard setCollectionViewLayout:layout animated:YES];
    self.collectionViewCard.pagingEnabled = NO;
    self.collectionViewCard.showsHorizontalScrollIndicator = NO;
    self.collectionViewCard.contentSize = CGSizeMake(self.cardArray.count*kScreenWidth, 0);
    [self.collectionViewCard registerNib:[UINib nibWithNibName:kVIPCardCCell bundle:nil] forCellWithReuseIdentifier:kVIPCardCCell];
    
    [self.collectionViewCard reloadData];
    
}

/// 累计身份相关数据
- (void)setupUIDatas {
    [self.collectionViewCard reloadData];
    
    if ([CNUserManager shareManager].isLogin) {
        _lblThisMonthDeposit.text = [NSString stringWithFormat:@"本月充值:%@", [_sxhModel.totalDepositAmount jk_toDisplayNumberWithDigit:2]];
        _lblThisMonthAmount.text = [NSString stringWithFormat:@"本月流水:%@",[_sxhModel.totalBetAmount jk_toDisplayNumberWithDigit:2]];
        
        // 滚动到对应等级 居中
        if (self.sxhModel.clubLevel.integerValue > 0) {
            self.m_currentIndex = self.sxhModel.clubLevel.integerValue - 2;
            [self.collectionViewCard scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self fixCellToCenter];
            });
        } else {
            self.m_currentIndex = 0;
        }
        
    } else {
        _lblThisMonthAmount.text = @"本月流水：-";
        _lblThisMonthDeposit.text = @"本月充值：-";
        self.m_currentIndex = 0;
    }
    
    // 累计身份
    self.lbDuzunTime.text = [NSString stringWithFormat:@"%ld",(long)_sxhModel.historyBet.betZunCount];
    self.lbDushenTime.text = [NSString stringWithFormat:@"%ld",(long)_sxhModel.historyBet.betGoldCount];
    self.lbDushengTime.text = [NSString stringWithFormat:@"%ld",(long)_sxhModel.historyBet.betSaintCount];
    self.lbDuwangTime.text = [NSString stringWithFormat:@"%ld",(long)_sxhModel.historyBet.betKingCount];
    self.lbDubaTime.text = [NSString stringWithFormat:@"%ld",(long)_sxhModel.historyBet.betBaCount];
    self.lbDuxiaTime.text = [NSString stringWithFormat:@"%ld",(long)_sxhModel.historyBet.betXiaCount];

}

#pragma mark - Action
- (IBAction)didTapLogin:(id)sender {
    [self.navigationController pushViewController:[CNLoginRegisterVC loginVC] animated:YES];
}

- (IBAction)didTapVIPSxh:(id)sender {
    [CNMessageBoxView showVIPSXHMessageBoxOnView:self.view];
}

- (IBAction)didTapDashenBoard:(id)sender {
    VIPTwoChartVC *chartVc = [[VIPTwoChartVC alloc] initWithType:VIPChartTypeBigGodBoard];
    [self presentViewController:chartVc animated:YES completion:^{
    }];
}

- (IBAction)didTapMoreRights:(id)sender {
    if (!_sxhModel) {
        [self vipHomeData];
        [kKeywindow jk_makeToast:@"正在为您请求私享会数据.." duration:4 position:JKToastPositionBottom];
        return;
    }
    VIPTwoChartVC *chartVc = [[VIPTwoChartVC alloc] initWithType:VIPChartTypeRankRight];
    chartVc.equityData = self.sxhModel.equityData;
    [self presentViewController:chartVc animated:YES completion:^{
    }];
}

- (IBAction)didTapZZZP:(id)sender {
#ifdef DEBUG
    [NNPageRouter jump2HTMLWithStrURL:@"/sudoku" title:@"至尊转盘"];
#else
    [CNHUB showWaiting:@"十月来袭 敬请期待"];
#endif
}

- (IBAction)didTapLJSF:(id)sender {
#ifdef DEBUG
    HYVIPCumulateIdVC *vc = [HYVIPCumulateIdVC new];
    [self.navigationController pushViewController:vc animated:YES];
#else
    [CNHUB showWaiting:@"十月来袭 敬请期待"];
#endif

}


#pragma mark - Request
- (void)vipHomeData {
    [CNVIPRequest vipsxhHomeHandler:^(id responseObj, NSString *errorMsg) {
        if (KIsEmptyString(errorMsg) && [responseObj isKindOfClass:[NSDictionary class]]) {
            VIPHomeUserModel *model = [VIPHomeUserModel cn_parse:responseObj];
            self.sxhModel = model;
            [self setupUIDatas];
            [self setupRewardMarqueeView];
        }
    }];
}

- (void)requestMonthReport {
    BOOL isReaded = [[NSUserDefaults standardUserDefaults] boolForKey:HYVIPIsAlreadyShowV2Alert];//只显示一次就不再展示了
    if (!isReaded) {
        if (self.childViewControllers.count > 0) {
            return;
        }
        // VIP私享会2.0 弹窗
        [CNMessageBoxView showVIPSXHMessageBoxOnView:self.view];
        
    } else {
        if (![CNUserManager shareManager].isLogin) {
            return;
        }
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[CNMessageBoxView class]]) {
                return;
            }
        }
        [CNVIPRequest vipsxhIsShowReportHandler:^(id responseObj, NSString *errorMsg) {
            if (KIsEmptyString(errorMsg) && [responseObj[@"flag"] integerValue] == 1 && self.childViewControllers.count == 0) {
                VIPMonthlyAlertsVC *vc = [VIPMonthlyAlertsVC new];
                vc.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarHeight);
                //添加子控制器 该方法调用了willMoveToParentViewController：方法
                [self addChildViewController:vc];
                [self.view addSubview:vc.view];
            }
        }];
        
    }
}

//// 抽奖广播
- (void)setupRewardMarqueeView {
    if (self.sxhModel.prizeList.count) {
        [self.marqueeView reloadData];
    }
}


#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
    return self.sxhModel.prizeList.count;
}

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    return 1;
}

- (void)createItemView:(UIView *)itemView forMarqueeView:(UUMarqueeView *)marqueeView{
    
    UILabel *content = [[UILabel alloc] initWithFrame:itemView.bounds];
    content.font = [UIFont fontPFR12];
    content.tag = 1001;
    content.textColor = kHexColor(0xCFA461);
    [itemView addSubview:content];
}

- (void)updateItemView:(UIView *)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView{
        
    VIPRewardAnocModel *model = [self.sxhModel.prizeList objectAtIndex:index];
    UILabel *content = [itemView viewWithTag:1001];
    content.text = [NSString stringWithFormat:@"恭喜 %@ 抽中 %@",model.loginname, model.prizedesc];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cardArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //自定义item的UIEdgeInsets
    return UIEdgeInsetsMake(0, self.view.bounds.size.width/2.0-AD(325)/2, 0, self.view.bounds.size.width/2.0-AD(325)/2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.cardArray[indexPath.item];
    VIPCardCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVIPCardCCell forIndexPath:indexPath];
    cell.cardName = dict.allKeys.firstObject;
    cell.lbTitle.text = dict.allKeys.firstObject;
    cell.lbSubTitle.text = dict.allValues.firstObject;
    cell.duzunName = @"";
    switch (indexPath.row) { //达标人数
        case 0:
            cell.lbReachNum.text = [NSString stringWithFormat:@"本月已达标%@名", self.sxhModel.vipRhqk.betXiaCount];
            break;
        case 1:
            cell.lbReachNum.text = [NSString stringWithFormat:@"本月已达标%@名", self.sxhModel.vipRhqk.betBaCount];
            break;
        case 2:
            cell.lbReachNum.text = [NSString stringWithFormat:@"本月已达标%@名", self.sxhModel.vipRhqk.betKingCount];
            break;
        case 3:
            cell.lbReachNum.text = [NSString stringWithFormat:@"本月已达标%@名", self.sxhModel.vipRhqk.betSaintCount];
            break;
        case 4:
            cell.lbReachNum.text = [NSString stringWithFormat:@"本月已达标%@名", self.sxhModel.vipRhqk.betGoldCount];
            break;
        case 5:
            cell.duzunName = self.sxhModel.vipRhqk.betZunName?:@"";
            cell.lbReachNum.text = [NSString stringWithFormat:@"本月已达标%@名", self.sxhModel.vipRhqk.betZunCount];
            break;
        default:
            break;
    }
    if (indexPath.row == [self.sxhModel.clubLevel integerValue]-2) { //当前等级
        cell.isCurRank = YES;
    } else {
        cell.isCurRank = NO;
    }
    
    return cell;
}


//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    m_dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    m_dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.view.bounds.size.width/20.0f;
    if (m_dragStartX - m_dragEndX >= dragMiniDistance) {
        self.m_currentIndex -= 1;//向右
    }else if(m_dragEndX -  m_dragStartX >= dragMiniDistance){
        self.m_currentIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collectionViewCard numberOfItemsInSection:0] - 1;
    
    self.m_currentIndex = _m_currentIndex <= 0 ? 0 : _m_currentIndex;
    self.m_currentIndex = _m_currentIndex >= maxIndex ? maxIndex : _m_currentIndex;
    
    self.pageControl.currentPage = _m_currentIndex;
    [self.collectionViewCard scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


#pragma mark - SET
//0 - 5 依次是： 赌侠 赌霸 赌王 赌圣 赌神 赌尊
- (void)setM_currentIndex:(NSInteger)m_currentIndex {
    if (m_currentIndex < 0 || m_currentIndex > 5) {
        return;
    }
    _m_currentIndex = m_currentIndex;
    
    NSArray *eqArr = self.sxhModel.equityData;
    EquityDataItem *item = eqArr.count>0 ? eqArr[m_currentIndex] : nil;
    
    // 修改入会礼金 等级要求流水和存款
    if (item) {
        self.lbVipRight.text = [NSString stringWithFormat:@"会员权益: 入会礼金%@usdt", [item.rhljAmount jk_toDisplayNumberWithDigit:0]];
        self.lblNextLevelAmount.text = [[item.betAmount jk_toDisplayNumberWithDigit:2] stringByAppendingFormat:@" usdt"];
        self.lblNextLevelDeposit.text = [[item.depositAmount jk_toDisplayNumberWithDigit:2] stringByAppendingFormat:@" usdt"];
        
        float amoutPrgs = [_sxhModel.totalBetAmount floatValue] / [item.betAmount floatValue];
        self.prgsViewAmount.progress = amoutPrgs;
        self.prgsViewAmount.tintColor = amoutPrgs >= 1.0 ? kHexColor(0xE11470) : kHexColor(0x3AE3C5);
        
        float depoPrgs = [_sxhModel.totalDepositAmount floatValue] / [item.depositAmount floatValue];
        self.prgsViewDeposit.progress = depoPrgs;
        self.prgsViewDeposit.tintColor = depoPrgs >= 1.0 ? kHexColor(0xE11470) : kHexColor(0x3AE3C5);
    }
    
    self.prgsViewDeposit.hidden = NO;
    self.lblNextLevelDeposit.hidden = NO;
    self.lblThisMonthDeposit.hidden = NO;
    self.lineDepositPrgsBG.hidden = NO;
    self.lbDuzunTip.hidden = YES;
    
    // 修改提示文字 赌尊单独修改部分内容
    switch (m_currentIndex) {
        case 0:
            self.lblByjdSubTitle.text = self.sxhModel.clubLevel.integerValue>=2 ? @"(您已达标赌侠 继续加油哦)" : @"(择一达成 晋级赌侠)";
            break;
        case 1:
            self.lblByjdSubTitle.text = self.sxhModel.clubLevel.integerValue>=3 ? @"(您已达标赌霸 继续加油哦)" : @"(择一达成 晋级赌霸)";
            break;
        case 2:
            self.lblByjdSubTitle.text = self.sxhModel.clubLevel.integerValue>=4 ? @"(您已达标赌王 继续加油哦)" : @"(择一达成 晋级赌王)";
            break;
        case 3:
            self.lblByjdSubTitle.text = self.sxhModel.clubLevel.integerValue>=5 ? @"(您已达标赌圣 继续加油哦)" : @"(择一达成 晋级赌圣)";
            break;
        case 4:
            self.lblByjdSubTitle.text = self.sxhModel.clubLevel.integerValue>=6 ? @"(您已达标赌神 继续加油哦)" : @"(择一达成 晋级赌神)";
            break;
        case 5:
            self.lblByjdSubTitle.text =  self.sxhModel.clubLevel.integerValue==7 ? @"(您已达标,流水最高可晋级赌尊)" : @"(达标且流水最高晋级唯一赌尊)";
            
            // 赌尊流水进度有变化
            if (self.sxhModel.clubLevel.integerValue == 7) {
                float amoutPrgs = [_sxhModel.totalBetAmount floatValue] / [_sxhModel.vipRhqk.betAmount floatValue];
                self.prgsViewAmount.progress = amoutPrgs;
                self.prgsViewAmount.tintColor = amoutPrgs >= 1.0 ? kHexColor(0xE11470) : kHexColor(0x3AE3C5);
                self.lblNextLevelAmount.text = amoutPrgs >= 1.0 ? @"当前最高" : [NSString stringWithFormat:@"当前最高%@ usdt", _sxhModel.vipRhqk.betAmount];
            }
            
            // 赌尊隐藏存款进度
            self.lbDuzunTip.hidden = NO;
            self.prgsViewDeposit.hidden = YES;
            self.lblNextLevelDeposit.hidden = YES;
            self.lblThisMonthDeposit.hidden = YES;
            self.lineDepositPrgsBG.hidden = YES;
            break;
        default:
            break;
    }
}


#pragma mark - Lazy Load

- (UUMarqueeView *)marqueeView{
    if (!_marqueeView) {
        _marqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(self.lblDjgg.right + 5, self.lblDjgg.top - 5, kScreenWidth-self.lblDjgg.right-20, 30)];
        _marqueeView.delegate = self;
        _marqueeView.timeIntervalPerScroll = 1.0f;
        _marqueeView.timeDurationPerScroll = 1.0f;
        _marqueeView.touchEnabled = NO;
    }
    return _marqueeView;
}


@end
