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

@interface HYVIPViewController () <UUMarqueeViewDelegate>
// 顶部背景
@property (weak, nonatomic) IBOutlet DXRadianLayerView *topRadianView;
// 底部背景
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
// vip私享会2.0
@property (weak, nonatomic) IBOutlet UILabel *sxhTopLb;

// -------- 顶部卡片 --------
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCard;


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
@property (weak, nonatomic) IBOutlet UILabel *lbDuzunTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDushenTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDushengTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDuwangTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDubaTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDuxiaTime;

// -------- 两个按钮 --------
// 至尊转盘
@property (weak, nonatomic) IBOutlet UIView *ZzzpBg;
// 累计身份
@property (weak, nonatomic) IBOutlet UIView *LjsfBg;

// -------- 数据源 --------
@property (strong, nonatomic) NSArray <VIPRewardAnocModel *>* rewards;
@property (strong, nonatomic) VIPLevelData *vipLevel;

@end

@implementation HYVIPViewController


#pragma mark - View Life Cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUIAttributes];
    
    [self requestRewardAnnouncement];
    if ([CNUserManager shareManager].isLogin) {
        [self requestUsrVIPPromotion];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUsrVIPPromotion) name:HYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usrDidLogout) name:HYLogoutSuccessNotification object:nil];
}


#pragma mark - Custom Func
- (void)setupUIAttributes {
    self.hideNavgation = YES;
    
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

- (void)usrDidLogout {
    
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
