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
#import "HYNewCTZNViewController.h"
#import "HYRechargeViewController.h"
#import "HYRechargeCNYViewController.h"
#import "HYWithdrawViewController.h"

#import "CNUserInfoLoginView.h"
#import "CNServerView.h"
#import "SDCycleScrollView.h"
#import "UUMarqueeView.h"
#import "CNMessageBoxView.h"
#import "HYWideOneBtnAlertView.h"

#import "CNHomeRequest.h"
#import "CNUserCenterRequest.h"
#import "CNLoginRequest.h"

@interface CNHomeVC () <CNUserInfoLoginViewDelegate, CNServerViewDelegate, SDCycleScrollViewDelegate, UUMarqueeViewDelegate>
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

#pragma - mark 游戏切换属性
/// 游戏内容视图
@property (weak, nonatomic) IBOutlet UIView *pageView;
/// 游戏内容视图高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageViewH;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *switchBtnArr;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *gameTypeLbArr;
@property (nonatomic, assign) NSInteger currPage;

#pragma - mark logo, 品牌和赞助商
/// 品牌和赞助商
@property (weak, nonatomic) IBOutlet UIView *brandView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *brandViewH;
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
}

- (void)rightItemAction {
    // !!!: FOR TEST ONLY
    //    if (![CNUserManager shareManager].isLogin) {
    //        [CNLoginRequest creatTryAcountCompletionHandler:^(id responseObj, NSString *errorMsg) {
    //            [HYTextAlertView showWithTitle:@"试玩账户" content:@"系统为您自动分配试玩额度2,000元" comfirmText:@"确定" comfirmHandler:^{
    //            }];
    //            [self updateUserInfo];
    //        }];
    //    } else {
    //        [self updateUserInfo];
    //    }
    
    /// 弹窗盒子逻辑
//    if ([CNUserManager shareManager].isLogin) {
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        NSDate *nowDate = [NSDate date];
//        NSString *agoDateStr = [userDefault stringForKey:@"AgoDate"];
//
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
//
//        if ([agoDateStr isEqualToString:nowDateStr]) {
//            MyLog(@"弹窗盒子一天就显示一次");
//         }else{
//            // 需要执行的方法写在这里
//            [CNMessageBoxView showMessageBoxWithImages:@[@"deposit-success",@"deposit-fail",@"banner-1"]];
//            [userDefault setObject:nowDateStr forKey:@"AgoDate"];
//            [userDefault synchronize];
//         }
//    }
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CNBaseVC *vc = [self.childViewControllers objectAtIndex:self.currPage];
    self.pageViewH.constant = vc.totalHeight;
    
    if ([CNUserManager shareManager].isLogin) {
        self.brandView.hidden = NO;
        self.brandViewH.constant = 710;
        
        [self.infoView reloadBalance];
    } else {
        self.brandView.hidden = YES;
        self.brandViewH.constant = 0;
    }
}

- (void)userDidLogin {
    [self.infoView updateLoginStatusUI];
    self.infoViewH.constant = 135;
    [self requestHomeBanner];
}

- (void)userDidLogout {
    [self.infoView updateLoginStatusUI];
    self.infoViewH.constant = 135;
}

- (void)configUI {
    self.infoView.delegate = self;
    
    self.pageView.backgroundColor = self.scrollContentView.backgroundColor = self.view.backgroundColor;
    self.scrollContentW.constant = kScreenWidth;
    
    // 切换按钮边框颜色
    for (int i = 0; i < self.gameTypeLbArr.count; i++) {
        UIButton *btn = self.switchBtnArr[i];
        UILabel *lb = self.gameTypeLbArr[i];
        btn.layer.borderColor = lb.textColor.CGColor;
    }
    
    // 配置游戏切换内容
    [self initGameVC];
    
    // 默认选择第一个
    [self switchGame:self.switchBtnArr.firstObject];
}


- (void)initGameVC {
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
}


#pragma mark - REQUEST
- (void)requestHomeBanner {
    WEAKSELF_DEFINE
    [CNHomeRequest requestBannerWhere:BannerWhereHome Handler:^(id responseObj, NSString *errorMsg) {
        STRONGSELF_DEFINE
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


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannModels.count > 0 && self.bannModels.count-1 >= index) {
        AdBannerModel *model = self.bannModels[index];
        [NNPageRouter jump2HTMLWithStrURL:model.linkUrl title:@"活动"];
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
    if ([CNUserManager shareManager].isUsdtMode && ![[NSUserDefaults standardUserDefaults] boolForKey:HYNotShowCTZNEUserDefaultKey]) {
        [self presentViewController:[HYNewCTZNViewController new] animated:YES completion:^{
        }];
    
    } else {
        switch (type) {
            case CNActionTypeBuy: //买
                [NNPageRouter openExchangeElecCurrencyPageIsSell:NO];
                break;
            case CNActionTypeDeposit: //充
                if ([CNUserManager shareManager].isUsdtMode) {
                    [self.navigationController pushViewController:[HYRechargeViewController new] animated:YES];
                } else {
                    [self.navigationController pushViewController:[HYRechargeCNYViewController new] animated:YES];
                }
                break;
            case CNActionTypeWithdraw: //提
                [self.navigationController pushViewController:[HYWithdrawViewController new] animated:YES];
                break;
            case CNActionTypeSell: //卖
                [HYWideOneBtnAlertView showWithTitle:@"卖币跳转" content:@"正在为您跳转..请稍后。\n在交易所卖币数字货币，买家会将金额支付到您的银行卡，方便快捷。" comfirmText:@"我知道了，帮我跳转" comfirmHandler:^{
                    [NNPageRouter openExchangeElecCurrencyPageIsSell:YES];
                }];
                break;
            case CNActionTypeXima: //洗
                [self.navigationController pushViewController:[HYXiMaViewController new] animated:YES];
                break;
        }
    }
    
}

- (void)switchAccountAction {
    [CNLoginRequest switchAccountSuccessHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [self.infoView switchAccountUIChange];
        }
    }];
}

- (void)messageAction {
    [self.navigationController pushViewController:[CNMessageCenterVC new] animated:YES];
}

- (void)showHideAction:(BOOL)hide {
    self.infoViewH.constant = hide ? (135-44): 135;
}

- (void)loginAction {
    [self.navigationController pushViewController:[CNLoginRegisterVC loginVC] animated:YES];
}

- (void)registerAction {
    [self.navigationController pushViewController:[CNLoginRegisterVC registerVC] animated:YES];
}


#pragma mark - CNServerViewDelegate

- (void)questionAction {
    [NNPageRouter jump2Live800Type:CNLive800TypeNormal];
}

- (void)depositAction {
    [NNPageRouter jump2Live800Type:CNLive800TypeDeposit];
}

- (void)serverView:(CNServerView *)server callBack:(NSString *)phone code:(NSString *)code messageId:(NSString *)messageId {
    NSLog(@"phone=%@,code=%@, mid=%@", phone, code, messageId);
    // 请求接口处理完成移除
    [server removeFromSuperview];
    [CNHomeRequest callCenterCallBackMessageId:messageId
                                       smsCode:code
                                      mobileNo:phone
                                       handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [kKeywindow jk_makeToast:@"客户代表将于1-10分钟内为您致电，请保持电话畅通哦 (^o^)" duration:3 position:JKToastPositionCenter];
        }
    }];
}


#pragma mark - 游戏切换业务

- (IBAction)switchGame:(UIButton *)sender {
    // 过滤重复点击
    if (sender.selected) {
        return;
    }
    // 还原UI
    for (UIButton *btn in self.switchBtnArr) {
        btn.selected = NO;
        btn.layer.borderWidth = 0;
    }
    sender.selected = YES;
    sender.layer.borderWidth = 1;
    
    // 点击按钮下标
    NSInteger index = [self.switchBtnArr indexOfObject:sender];
    self.currPage = index;
    CNBaseVC *vc = [self.childViewControllers objectAtIndex:index];
    self.pageViewH.constant = vc.totalHeight;
    [self.pageView bringSubviewToFront:vc.view];
}


#pragma mark - LAZY LOAD
- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth - 30, 115) delegate:self placeholderImage:[UIImage imageNamed:@"bannerdefault"]];
        cycleScrollView2.layer.cornerRadius = 10;
        cycleScrollView2.layer.masksToBounds = YES;
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView2.autoScrollTimeInterval = 4;
        cycleScrollView2.currentPageDotColor = kHexColor(0x02EED9); // 自定义分页控件小圆标颜色
        _bannerView = cycleScrollView2;
    }
    return _bannerView;
}

- (UUMarqueeView *)marqueeView{
    if (!_marqueeView) {
        _marqueeView = [[UUMarqueeView alloc] initWithFrame:CGRectMake(20, 0, self.adBgView.width-60, self.adBgView.height)];
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
