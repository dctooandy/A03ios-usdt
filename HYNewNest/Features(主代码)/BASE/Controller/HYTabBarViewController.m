//
//  HYTabBarViewController.m
//  HYGEntire
//
//  Created by zaky on 24/10/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//


#import "HYTabBarViewController.h"
#import "HYNavigationController.h"
#import "CNHomeVC.h"
#import "HYVIPViewController.h"
#import "HYBonusViewController.h"
#import "HYGloryViewController.h"
#import "BYGloryVC.h"
#import "CNMineVC.h"

#import "UIImage+ESUtilities.h"
#import "SuspendBall.h"
#import "CNServerView.h"
#import "CNServiceRequest.h"
#import "HYTextAlertView.h"
#import <YJChat.h>

#import <CSCustomSerVice/CSCustomSerVice.h>
#import "KeyChain.h"
#import "CNUserCenterRequest.h"

#import "PPBadgeView.h"

@interface HYTabBarViewController ()<UITabBarControllerDelegate, SuspendBallDelegte, CNServerViewDelegate>
@property (nonatomic, strong) SuspendBall *suspendBall;
@property (assign, nonatomic) BOOL isOpenWMQ; //!<是否开启微脉圈
@end

@implementation HYTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupControllers];
    [self setupAppearance];
    [self checkWMQStatus];
    [self fetchUnreadCount];
    [self initOCSSSDKShouldReload:false];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStatusChanged) name:HYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginStatusChanged) name:HYLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchUnreadCount) name:BYDidReadMessageNotificaiton object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupAppearance) name:CNSkinChangeNotification object:nil];
    
    
}

- (void)setupAppearance{
    
    if (@available(iOS 13, *)) {
        UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
        // 设置背景
        UIImage *bgimg = [UIImage createImageWithRadius:0 Color:KColorRGB(12, 11, 17) bounds:CGRectMake(0, 0, kScreenWidth, kTabBarHeight)];
        appearance.backgroundImage = bgimg;
        //        if (CNSkinManager.currSkinType == SKinTypeBlack) { //没效果？
        //            appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        //        } else {
        appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //        }
        appearance.backgroundColor = [UIColor clearColor];
        // 去除分割线
        //        appearance.shadowImage = [UIImage new];
        //        appearance.shadowColor = [UIColor clearColor];
        // 选中字体颜色
        self.tabBar.tintColor = kHexColor(0x0FB4DD);
        self.tabBar.standardAppearance = appearance;
        
    } else {
        // 设置背景色
        [[UITabBar appearance] setBarTintColor:KColorRGB(12, 11, 17)];
        // 去除分割线
        //        self.tabBar.shadowImage = [UIImage new];
        // 选中字体颜色
        self.tabBar.tintColor = kHexColor(0x0FB4DD);
        [UITabBar appearance].translucent = YES;
    }
}

- (void)setupControllers{
    
    NSMutableArray *vcs = @[].mutableCopy;
    HYNavigationController *homeNav = [HYNavigationController navigationControllerWithController:[CNHomeVC class]
                                                                                     tabBarTitle:@"大厅"
                                                                                     normalImage:[UIImage imageNamed:@"Home"]
                                                                                   selectedImage:[UIImage imageNamed:@"Home_s"]];
    [vcs addObject:homeNav];
    
    HYNavigationController *vipNav = [HYNavigationController navigationControllerWithController:[HYVIPViewController class]
                                                                                    tabBarTitle:@"VIP"
                                                                                    normalImage:[UIImage imageNamed:@"vip"]
                                                                                  selectedImage:[UIImage imageNamed:@"vip_s"]];
    [vcs addObject:vipNav];
    
    HYNavigationController *bonusNav = [HYNavigationController navigationControllerWithController:[HYBonusViewController class]
                                                                                      tabBarTitle:@"优惠"
                                                                                      normalImage:[UIImage imageNamed:@"youhui"]
                                                                                    selectedImage:[UIImage imageNamed:@"youhui_s"]];
    [vcs addObject:bonusNav];
    
    //    HYNavigationController *gloryNav = [HYNavigationController navigationControllerWithController:[HYGloryViewController class]
    //                                                                      tabBarTitle:@"风采"
    //                                                                      normalImage:[UIImage imageNamed:@"Fengcai"]
    //                                                                    selectedImage:[UIImage imageNamed:@"Fengcai_s"]];
    //    [vcs addObject:gloryNav];
    
    HYNavigationController *gloryNav = [HYNavigationController navigationControllerWithController:[BYGloryVC class]
                                                                                      tabBarTitle:@"风采"
                                                                                      normalImage:[UIImage imageNamed:@"Fengcai"]
                                                                                    selectedImage:[UIImage imageNamed:@"Fengcai_s"]];
    [vcs addObject:gloryNav];
    
    HYNavigationController *mineNav = [HYNavigationController navigationControllerWithController:[CNMineVC class]
                                                                                     tabBarTitle:@"我的"
                                                                                     normalImage:[UIImage imageNamed:@"Wode"]
                                                                                   selectedImage:[UIImage imageNamed:@"Wode_s"]];
    [vcs addObject:mineNav];
    
    
    self.viewControllers = vcs.copy;
    self.delegate = self;
}

- (void)setupCSSuspendBall {
    [self.suspendBall removeFromSuperview];
    self.suspendBall = nil;
    
    CGFloat btnWH = 60.f;
    NSArray *imgNameGroup;
    NSArray *titleGroup;
    if (self.isOpenWMQ) {
        imgNameGroup = @[@"cunqu", @"help", @"phone_s", @"phone_s"];
        titleGroup = @[@"VIP", @"疑问", @"回拨", @"400"];
    } else {
        imgNameGroup = @[@"help", @"phone_s", @"phone_s"];
        titleGroup = @[@"疑问", @"回拨", @"400"];
    }
    SuspendBall *suspendBall = [SuspendBall suspendBallWithFrame:CGRectMake(kScreenWidth - btnWH, kScreenHeight *0.75, btnWH, btnWH)
                                                        delegate:self
                                               subBallImageArray:imgNameGroup
                                                       textArray:titleGroup];
    suspendBall.top = kNavPlusStaBarHeight;
    suspendBall.bottom = kTabBarHeight + kSafeAreaHeight;
    suspendBall.hidden = NO;
    self.suspendBall = suspendBall;
    [self.view addSubview:suspendBall];
    [self.view bringSubviewToFront:suspendBall];
}

- (void)checkWMQStatus {
    if (![CNUserManager shareManager].isLogin) {
        self.isOpenWMQ = NO;
        return;
    }
    WEAKSELF_DEFINE
    [CNServiceRequest queryIsOpenWMQHandler:^(id responseObj, NSString *errorMsg) {
        NSDictionary *dict = responseObj[0];
        NSString *level = dict[@"lev"];
        if (level.integerValue == 1) {
            [YJChat checkManagerWithUser:[CNUserManager shareManager].printedloginName
                                   level:[NSString stringWithFormat:@"%ld",[CNUserManager shareManager].userDetail.starLevel]
                              customerId:[CNUserManager shareManager].userInfo.rfCode
                              complation:^(BOOL success, NSString * _Nonnull message) {
                STRONGSELF_DEFINE
                strongSelf.isOpenWMQ = level.integerValue && success;
            }];
        }
    }];
}

- (void)setIsOpenWMQ:(BOOL)isOpenWMQ {
    _isOpenWMQ = isOpenWMQ;
    [self setupCSSuspendBall];
}

- (void)userLoginStatusChanged {
    [self initOCSSSDKShouldReload:false];
    [self checkWMQStatus];
}

#pragma mark  UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    HYNavigationController *curNav = (HYNavigationController *)viewController;
    if ([curNav.jk_rootViewController isKindOfClass:[CNMineVC class]] && ![CNUserManager shareManager].isLogin) {
        
        [HYTextAlertView showWithTitle:@"温馨提示" content:@"我的页面有很多资金信息，登录后才可以查看哦" comfirmText:@"登录" cancelText:@"注册" comfirmHandler:^(BOOL isComfirm) {
            if (isComfirm) {
                [NNPageRouter jump2Login];
            } else {
                [NNPageRouter jump2Register];
            }
        }];
        
        return NO;
    }
    
    return YES;
}


#pragma mark - SuspendBallDelegte 弹球
-(void)hideSuspendBall{
    if (self.suspendBall && self.suspendBall.showFunction == YES) {
        [self.suspendBall suspendBallShow];
    }
    self.suspendBall.hidden = YES;
}

- (void)showSuspendBall {
    self.suspendBall.hidden = NO;
}

- (void)suspendBall:(UIButton *)subBall didSelectTag:(NSInteger)tag{
    [self.suspendBall suspendBallShow];
    
    NSString *title = subBall.titleLabel.text;
    if([title isEqualToString:@"VIP"]){
        //客服 微脉圈
        [NNPageRouter presentWMQCustomerService];
    }else if ([title isEqualToString:@"存取"]){
        //客服 存取款问题
        [NNPageRouter presentOCSS_VC];
    }else if ([title isEqualToString:@"疑问"]){
        //客服 其他问题
        [NNPageRouter presentOCSS_VC];
    }else if ([title isEqualToString:@"回拨"]){
        //电话回拨
        [CNServerView showServerWithDelegate:self];
    }else if ([title isEqualToString:@"400"]){
        //400
        [CNServiceRequest call400];
    }
}


#pragma mark - CNServerViewDelegate 电话回拨

- (void)serverView:(CNServerView *)server callBack:(NSString *)phone code:(NSString *)code messageId:(NSString *)messageId {
    [CNServiceRequest callCenterCallBackMessageId:messageId
                                          smsCode:code
                                         mobileNo:phone
                                          handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [kKeywindow jk_makeToast:@"客户代表将于1-10分钟内为您致电，请保持电话畅通哦 (^o^)" duration:4 position:JKToastPositionCenter];
        }
    }];
}

- (void)serverViewWillDialBindedPhone {
    [CNServiceRequest callCenterCallBackMessageId:nil
                                          smsCode:nil
                                         mobileNo:nil
                                          handler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            [kKeywindow jk_makeToast:@"客户代表将于1-10分钟内为您致电，请保持电话畅通哦 (^o^)" duration:4 position:JKToastPositionCenter];
        }
    }];
}


#pragma mark - 控制屏幕旋转方法
-(BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -
#pragma mark Fetch Unread Message
- (void)fetchUnreadCount {
    [self setUnreadToDefault];
    if ([CNUserManager shareManager].isLogin == false) {
        return;
    }
    
    WEAKSELF_DEFINE
    [CNUserCenterRequest queryLetterUnreadCountHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            NSInteger unread = [responseObj[@"totalRow"] intValue];
            weakSelf.unreadMessage = unread;
            
            UITabBarItem *item = self.tabBar.items.lastObject;
            if (unread == 0) {
                [item pp_hiddenBadge];
            }
            else {
                [item pp_addDotWithColor:[UIColor redColor]];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:BYMessageCountDidLoadNotificaiton object:nil];
        }
    }];
}

- (void)setUnreadToDefault {
    self.unreadMessage = 0;
    [self.tabBar.items.lastObject pp_hiddenBadge];
}

/**
 *初始化/Reload OCSS
 */
- (void)reloadOCSSSDK {
    [self initOCSSSDKShouldReload:true];
}

- (void)initOCSSSDKShouldReload:(BOOL)reload{
    CSChatInfo *info = [[CSChatInfo alloc]init];
    info.productId = [IVHttpManager shareManager].productId;//产品ID
    info.loginName = [IVHttpManager shareManager].loginName?:@"";//网站用户名，你们app的用户名
    info.token = [IVHttpManager shareManager].userToken?:@"";//网站登陆后的token,你们app的token
    info.domainName = [IVHttpManager shareManager].domain;//网站域名
    info.appid = [IVHttpManager shareManager].appId;//AppID
    info.uuid = [KeyChain getKeychainIdentifierUUID];//设备id，不穿 会默认生成
    info.baseUrl = [IVHttpManager shareManager].gateway;//app网关地址
    
    //导航栏设置
    info.title = @"在线客服";//导航栏标题
    info.backColor = [UIColor lightGrayColor];
    info.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontPFSB18]};
    info.barTintColor = kHexColor(0x1A1A2C);
    
    if (reload) {
        [CSVisitChatmanager cleanSDK];
    }
    
    [CNServiceRequest queryOCSSDomainHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            info.response = responseObj;
            info.domainBakList = responseObj[@"domainBakList"];
            if ([[HYNetworkConfigManager shareManager] environment] != IVNEnvironmentDevelop)
            {
                if (reload) {
                    [CSVisitChatmanager reloadSDK:info finish:^(CSServiceCode errCode) {
                        if (errCode == CSServiceCode_Request_NoIniting) {
                            //初始化失败时重新初始化;
                            [self jk_performAfter:3 block:^{
                                [self initOCSSSDKShouldReload:reload];
                            }];
                        }
                    }];
                }
                else {
                    [CSVisitChatmanager initSDK:info finish:^(CSServiceCode errCode) {
                        if (errCode == CSServiceCode_Request_NoIniting) {
                            //初始化失败时重新初始化;
                            [self jk_performAfter:3 block:^{
                                [self initOCSSSDKShouldReload:reload];
                            }];
                        }
                    } appearblock:nil disbock:nil];
                }                
            }
        }
    }];
    
}
@end
