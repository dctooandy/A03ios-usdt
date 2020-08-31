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

static NSString * const kVIPCardCCell = @"VIPCardCCell";
@interface HYVIPViewController () <UUMarqueeViewDelegate>
{
    // collectionView 滚动相关
    NSInteger m_currentIndex;
    CGFloat m_dragStartX;
    CGFloat m_dragEndX;
}
// 顶部背景
@property (weak, nonatomic) IBOutlet DXRadianLayerView *topRadianView;
// 底部背景
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
// vip私享会2.0
@property (weak, nonatomic) IBOutlet UILabel *sxhTopLb;

// -------- 顶部卡片 --------
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCard;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


// -------- 大奖公告 --------
@property (weak, nonatomic) IBOutlet UILabel *lblDjgg;
// 获奖轮播
@property (strong,nonatomic) UUMarqueeView *marqueeView;

// -------- 本月进度 --------
@property (weak, nonatomic) IBOutlet UIView *ByjdTopBg;
@property (weak, nonatomic) IBOutlet UILabel *lblByjd;
@property (weak, nonatomic) IBOutlet UIView *ByjdBtmBg;

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
@property (strong, nonatomic) NSArray <VIPRewardAnocModel *>* rewards;
@property (strong, nonatomic) VIPLevelData *vipLevel;
@property (strong,nonatomic) NSArray *cardArray;
@end

@implementation HYVIPViewController


#pragma mark - View Life Cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavgation = YES;
    [self setupCollectionView];
    
    [self requestRewardAnnouncement];
    [self userStatusChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:HYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:HYLogoutSuccessNotification object:nil];
    
    m_currentIndex = 0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setupUIAttributes];
}

- (void)userStatusChanged {
    if ([CNUserManager shareManager].isLogin) {
        [self requestUsrVIPPromotion];
        self.rankStackView.hidden = NO;
        self.unloginLbBGView.hidden = YES;
    } else {
        self.rankStackView.hidden = YES;
        self.unloginLbBGView.hidden = NO;
    }
}


#pragma mark - Custom Func
- (void)setupUIAttributes {
    
    self.topRadianView.backgroundColor = [UIColor jk_gradientFromColor:kHexColor(0x0F2129) toColor:kHexColor(0x0C2928) withHeight:self.topRadianView.height];
    self.topRadianView.radian = 12;
    
    [self.sxhTopLb setupGradientColorFrom:kHexColor(0xFFEFCB) toColor:kHexColor(0xA28455)];
    
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

- (void)usrDidLogout {
    //TODO:
}


#pragma mark - Action
- (IBAction)didTapDashenBoard:(id)sender {
    MyLog(@"大神吧");
}

- (IBAction)didTapMoreRights:(id)sender {
    MyLog(@"更多特权");
}

- (IBAction)didTapZZZP:(id)sender {
    MyLog(@"至尊转盘");
}

- (IBAction)didTapLJSF:(id)sender {
    MyLog(@"累计身份");
}


#pragma mark - Request
- (void)requestRewardAnnouncement {
    [CNVIPRequest requestRewardBroadcastHandler:^(id responseObj, NSString *errorMsg) {
        self.rewards = [VIPRewardAnocModel cn_parse:responseObj];
        [self.marqueeView reloadData];
    }];
}

- (void)requestUsrVIPPromotion {
    [CNVIPRequest requestVIPPromotionHandler:^(id responseObj, NSString *errorMsg) {
        self.vipLevel = [VIPLevelData cn_parse:responseObj];
        //TODO: 带入数据
    }];
}

#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
    return self.rewards.count;
}

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView*)marqueeView {
    return 1;
}

- (void)createItemView:(UIView *)itemView forMarqueeView:(UUMarqueeView *)marqueeView{
    
    UILabel *content = [[UILabel alloc] initWithFrame:itemView.bounds];
    content.font = [UIFont systemFontOfSize:10.0f];
    content.tag = 1001;
    [itemView addSubview:content];
}

- (void)updateItemView:(UIView *)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView{
        
    VIPRewardAnocModel *model = [self.rewards objectAtIndex:index];
    if (model) {
        UILabel *content = [itemView viewWithTag:1001];
        content.textColor = kHexColor(0xCFA461);
        content.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        content.text = [NSString stringWithFormat:@"恭喜 %@ 抽中 %@",model.loginname,model.prizeName];
    }
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
        m_currentIndex -= 1;//向右
    }else if(m_dragEndX -  m_dragStartX >= dragMiniDistance){
        m_currentIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collectionViewCard numberOfItemsInSection:0] - 1;
    
    m_currentIndex = m_currentIndex <= 0 ? 0 : m_currentIndex;
    m_currentIndex = m_currentIndex >= maxIndex ? maxIndex : m_currentIndex;
    
    self.pageControl.currentPage = m_currentIndex;
    [self.collectionViewCard scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:m_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
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
