//
//  SplashViewController.m
//  HYGEntire
//
//  Created by zaky on 23/10/2019.
//  Copyright © 2019 kunlun. All rights reserved.
//

#import "SplashViewController.h"
#import "HY403ViewController.h"
#import "HYNavigationController.h"
#import "UIImage+ESUtilities.h"
#import <UIImageView+WebCache.h>
//#import "LoginAPIData.h"
//#import "CNTimeLog.h"
//#import "HomeAPIData.h"
//#import "ConfigAddressModel.h"
#import "CNSplashRequest.h"


#define kLastSplashImageUrlDicKey @"kLastSplashImageUrlDicKey"

@interface SplashViewController ()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger requestTime;
@property (nonatomic,strong) NSArray *gatewaysArr;
@property (nonatomic,assign) NSInteger selectGatewayIndex;
@property (nonatomic,assign) NSInteger requestGWTimes;
@property (nonatomic,strong) UIImageView *adImgView;
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    if ([CNSkinManager currSkinType] == SKinTypeBlack) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    imgView.image = [UIImage imageNamed:@"qdy"];

    UIImageView *adView = [[UIImageView alloc]init];
    self.adImgView = adView;
    adView.layer.masksToBounds = YES;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSplashImageUrlDicKey];
    [adView sd_setImageWithURL:[NSURL URLWithString:dic[@"imgurl"]?:@""]];
    [self.view addSubview:adView];
    adView.contentMode = UIViewContentModeScaleAspectFill;
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        if (KIsIphoneXSeries) {
            make.bottom.equalTo(self.view).offset(-144);
        }else{
            make.bottom.equalTo(self.view).offset(-100);
        }
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(goToLoginStart) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    // 基本废弃
//    [CNSplashRequest welcome:^(id responseObj, NSString *errorMsg) {
//        if (!KIsEmptyString(errorMsg)) {
//            return;
//        }
//        WelcomeModel *welcomeModel = [WelcomeModel cn_parse:responseObj];
//        //广告图
//        if (welcomeModel.image.length>0) {
//            [self.adImgView sd_setImageWithURL:[NSURL URLWithString:welcomeModel.image]];
//            [SplashViewController saveImageUrl:welcomeModel.image link:welcomeModel.link];
//        }
//    }];
    
    [CNSplashRequest queryCDNH5Domain:^(id responseObj, NSString *errorMsg) {
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            NSString *cdnAddr = responseObj[@"csdnAddress"];
            NSString *h5Addr = responseObj[@"h5Address"];
            if ([cdnAddr containsString:@","]) {
                cdnAddr = [cdnAddr componentsSeparatedByString:@","].firstObject;
            }
            [IVHttpManager shareManager].cdn = cdnAddr;
            [IVHttpManager shareManager].domain = h5Addr;
        }
        
    }];
    
    [CNSplashRequest queryNewVersion:^(BOOL isHardUpdate) {
        //TODO: 更新弹窗
        [self requestAreaLimit];
    }];
    
}


- (void)showJumpBtn{
    
    UIView *shadowBg = [[UIView alloc]init];
    shadowBg.backgroundColor = [UIColor blackColor];
    shadowBg.alpha = 0.2;
    [self.view addSubview:shadowBg];
    shadowBg.layer.masksToBounds = YES;
    shadowBg.layer.cornerRadius = 4;

    UIButton *jumpbtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-52-15, 30, 52, 30)];
    [jumpbtn setTitle:@"跳过" forState:UIControlStateNormal];
    jumpbtn.backgroundColor = [UIColor clearColor];
    jumpbtn.titleLabel.font = [UIFont fontPFM13];
    [jumpbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [jumpbtn addTarget:self action:@selector(goToLoginStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpbtn];

    [shadowBg mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(jumpbtn).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


//
//-(void)requestNewAddressForApp {
//    ///welcome
//    NSMutableDictionary *paramDic = [ManageDataModel configBasicParamDic];
//    NSString *gatewayAddress = EnvironmentConfig.gatewayAddressRequet_domain;
//    if ([NetWorkEnvironmentConfig readGatewayAddress].length > 1) {
//        gatewayAddress = [NetWorkEnvironmentConfig readGatewayAddress];
//    }
//    [paramDic setObject:gatewayAddress forKey:@"url"];
//    _requestGWTimes++;
//    if (_requestGWTimes > 3) {
//        return;
//    }
//    NSString *dynamicGwUrl = EnvironmentConfig.dynamicGwAddress_domain;  //
//    if (dynamicGwUrl.length < 1) {
//        dynamicGwUrl = [NetWorkEnvironmentConfig readDynamicGwAddresses];
//    }
//    dynamicGwUrl = [NSString stringWithFormat:@"%@/%@",dynamicGwUrl,@"getDsGwAddress"];
//
//    WEAKSELF_DEFINE
//    [MLRequestNetWork POSTFORFULLURL:dynamicGwUrl parameters:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
//        STRONGSELF_DEFINE
//        if (responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]) {
//            return  ;
//        }
//        if ([responseObject[@"body"] isKindOfClass:[NSArray class] ] ) {
//            NSArray *bodyGatewayArr = responseObject[@"body"];
//            strongSelf.gatewaysArr = bodyGatewayArr ;
//            strongSelf.selectGatewayIndex = 0;
//            [strongSelf selectGateWayAddress];
//        }
//    } failure:^(NSURLSessionDataTask *task, MLFrameworkError *error,id responseObject) {
//        DLog(@"responseObject:%@  error:%@\n",responseObject,error);
//        [weakSelf requestNewAddressForApp];  //如果请求失败3次 则不再请求
//    }];
//}



//区域限制
- (void)requestAreaLimit {
#ifdef DEBUG
    [self goToLoginStart];
#else
    [CNSplashRequest checkAreaLimit:^(BOOL isAllowEntry) {
        if (!isAllowEntry) {
            [self goTo404];
        } else {
            [self goToLoginStart];
        }
    }];
#endif
}



+ (void)saveImageUrl:(NSString *)url link:(NSString *)link{
    NSDictionary *dic = @{@"imgurl":url?:@"",@"link":link?:@""};
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:kLastSplashImageUrlDicKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)goTo404{
   [self invalidateTimer];
    
    HY403ViewController *vc = [[HY403ViewController alloc] init];
    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = YES;
    
    UIImage *clearImg = [UIImage createImageWithColor:[UIColor clearColor]];
    [nav.navigationBar setBackgroundImage:clearImg forBarMetrics:UIBarMetricsDefault];
    [NNControllerHelper changeRootVc:nav];
    
}

- (void)goToLoginStart{
    [self invalidateTimer];
    
//    if ([[ManageDataModel shareManage] getLoginUserModel]) {
////        [HYGPageRouter jump2MainPage];
//        [LoginAPIData requsetWhiteListSuccess:^(id responseObject) {
//            [HYGPageRouter jump2MainPage];
//        } failure:^(MLFrameworkError *error) {
//            [HYGPageRouter changeRootVc2TYGGPage];
//        }];
//    } else {
//        [HYGPageRouter jump2LoginPage];
//    }
    [NNPageRouter changeRootVc2MainPage];

}


- (void)adBtnTap{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:kLastSplashImageUrlDicKey];
    if (dic == nil) {
        return;
    }
    
    NSString *link = [NSString stringWithFormat:@"%@",dic[@"link"]];
    if (KIsEmptyString(link)) {
        return;
    }
    
    [self invalidateTimer];
}

- (void)invalidateTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([CNSkinManager currSkinType] == SKinTypeBlack) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}



@end
