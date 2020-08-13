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
//#import "HYVIPViewController.h"
#import "HYBonusViewController.h"
#import "HYGloryViewController.h"
#import "CNMineVC.h"

#import "UIImage+ESUtilities.h"
#import "SuspendBall.h"
#import "CNServerView.h"
#import "CNHomeRequest.h"

@interface HYTabBarViewController ()<UITabBarControllerDelegate, SuspendBallDelegte, CNServerViewDelegate>
@property (nonatomic, strong) SuspendBall *suspendBall;
@end

@implementation HYTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupControllers];
    [self setupAppearance];
    [self setupCSSuspendBall];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupAppearance) name:CNSkinChangeNotification object:nil];
}

- (void)setupAppearance{
    
    if (@available(iOS 13, *)) {
        UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
        // 设置背景
        UIImage *bgimg = [UIImage createImageWithRadius:0 Color:KColorRGB(12, 11, 17) bounds:CGRectMake(0, 0, kScreenWidth, kTabBarHeight)];
        appearance.backgroundImage = bgimg;
        if (CNSkinManager.currSkinType == SKinTypeBlack) {
            appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else {
            appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
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
    
//    HYNavigationController *vipNav = [HYNavigationController navigationControllerWithController:[HYVIPViewController class]
//                                                                                        tabBarTitle:@"VIP"
//                                                                                        normalImage:[UIImage imageNamed:@"vip"]
//                                                                                      selectedImage:[UIImage imageNamed:@"vip_s"]];
//    [vcs addObject:vipNav];
    
    HYNavigationController *bonusNav = [HYNavigationController navigationControllerWithController:[HYBonusViewController class]
                                                                                            tabBarTitle:@"优惠"
                                                                                            normalImage:[UIImage imageNamed:@"youhui"]
                                                                                          selectedImage:[UIImage imageNamed:@"youhui_s"]];
    [vcs addObject:bonusNav];
   
    HYNavigationController *gloryNav = [HYNavigationController navigationControllerWithController:[HYGloryViewController class]
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
    CGFloat btnWH = 60.f;
    NSArray *imgNameGroup = @[@"", @"", @"形状",@"形状结合"];
    SuspendBall *suspendBall = [SuspendBall suspendBallWithFrame:CGRectMake(kScreenWidth - btnWH, kScreenHeight *0.75, btnWH, btnWH) delegate:self subBallImageArray:imgNameGroup];
    suspendBall.top = kNavPlusStaBarHeight;
    suspendBall.bottom = kTabBarHeight + kSafeAreaHeight;
    suspendBall.hidden = NO;
    self.suspendBall = suspendBall;
    [self.view addSubview:suspendBall];
    [self.view bringSubviewToFront:suspendBall];
}


#pragma mark  UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
        
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    
//    if (index==4 && (![ManageDataModel shareManage].getLoginUserModel || [ManageDataModel shareManage].isTryPlay)) {
//        [HYAlertView showToastViewWithTitle:@"温馨提示" content:@"我的页面有很多资金信息，登录后才可以查看哦" leftTitle:@"注册" rightTitle:@"登录" confirmBtnBlock:^(BOOL isConfirm) {
//
//            if (isConfirm) {
////                STRONGSELF_DEFINE
////                [strongSelf loginClick];
//                [HYGPageRouter jump2RegisterPage];
//            }else{
////                STRONGSELF_DEFINE
////                [strongSelf registerClick];
//                [HYGPageRouter jump2LoginPage];
//            }
//        }];
//
//
//        return NO;
//    }
//
//    if (index==4 && ![ManageDataModel shareManage].userPrivateModel.mobileNo && !IsEmptyString([ManageDataModel shareManage].balance) && [[ManageDataModel shareManage].balance floatValue] > 0) {
//
//        NSString *lastAlertBindPhoneKey = @"kLastAlertBindPhoneKey";
//        NSDate *lastDate = [UserDefault readAnyObjectUserDeftalusWithKey:lastAlertBindPhoneKey];
//        if (lastDate) {
//            if ([[NSDate date] timeIntervalSinceDate:lastDate]<= 24*60*60) {
//                //24小时之内弹出过
//                return YES;
//            }
//        }
//        [UserDefault writeAnyObjectUserDefaultsWithKey:lastAlertBindPhoneKey value:[NSDate date]];
//
//        WEAKSELF_DEFINE
//        [HYAlertView showToastViewWithTitle:@"温馨提示" content:@"为保障您的资金安全，请尽快绑定手机号" leftTitle:@"" rightTitle:@"去绑定" confirmBtnBlock:^(BOOL isConfirm) {
//
//            STRONGSELF_DEFINE
//            VerifyPhoneNumberViewController *vc = [[VerifyPhoneNumberViewController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [strongSelf.selectedViewController pushViewController:vc animated:YES];
//        }];
//    }
    return YES;
}


#pragma mark - SuspendBallDelegte 弹球
-(void)hideSuspendBall{
    if (self.suspendBall && self.suspendBall.showFunction == YES) {
        [self.suspendBall suspendBallShow];
    }
}

- (void)suspendBall:(UIButton *)subBall didSelectTag:(NSInteger)tag{
    
    [self hideSuspendBall];
    
    if(tag == 0){
        //客服 存取款问题
        [NNPageRouter jump2Live800Type:CNLive800TypeDeposit];
    }else if (tag == 1){
        //客服 其他问题
        [NNPageRouter jump2Live800Type:CNLive800TypeNormal];
    }else if (tag == 2){
        //电话回拨
        [CNServerView showServerWithDelegate:self];
    }else if (tag == 3){
        //400
        [self call400];
    }
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

- (void)call400{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4001203093"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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

@end
