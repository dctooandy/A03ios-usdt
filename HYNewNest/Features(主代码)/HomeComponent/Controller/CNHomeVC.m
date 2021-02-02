//
//  CNHomeVC.m
//  HYNewNest
//
//  Created by Cean on 2020/7/21.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNHomeVC.h"
#import "CNLoginRegisterVC.h"
#import "CNRealPersonVC.h"
#import "CNElectronicVC.h"
#import "CNSportVC.h"
#import "CNLotteryVC.h"
#import "CNChessVC.h"
#import "CNMessageCenterVC.h"
#import "HYXiMaViewController.h"
#import "CNDashenBoardVC.h"

#import "CNUserInfoLoginView.h"
#import "SDCycleScrollView.h"
#import "UUMarqueeView.h"
#import "CNMessageBoxView.h"
#import "HYWideOneBtnAlertView.h"
#import "CNGameBtnsStackView.h"

#import "CNHomeRequest.h"
#import "CNUserCenterRequest.h"
#import "CNLoginRequest.h"
#import "HYInGameHelper.h"
#import "IN3SAnalytics.h"

#import <MJRefresh/MJRefresh.h>
#import "NSURL+HYLink.h"


@interface CNHomeVC () <CNUserInfoLoginViewDelegate,  SDCycleScrollViewDelegate, UUMarqueeViewDelegate, GameBtnsStackViewDelegate, DashenBoardAutoHeightDelegate>
{
    BOOL _didAppear;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/// 滚动视图
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
/// 滚动视图宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollContentW;
/// 用户信息图
@property (weak, nonatomic) IBOutlet CNUserInfoLoginView *infoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewH;

#pragma mark 轮播
@property (weak, nonatomic) IBOutlet UIView *bannerBgView;
@property (nonatomic, strong) SDCycleScrollView *bannerView; /// 轮播图
@property (nonatomic, strong) NSArray<AdBannerModel *> *bannModels;

#pragma mark 公告
@property (weak, nonatomic) IBOutlet UIView *adBgView;
@property (nonatomic, strong) UUMarqueeView *marqueeView; /// 滚动公告
@property (nonatomic, strong) NSArray<AnnounceModel *> *annoModels;
@property (nonatomic, strong) NSArray<MessageBoxModel *> *msgBoxModels;

#pragma mark 游戏切换属性
/// 游戏内容视图
@property (weak, nonatomic) IBOutlet UIView *pageView;
/// 游戏内容视图高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageViewH;
/// 当前选中
@property (nonatomic, assign) NSInteger currPage;

#pragma mark 大神榜
@property (weak, nonatomic) IBOutlet UIView *dashenView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boredViewH;
@property (nonatomic, assign) NSInteger currBordPage;
@end

@implementation CNHomeVC


#pragma mark - View Life Cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.bannerBgView addSubview:self.bannerView];
    [self.adBgView addSubview:self.marqueeView];
    
    CNBaseVC *vc = [self.childViewControllers objectAtIndex:self.currPage];
    self.pageViewH.constant = vc.totalHeight;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavgation = YES;
    [self configUI];
    
    [self userDidLogin];
    [self requestAnnouncement];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:HYSwitchAcoutSuccNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:HYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:HYLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYDidEnterHomePageNoti object:nil];
    
}

//可以在首页的该方法中调用
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //启动完成, 只调一次
    if (!_didAppear) {
        [IN3SAnalytics launchFinished];
        _didAppear = YES;
    }
}

- (void)userDidLogin {
    [self.infoView updateLoginStatusUI];
    
    [self requestHomeBanner];
    
    if ([CNUserManager shareManager].isLogin) {
        self.infoViewH.constant = 110;
        // 弹窗盒子
         [self requestNewsBox];
        // 游戏线路
        [[HYInGameHelper sharedInstance] queryHomeInGamesStatus];
        // 最近玩过的电游
        for (CNBaseVC *vc in self.childViewControllers) {
            if ([vc isKindOfClass:[CNElectronicVC class]]) {
                [(CNElectronicVC *)vc queryRecentGames];
            }
        }
    } else {
        self.infoViewH.constant = 140;
    }
}

- (void)userDidLogout {
    [self.infoView updateLoginStatusUI];
    self.infoViewH.constant = 140;
}

- (void)configUI {
    self.infoView.delegate = self;
    
    self.dashenView.backgroundColor = self.pageView.backgroundColor = self.scrollContentView.backgroundColor = self.view.backgroundColor;
    self.scrollContentW.constant = kScreenWidth;
    
    // 配置游戏和大神榜子控制器内容
    [self initSubVcAndAddSubVcViews];
    // 默认选择第一个
    [self didTapGameBtnsIndex:0];

    __weak typeof(self) wSelf = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wSelf userDidLogin];
        [wSelf requestAnnouncement];
    }];
}

- (void)initSubVcAndAddSubVcViews {
    // 按顺序添加 真人，电子，体育，彩票，棋牌
    NSArray *childVCs = @[
        [CNRealPersonVC new],
        [CNElectronicVC new],
        [CNSportVC new],
        [CNLotteryVC new],
        [CNChessVC new],
    ];
    for (CNBaseVC *vc in childVCs) {
        [self addChildViewController:vc];
        [self.pageView addSubview:vc.view];
    }
    
    // 大神榜
    CNDashenBoardVC *vc = [CNDashenBoardVC new];
    vc.delegate = self;
    [self addChildViewController:vc];
    [self.dashenView addSubview:vc.view];
}


#pragma mark - REQUEST
- (void)requestNewsBox {
    if ([CNUserManager shareManager].isLogin) {
        NSDate *nowDate = [NSDate date];
        NSString *agoDateStr = [[NSUserDefaults standardUserDefaults] stringForKey:HYHomeMessageBoxLastimeDate];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        __block NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];

        if ([agoDateStr isEqualToString:nowDateStr]) {
            MyLog(@"弹窗盒子一天就显示一次");
        }else{
            // 需要执行的方法写在这里
            [CNHomeRequest queryMessageBoxHandler:^(id responseObj, NSString *errorMsg) {
                
                NSArray<MessageBoxModel *> *models = [MessageBoxModel cn_parse:responseObj];
                if (models.count == 0) {
                    return;
                }
                
                self.msgBoxModels = models;
                NSMutableArray *imgs = @[].mutableCopy;
                for (MessageBoxModel *m in models) {
                    NSString *url = [NSURL getStrUrlWithString: m.imgUrl];
                    [imgs addObject:url];
                }
                [CNMessageBoxView showMessageBoxWithImages:imgs onView:self.view tapBlock:^(int idx) {
                    MessageBoxModel *m = self.msgBoxModels[idx];
                    [NNPageRouter jump2HTMLWithStrURL:m.link title:@"活动" needPubSite:NO];
                }];
                [[NSUserDefaults standardUserDefaults] setObject:nowDateStr forKey:HYHomeMessageBoxLastimeDate];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }
    }
}

- (void)requestHomeBanner {
    WEAKSELF_DEFINE
    [CNHomeRequest requestBannerWhere:BannerWhereHome Handler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        [strongSelf.scrollView.mj_header endRefreshing];
        if (!KIsEmptyString(errorMsg)) {
            return;
        }
        AdBannerGroupModel *groupModel = [AdBannerGroupModel cn_parse:responseObj];
        NSMutableArray *modArr = @[].mutableCopy;
        NSMutableArray *imgUrls = @[].mutableCopy;
        for (AdBannerModel *model in groupModel.bannersModel) {
            // !!!: 这里要根据货币模式筛选banner
            if([CNUserManager shareManager].isUsdtMode) {
                if ([model.linkParam[@"mode"] isEqualToString:@"rmb"]) { // usdt模式筛掉rmb banner
                    continue;
                }
            } else {
                if ([model.linkParam[@"mode"] isEqualToString:@"usdt"]) { // rmb模式筛掉usdt banner
                    continue;
                }
            }
            NSString *fullUrl = [groupModel.domainName stringByAppendingString:model.imgUrl];
            [imgUrls addObject:fullUrl];
            [modArr addObject:model];
        }
        strongSelf.bannerView.imageURLStringsGroup = imgUrls;
        strongSelf.bannModels = modArr;
        
    }];
    
}

- (void)requestAnnouncement {
    WEAKSELF_DEFINE
    [CNHomeRequest requestGetAnnouncesHandler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
        NSArray<AnnounceModel *> *arr = [AnnounceModel cn_parse:responseObj];
        strongSelf.annoModels = arr;
        [strongSelf.marqueeView reloadData];
    }];
}


#pragma mark - DashenBoredDelegte
- (void)didSetupDataGetTableHeight:(CGFloat)tableHeight {
    self.boredViewH.constant = tableHeight;
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannModels.count > 0 && self.bannModels.count-1 >= index) {
        AdBannerModel *model = self.bannModels[index];
        if ([model.linkUrl containsString:@"detailsPage?id="]) {
            NSString *articalId = [model.linkUrl componentsSeparatedByString:@"="].lastObject;
            [NNPageRouter jump2ArticalWithArticalId:articalId title:@"文章"];
        } else {
            [NNPageRouter jump2HTMLWithStrURL:model.linkUrl title:@"活动" needPubSite:NO];
        }
    }
}


#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView*)marqueeView {
    return self.annoModels.count;
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView {
    return kScreenWidth * 2;
}

- (void)createItemView:(UIView *)itemView forMarqueeView:(UUMarqueeView *)marqueeView{
    
    UILabel *content = [[UILabel alloc] init];
    content.font = [UIFont fontPFR13];
    content.textColor = kHexColorAlpha(0xFFFFFF, 0.5);
    content.frame = itemView.bounds;
    content.tag = 1001;
    [itemView addSubview:content];
}

- (void)updateItemView:(UIView *)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView{
    
    if (self.annoModels.count <= index) {
        return;
    }
    AnnounceModel *model = [self.annoModels objectAtIndex:index];
    UILabel *content = [itemView viewWithTag:1001];
    content.text = model.content;
}

- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView{
    
    if ([CNUserManager shareManager].isLogin) {
        [self.navigationController pushViewController:[CNMessageCenterVC new] animated:YES];
    }else{
        [self loginAction];
    }
}


#pragma mark - CNUserInfoLoginViewDelegate

- (void)buttonArrayAction:(CNActionType)type {
    //usdt模式下 未选择“不再提醒”充提指南 => 进充提指南
//    if ([CNUserManager shareManager].isUsdtMode && ![[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowCTZNEUserDefaultKey]) {
//        [self presentViewController:[HYNewCTZNViewController new] animated:YES completion:^{
//        }];
//
//    } else {
        switch (type) {
            case CNActionTypeBuy: //买
                [NNPageRouter jump2BuyECoin];
                break;
                
            case CNActionTypeDeposit: //充
                [NNPageRouter jump2Deposit];
                break;
                
            case CNActionTypeWithdraw: //提
                [NNPageRouter jump2Withdraw];
                break;
                
            case CNActionTypeSell: //卖
                [HYWideOneBtnAlertView showWithTitle:@"卖币跳转" content:@"正在为您跳转..请稍后。\n在交易所卖币数字货币，买家会将金额支付到您的银行卡，方便快捷。" comfirmText:@"我知道了，帮我跳转" comfirmHandler:^{
                    [NNPageRouter openExchangeElecCurrencyPage];
                }];
                break;
                
            case CNActionTypeXima: //洗
                [self.navigationController pushViewController:[HYXiMaViewController new] animated:YES];
                break;
        }
//    }
    
}

- (void)switchAccountAction {
    [CNLoginRequest switchAccountSuccessHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [self.infoView switchAccountUIChange];
        }
    }];
}

- (void)loginAction {
    [self.navigationController pushViewController:[CNLoginRegisterVC loginVC] animated:YES];
}

- (void)registerAction {
    [self.navigationController pushViewController:[CNLoginRegisterVC registerVC] animated:YES];
}


#pragma mark - GameBtnsStackViewDelegate 游戏切换业务

- (void)didTapGameBtnsIndex:(NSUInteger)index {
    self.currPage = index;
    CNBaseVC *vc = [self.childViewControllers objectAtIndex:index];
    self.pageViewH.constant = vc.totalHeight;
    [self.pageView bringSubviewToFront:vc.view];
}


#pragma mark - LAZY LOAD

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 115) delegate:self placeholderImage:[UIImage imageNamed:@"3"]];
        cycleScrollView2.layer.cornerRadius = 10;
        cycleScrollView2.layer.masksToBounds = YES;
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView2.pageControlStyle = SDCycleScrollViewPageContolStyleBiyou;
        cycleScrollView2.pageControlDotSize = CGSizeMake(AD(6), AD(6));
        cycleScrollView2.autoScrollTimeInterval = 4;
        _bannerView = cycleScrollView2;
    }
    return _bannerView;
}

- (UUMarqueeView *)marqueeView{
    if (!_marqueeView) {
        _marqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-15*2-20, self.adBgView.height)];
        _marqueeView.delegate = self;
        _marqueeView.timeIntervalPerScroll = 1.0f;
        _marqueeView.timeDurationPerScroll = 1.0f;
        _marqueeView.touchEnabled = YES;
        _marqueeView.itemSpacing = 30;;
        _marqueeView.direction = UUMarqueeViewDirectionLeftward;
        [_marqueeView reloadData];
    }
    return _marqueeView;
}


@end
