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
#import "CNSplashRequest.h"
#import <AVKit/AVKit.h>

@interface SplashViewController () {
    BOOL _videoDidEnd;
}
@property (nonatomic,strong) NSArray *gatewaysArr;
@property (nonatomic,assign) NSInteger selectGatewayIndex;
@property (nonatomic,assign) NSInteger requestGWTimes;
@property (nonatomic,strong) UIImageView *adImgView;

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic, strong) UILabel *lblVersion;
@end

@implementation SplashViewController

- (UILabel *)lblVersion {
    if (!_lblVersion) {
        UILabel *lbl = [UILabel new];
        lbl.text = [NSString stringWithFormat:@"当前版本: V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        [lbl sizeToFit];
        lbl.bottom = kScreenHeight - 30 -kSafeAreaHeight;
        lbl.centerX = kScreenWidth * 0.5;
        lbl.textColor = kHexColor(0x868686);
        _lblVersion = lbl;
    }
    return _lblVersion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 启动图背景
//    UIImageView *imgView = [[UIImageView alloc]init];
//    imgView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:imgView];
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    imgView.image = [UIImage imageNamed:@"qdy"];

    
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //读取本地视频路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CIRCULAR_06" ofType:@"mp4"];
    //为即将播放的视频内容进行建模
    AVPlayerItem *avplayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:path]];
    //给播放器赋值要播放的对象模型
    AVPlayer *avplayer = [AVPlayer playerWithPlayerItem:avplayerItem];
    self.player = avplayer;
    [avplayer play];
    //指定显示的Layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:avplayer];
    layer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    // 和启动图拉伸方式一致
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:layer];
    
    // 版本号
    [self.view addSubview:self.lblVersion];
    
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
        NSString *cdnAddr = responseObj[@"csdnAddress"];
        NSString *h5Addr = responseObj[@"h5Address"];
        if ([cdnAddr containsString:@","]) {
            cdnAddr = [cdnAddr componentsSeparatedByString:@","].firstObject;
        }
        [IVHttpManager shareManager].cdn = cdnAddr;
        [IVHttpManager shareManager].domain = h5Addr;
//        [IN3SAnalytics setDomain:h5Addr];
    }];
    
    // 检查区域限制 -> 进入首页
    [self requestAreaLimit];

    
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
            [self goTo403];
        } else {
            [self goToLoginStart];
        }
    }];
#endif
}

#pragma mark - 跳转

- (void)goTo403{
    HY403ViewController *vc = [[HY403ViewController alloc] init];
    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:vc];
    [NNControllerHelper changeRootVc:nav];
    
}

- (void)goToLoginStart{
//    // 动画演完才进入
//    if (!_videoDidEnd) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self goToLoginStart];
//        });
//        return;
//    }
    
//#ifdef DEBUG
//    [NNPageRouter changeRootVc2DevPage];
//#else
    [NNPageRouter changeRootVc2MainPage];
//#endif
}


- (void)videoPlayEnd {
    _videoDidEnd = YES;
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}



@end
