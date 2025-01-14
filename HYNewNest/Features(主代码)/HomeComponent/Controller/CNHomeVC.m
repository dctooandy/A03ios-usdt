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
#import "BYNewbieMissionVC.h"

#import "CNUserInfoLoginView.h"
#import "SDCycleScrollView.h"
#import "UUMarqueeView.h"
#import "CNMessageBoxView.h"
#import "HYWideOneBtnAlertView.h"
#import "CNGameBtnsStackView.h"
#import "WMDragView.h"
#import "BYMultiAccountRuleView.h"
#import "BYNightCityGiftAlertView.h"

#import "CNHomeRequest.h"
#import "CNUserCenterRequest.h"
#import "CNLoginRequest.h"
#import "HYInGameHelper.h"
#import <IN3SAnalytics/CNTimeLog.h>
#import "CNSplashRequest.h"

#import <MJRefresh/MJRefresh.h>
#import "NSURL+HYLink.h"
#import "HYTabBarViewController.h"
#import "A03ActivityManager.h"
#import "AppdelegateManager.h"
#import "RedPacketsRainView.h"
#import "RedPacketsPreView.h"
#import "BTTAnimationPopView.h"
#import <UIImageView+WebCache.h>
#import "AssistiveButton.h"
#import "UIImage+GIF.h"
#import "PublicMethod.h"
#import "GameStartPlayViewController.h"
typedef void(^ButtonCallBack)(void);

@interface CNHomeVC () <CNUserInfoLoginViewDelegate,  SDCycleScrollViewDelegate, UUMarqueeViewDelegate, GameBtnsStackViewDelegate, DashenBoardAutoHeightDelegate>
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
@property (nonatomic, strong) AssistiveButton * redPocketsAssistiveButton;
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
    [self configUI];
    [self userDidLogin];
    [self popupSetting];
    [self requestAnnouncement];
    [self requestCDNAndDomain];
    [self assistiveBtnAndActivitySetting];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:BYRefreshBalanceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginByNoti) name:HYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:HYLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BYDidEnterHomePageNoti object:nil];
}

//可以在首页的该方法中调用
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //启动完成, 只调一次
    if (!_hasRecord) {
        [CNTimeLog endRecordTime:CNEventAppLaunch];
        _hasRecord = YES;
    }
    
    self.bannerView.autoScroll = YES; // 恢复滚动
    [self.infoView updateLoginStatusUIIsRefreshing:NO]; // 获取余额
    
    kPreventRepeatTime(60*10); //十分钟
    // 检查新版本
    [CNSplashRequest queryNewVersion:^(BOOL isHardUpdate) {
    }];
    

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.bannerView.autoScroll = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppdelegateManager shareManager] recheckDomainWithTestSpeed];
    [self requestAnnouncement];
    [self.redPocketsAssistiveButton refetchTimeForRainning];
}
- (void)userDidLoginByNoti
{
    [self userDidLogin];
    [self popupSetting];
}
- (void)userDidLogin {
    [self.infoView updateLoginStatusUIIsRefreshing:YES];
    [self requestHomeBanner];
    [(HYTabBarViewController *)[NNControllerHelper currentTabBarController] performSelector:@selector(fetchUnreadCount)];
    if ([CNUserManager shareManager].isLogin) {
        self.infoViewH.constant = 140;
        //        [self requestNightCity];
        // 游戏线路
        [[HYInGameHelper sharedInstance] queryHomeInGamesStatus];
        // 最近玩过的电游
        //        for (CNBaseVC *vc in self.childViewControllers) {
        //            if ([vc isKindOfClass:[CNElectronicVC class]]) {
        //                [(CNElectronicVC *)vc queryRecentGames];
        //            }
        //        }
        
    } else {
        self.infoViewH.constant = 140;
    }
}
- (void) popupSetting
{
    // 弹窗盒子
    // 新的方法
    WEAKSELF_DEFINE
    [[A03ActivityManager sharedInstance] checkPopViewWithCompletionBlock:^(A03PopViewModel * _Nullable response, NSString * _Nullable error) {
        if (response)
        {
            [CNMessageBoxView showMessageBoxWithImages:@[response.image].mutableCopy
                                                onView:weakSelf.view
                                              tapBlock:^(int idx) {
                NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
                BOOL isBeforeDuration = [duractionArray[0] boolValue];
                BOOL isActivityDuration = [duractionArray[1] boolValue];
                BOOL isRainningTime = [duractionArray[2] boolValue];
                if (isBeforeDuration || isActivityDuration)
                {
                    [weakSelf showRedPacketsRainViewwWithStyle:(isActivityDuration ? (isRainningTime ? RedPocketsViewRainning : RedPocketsViewBegin): RedPocketsViewPrefix)];
                }else
                {
                    [NNPageRouter jump2HTMLWithStrURL:response.link title:response.title needPubSite:NO];
                }
            } tapClose:^{
                [weakSelf showAccountTutorials];
            }];
        }else
        {
            [weakSelf showAccountTutorials];
        }
    }];
}

- (void)checkTimeForRedPoickets
{
    [self checkTime:^(NSString * _Nonnull timeStr) {
        if (timeStr.length > 0) {
            if ([self checksStartDate:@"10:00" EndDate:@"10:01" serverTime:timeStr])
            {
                
            }else if ([self checksStartDate:@"14:00" EndDate:@"14:01" serverTime:timeStr])
            {
                
            }else
            {
                /// 不到时间
                
            }
        }
    }];
}
-(BOOL)checksStartDate:(NSString *)startTime EndDate:(NSString *)endTime serverTime:(NSString *)serverTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    NSDate *serverDate = [dateFormatter dateFromString:serverTime];
    // 判断是否大于server时间
    if (([startDate earlierDate:serverDate] == startDate) &&
        ([serverDate earlierDate:endDate] == serverDate)) {
        return true;
    } else {
        return false;
    }
}
-(void)checkTime:(CheckTimeCompleteBlock)completeBlock {
    NSDate *timeDate = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    completeBlock([dateFormatter stringFromDate:timeDate]);
//    [IVNetwork requestPostWithUrl:BTTServerTime paramters:nil completionBlock:^(id  _Nullable response, NSError * _Nullable error) {
//        IVJResponseObject *result = response;
//        if ([result.head.errCode isEqualToString:@"0000"]) {
//            NSDate *timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:[result.body longLongValue]];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            completeBlock([dateFormatter stringFromDate:timeDate]);
//        } else {
//            completeBlock(@"");
//        }
//    }];
}
- (void)userDidLogout {
    [self.infoView updateLoginStatusUIIsRefreshing:NO];
    self.infoViewH.constant = 140;
    [(HYTabBarViewController *)[NNControllerHelper currentTabBarController] performSelector:@selector(setUnreadToDefault)];
    [self popupSetting];
}

- (void)configUI {
    self.hideNavgation = YES;
    
    self.infoView.delegate = self;
    
    self.dashenView.backgroundColor = self.pageView.backgroundColor = self.scrollContentView.backgroundColor = self.view.backgroundColor;
    self.scrollContentW.constant = kScreenWidth;
    
    [self setupBBSEntryBallView];
    
    // 配置游戏和大神榜子控制器内容
    [self initSubVcAndAddSubVcViews];
    // 默认选择第一个
    [self didTapGameBtnsIndex:0];
    
    __weak typeof(self) wSelf = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[AppdelegateManager shareManager] recheckDomainWithTestSpeed];
        [wSelf userDidLogin];
        [wSelf requestAnnouncement];
    }];
}

- (void)setupBBSEntryBallView {
    WMDragView *bbsBall = [[WMDragView alloc] initWithFrame:CGRectMake(kScreenWidth-60, kScreenHeight *0.65, 60, 60)];
    bbsBall.backgroundColor = [UIColor clearColor];
    bbsBall.freeRect = CGRectMake(0, kStatusBarHeight, kScreenWidth, kScreenHeight-kTabBarHeight-kStatusBarHeight);
    bbsBall.isKeepBounds = YES;
    [bbsBall.button setImage:[UIImage imageNamed:@"icon_lt"] forState:UIControlStateNormal];
    bbsBall.clickDragViewBlock = ^(WMDragView *dragView) {
        [NNPageRouter jump2HTMLWithStrURL:H5URL_BBS title:@"币游论坛" needPubSite:NO];
    };
    [self.view addSubview:bbsBall];
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
        vc.hideNavgation = true;
        [self addChildViewController:vc];
        [self.pageView addSubview:vc.view];
    }
    
    // 大神榜
    CNDashenBoardVC *vc = [CNDashenBoardVC new];
    vc.hideNavgation = true;
    vc.delegate = self;
    [self addChildViewController:vc];
    [self.dashenView addSubview:vc.view];
}

- (void)showAccountTutorials {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:HYDidShowTJTCUserDefaultKey] == false) {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:HYDidShowTJTCUserDefaultKey];
        [self questionAction];
    }
}

- (void)questionAction {
    [BYMultiAccountRuleView showRuleWithLocatedY:self.infoView.bottom-15];
}

#pragma mark - REQUEST
- (void)requestNightCity {
    //USDT Mode Only
    if ([[CNUserManager shareManager] isUsdtMode] == false) {
        return;
    }
    
    [CNHomeRequest requestNightCityHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg && [responseObj isKindOfClass:[NSDictionary class]]) {
            if ([responseObj[@"popup"] boolValue] == true) {
                [BYNightCityGiftAlertView showAlertViewHandler:^(BOOL isComfirm) {
                    if (isComfirm) {
                        [NNPageRouter jump2HTMLWithStrURL:H5URL_Pub_NightCity title:@"币游不夜城" needPubSite:NO];
                    }
                }];
            }
        }
    }];
}

- (void)requestNewsBox {
//    if ([CNUserManager shareManager].isLogin) {
//        NSDate *nowDate = [NSDate date];
//        NSString *agoDateStr = [[NSUserDefaults standardUserDefaults] stringForKey:HYHomeMessageBoxLastimeDate];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        __block NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
//        
//        if ([agoDateStr isEqualToString:nowDateStr]) {
//            MyLog(@"弹窗盒子一天就显示一次");
//            [self showAccountTutorials];
//        }
//        else{
//            [[NSUserDefaults standardUserDefaults] setObject:nowDateStr forKey:HYHomeMessageBoxLastimeDate];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            // 需要执行的方法写在这里
//        }
//    }
   
    //        else{
    //            // 需要执行的方法写在这里
    //            WEAKSELF_DEFINE
    //            [CNHomeRequest queryMessageBoxHandler:^(id responseObj, NSString *errorMsg) {
    //
    //                STRONGSELF_DEFINE
    //                NSMutableArray<MessageBoxModel *> *models = [[MessageBoxModel cn_parse:responseObj] mutableCopy];
    //                if (models.count == 0) { return; }
    //
    //                NSMutableArray *imgs = @[].mutableCopy;
    //                [models enumerateObjectsUsingBlock:^(MessageBoxModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                    BOOL flag = YES; // 用来判定是否 没有被筛出
    //                    // 筛选等级：固定
    //                    if (obj.fixedLevel) {
    //                        NSArray *levs = [obj.fixedLevel componentsSeparatedByString:@","];
    //                        if (![levs containsObject:[NSString stringWithFormat:@"%ld", [CNUserManager shareManager].userDetail.starLevel]]) {
    //                            [models removeObject:obj];
    //                            flag = NO;
    //                        }
    //                    }
    //                    // 筛选等级：大于等于
    //                    if (obj.level) {
    //                        if (obj.level.integerValue > [CNUserManager shareManager].userDetail.starLevel) {
    //                            [models removeObject:obj];
    //                            flag = NO;
    //                        }
    //                    }
    //                    if (flag) {
    //                        // 图片数组
    //                        NSString *url = [NSURL getStrUrlWithString: obj.imgUrl];
    //                        [imgs addObject:url];
    //                    }
    //                }];
    //                strongSelf.msgBoxModels = models;
    //                if (imgs.count > 0 && imgs.count == models.count) {
    //                    [CNMessageBoxView showMessageBoxWithImages:imgs
    //                                                        onView:weakSelf.view
    //                                                      tapBlock:^(int idx) {
    //                        MessageBoxModel *m = strongSelf.msgBoxModels[idx];
    //                        [NNPageRouter jump2HTMLWithStrURL:m.link title:@"活动" needPubSite:NO];
    //                    } tapClose:^{
    //                        [weakSelf showAccountTutorials];
    //                    }];
    //                    [[NSUserDefaults standardUserDefaults] setObject:nowDateStr forKey:HYHomeMessageBoxLastimeDate];
    //                    [[NSUserDefaults standardUserDefaults] synchronize];
    //                }
    //                else {
    //                    [weakSelf showAccountTutorials];
    //                }
    //            }];
    //        }
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
            if (model.linkParam)
            {
                if([CNUserManager shareManager].isUsdtMode) {
                    if ([model.linkParam[@"mode"] containsString:@"rmb"] ||
                        [model.linkParam[@"mode"] containsString:@"cny"] ||
                        [model.linkParam[@"mode"] containsString:@"CNY"]) { // usdt模式筛掉rmb banner
                        continue;
                    }
                } else {
                    if ([model.linkParam[@"mode"] isEqualToString:@"usdt"] ||
                        [model.linkParam[@"mode"] isEqualToString:@"USDT"]) { // rmb模式筛掉usdt banner
                        continue;
                    }
                }
                NSString *fullUrl = [[A03ActivityManager sharedInstance] nowCDNString:groupModel.domainName WithUrl:model.imgUrl];
                [imgUrls addObject:fullUrl];
                [modArr addObject:model];
            }
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

- (void)requestCDNAndDomain {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [CNSplashRequest queryCDNH5Domain:^(id responseObj, NSString *errorMsg) {
            NSString *cdnAddr = responseObj[@"csdnAddress"];
            NSString *h5Addr = responseObj[@"h5Address"];
            if ([cdnAddr containsString:@","]) {
                cdnAddr = [cdnAddr componentsSeparatedByString:@","].firstObject;
            }
            [IVHttpManager shareManager].cdn = cdnAddr;
            [IVHttpManager shareManager].domain = h5Addr;
        }];
    });
}

#pragma mark - DashenBoredDelegte
- (void)didSetupDataGetTableHeight:(CGFloat)tableHeight {
    self.boredViewH.constant = tableHeight;
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannModels.count > 0 && self.bannModels.count-1 >= index) {
        AdBannerModel *model = self.bannModels[index];
        NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
        BOOL isBeforeDuration = [duractionArray[0] boolValue];
        BOOL isActivityDuration = [duractionArray[1] boolValue];
        BOOL isRainningTime = [duractionArray[2] boolValue];
        if ((isBeforeDuration || isActivityDuration)&& ([model.linkUrl containsString:@"tiger_red_envelope"]))
        {
            [self showRedPacketsRainViewwWithStyle:(isActivityDuration ? (isRainningTime ? RedPocketsViewRainning : RedPocketsViewBegin): RedPocketsViewPrefix)];
        }else
        {
            if ([model.linkUrl containsString:@"detailsPage?id="]) { // 跳文章
                NSString *articalId = [model.linkUrl componentsSeparatedByString:@"="].lastObject;
                [NNPageRouter jump2ArticalWithArticalId:articalId title:@"文章"];
            } else if ([model.linkUrl hasPrefix:@"http"]) { // 跳外链
                NSURL *URL = [NSURL URLWithString:model.linkUrl];
                if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
                        [CNTOPHUB showSuccess:@"请在外部浏览器查看"];
                    }];
                }
            } else { // 跳活动
                if ([model.linkUrl containsString:@"AG旗舰"])
                {
                    [[HYInGameHelper sharedInstance] inGame:InGameTypeAGQJ];
                }else if ([model.linkUrl containsString:@"AG国际"])
                {
                    [[HYInGameHelper sharedInstance] inGame:InGameTypeAGIN];
                }else if ([model.linkUrl containsString:@"沙巴体育"])
                {
                    [[HYInGameHelper sharedInstance] inGame:InGameTypeSHABA];
                }else if ([model.linkUrl containsString:@"AS棋牌"])
                {
                    [[HYInGameHelper sharedInstance] inGame:InGameTypeAGSTAR];
                }else
                {
                    [NNPageRouter jump2HTMLWithStrURL:model.linkUrl title:@"" needPubSite:NO];
                }
            }
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

//- (void)didTouchItemViewAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView{
//}
- (IBAction)didTapAnnounceView:(id)sender {
    if ([CNUserManager shareManager].isLogin) {
        [self.navigationController pushViewController:[CNMessageCenterVC new] animated:YES];
    }else{
        [self loginAction];
    }
}


#pragma mark - CNUserInfoLoginViewDelegate

- (void)buttonArrayAction:(CNActionType)type {
    switch (type) {
        case CNActionTypeDeposit: //充
            [NNPageRouter jump2Deposit];
            break;
            
        case CNActionTypeWithdraw: //提
            [NNPageRouter jump2Withdraw];
            break;

        case CNActionTypeXima: //洗
            [self.navigationController pushViewController:[HYXiMaViewController new] animated:YES];
            break;
    }
 
}

- (void)switchAccountAction {
    [CNLoginRequest switchAccountSuccessHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
//            BOOL isUSDT = [CNUserManager shareManager].isUsdtMode;
//            CGPoint p = CGPointMake(isUSDT?(kScreenWidth-15-24-(109/4.0)):(kScreenWidth-15-24-(109*3/4.0)), self.infoView.bottom-50+kStatusBarHeight);
//            [BYMultiAccountRuleView showRuleWithLocatedPoint:p];
            //Reset UnreadMessage
            [(HYTabBarViewController *)[NNControllerHelper currentTabBarController] performSelector:@selector(fetchUnreadCount)];
            [CNLoginRequest getUserInfoByTokenCompletionHandler:^(id responseObj, NSString *errorMsg) {
                if (!errorMsg) {
                    [self.infoView switchAccountUIChange];
                }
            }];
        }
    } faileHandler:^{
        [self.infoView refreshBottomBtnsStatus];
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
- (void)assistiveBtnAndActivitySetting
{
    WEAKSELF_DEFINE
    [[A03ActivityManager sharedInstance] checkTimeRedPacketRainWithCompletion:^(NSString * _Nullable response, NSString * _Nullable error) {
        // 悬浮按钮
        [weakSelf setUpCustomAssistiveButtonCompleted:^{
            if (weakSelf.redPocketsAssistiveButton != nil) {
                [weakSelf.view addSubview:weakSelf.redPocketsAssistiveButton];
            }
        }];
        // 红包雨活动
        if (response != nil)
        {
            // 活动期
        }else
        {
            // 预热
        }
        //测试用
        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf showRedPacketsRainViewwWithStyle:RedPocketsViewDev];
        });
    } WithDefaultCompletion:^(NSString * _Nullable response, NSString * _Nullable error) {
        // 一般活动
        // 悬浮按钮设定
        
    }];
}
- (void)popupTenSecondView
{
    if ([CNUserManager shareManager].isLogin)
    {
        // 游戏中不弹窗，活动页面不弹，主页的四个导航页面弹窗
        WEAKSELF_DEFINE
        __block BOOL canPop = YES;
        UIViewController *topVC = [PublicMethod currentViewController];
        if ([topVC isKindOfClass:[CNLoginRegisterVC class]]
            || [topVC isKindOfClass:[GameStartPlayViewController class]]
    //        || [topVC isKindOfClass:[BTTAGGJViewController class]]
    //        || [topVC isKindOfClass:[IVOtherGameController class]]
            ) {
            
        }else
        {

            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray * viewsArray = [[[UIApplication sharedApplication] keyWindow] subviews];
                for (UIView * currentView in viewsArray) {
                    if ([currentView isKindOfClass:[BTTAnimationPopView class]]) {
                        canPop = NO;
                        break;
                    }
                }
                if (canPop)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf showRedPacketsPreViewWithDuration:RedPacketDuration];
                    });
                }
            });
        }
    }
   
}
#pragma mark - 10s倒计时弹窗
- (void)showRedPacketsPreViewWithDuration:(int)duration
{
    weakSelf(weakSelf)
    RedPacketsPreView *alertView = [RedPacketsPreView viewFromXib];
    [alertView configForRedPocketsViewWithDuration:duration];
    BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:alertView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
    popView.isClickBGDismiss = YES;
    [popView pop];
    
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    alertView.dismissBlock = ^{
        [popView dismiss];
        [weakSelf.redPocketsAssistiveButton refetchTimeForRainning];
    };
    alertView.btnBlock = ^(UIButton * _Nullable btn) {
        [popView dismiss];
    };
    alertView.getRedBlock = ^{
        [weakSelf showRedPacketsRainViewwWithStyle:RedPocketsViewBegin];
        [popView dismiss];
    };
}
#pragma mark - 红包雨 预热/活动弹窗
- (void)showRedPacketsRainViewwWithStyle:(RedPocketsViewStyle)currentStyle
{
    weakSelf(weakSelf)
    if (![CNUserManager shareManager].isLogin && (currentStyle == RedPocketsViewBegin ||
                                                  currentStyle == RedPocketsViewRainning ||
                                                  currentStyle == RedPocketsViewDev))
    {
        [self loginAction];
    }else
    {
        [[A03ActivityManager sharedInstance] checkTimeRedPacketRainWithCompletion:^(NSString * _Nullable response, NSString * _Nullable error) {
            RedPacketsRainView *alertView = [RedPacketsRainView viewFromXib];
            [alertView configForRedPocketsViewWithStyle:currentStyle];
            BTTAnimationPopView *popView = [[BTTAnimationPopView alloc] initWithCustomView:alertView popStyle:BTTAnimationPopStyleNO dismissStyle:BTTAnimationDismissStyleNO];
            popView.isClickBGDismiss = YES;
            [popView pop];
            
            [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            alertView.dismissBlock = ^{
                [weakSelf.redPocketsAssistiveButton refetchTimeForRainning];
                [popView dismiss];
            };
            alertView.btnBlock = ^(UIButton * _Nullable btn) {
                [popView dismiss];
            };
        } WithDefaultCompletion:nil];
    }
}

// 悬浮按钮
-(void)setUpCustomAssistiveButtonCompleted:(ButtonCallBack _Nullable)completionBlock
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if ([imageURL.description containsString:@"gif"])
        {
            NSData *imageData = UIImagePNGRepresentation(image);
            UIImage * backgroundImage = [UIImage sd_animatedGIFWithData:imageData];
            self.redPocketsAssistiveButton = [[AssistiveButton alloc] initMainBtnWithCustomImage:backgroundImage highlightImage:nil];
        }else
        {
            UIImage * backgroundImage = ImageNamed(@"popup-3");
            self.redPocketsAssistiveButton = [[AssistiveButton alloc] initMainBtnWithCustomImage:backgroundImage highlightImage:nil];
        }
        //主按鈕可移動或移動後回彈跟不可移動
        self.redPocketsAssistiveButton.positionMode = SpreadPositionModeNone;
        weakSelf(weakSelf);
        [self.redPocketsAssistiveButton setTenSecondActionBlock:^{
            [weakSelf popupTenSecondView];
        }];
        [self.redPocketsAssistiveButton setMainButtonClickActionBlock:^{
            NSArray *duractionArray = [PublicMethod redPacketDuracionCheck];
            BOOL isBeforeDuration = [duractionArray[0] boolValue];
            BOOL isActivityDuration = [duractionArray[1] boolValue];
            BOOL isRainningTime = [duractionArray[2] boolValue];
            if (isBeforeDuration || isActivityDuration)
            {
                [weakSelf showRedPacketsRainViewwWithStyle:(isActivityDuration ? (isRainningTime ? RedPocketsViewRainning : RedPocketsViewBegin): RedPocketsViewPrefix)];
            }else
            {//跳去活动结束画面
                weakSelf.redPocketsAssistiveButton.hidden = true;
//                [NNPageRouter jump2HTMLWithStrURL:@"/pub_site/twinFight" title:@"过夜利息" needPubSite:NO];
            }
        }];
        [self.redPocketsAssistiveButton setCloseBtnActionBlock:^{
            [weakSelf.redPocketsAssistiveButton removeFromSuperview];
        }];
        completionBlock();
    }];
}
@end
