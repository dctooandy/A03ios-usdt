//
//  HYNetworkConfigManager.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/20.
//  Copyright © 2020 james. All rights reserved.
//

#import "HYNetworkConfigManager.h"
#import "CNUserManager.h"
#import "CNTOPHUB.h"
#import "CNSplashRequest.h"
#import "HYInGameHelper.h"
#import "HYTabBarViewController.h"

@interface HYNetworkConfigManager ()
@property (nonatomic, assign, readwrite) IVNEnvironment environment;
@end

@implementation HYNetworkConfigManager
@synthesize environment = _environment;

+ (void)load {
    [HYNetworkConfigManager shareManager];
}

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static HYNetworkConfigManager *_configManager = nil;
    dispatch_once(&onceToken, ^{
        _configManager = [[HYNetworkConfigManager alloc] init];
#ifdef DEBUG
        IVNEnvironment environment = [[NSUserDefaults standardUserDefaults] integerForKey:@"IVNEnvironment"];
        _configManager.environment = environment;
#else
        _configManager.environment = IVNEnvironmentPublish;
#endif
        [IVHttpManager shareManager].environment = _configManager.environment;
        [IVHttpManager shareManager].appId = @"dzqAQAGPCjn1kUqzeiHsUTy57sFVTNQs";//A01NEWAPP02
        [IVHttpManager shareManager].productId = @"1682d3a2ee0c4ee8acbe58a5c39bb888";//A01
        [IVHttpManager shareManager].parentId = @"";//???: 渠道号
        [IVHttpManager shareManager].globalHeaders = @{@"pid": @"1682d3a2ee0c4ee8acbe58a5c39bb888",
                                                       @"Authorization": @"Bearer"};
        [IVHttpManager shareManager].userToken = [CNUserManager shareManager].userInfo.token;
        [IVHttpManager shareManager].loginName = [CNUserManager shareManager].userInfo.loginName;
        
    });
    return _configManager;
}

//Debug才会进入
- (void)switchEnvirnment {
#ifdef DEBUG
    // 切换环境 保存
    self.environment += 1;
    if (self.environment > 2) {
        self.environment = 0;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:self.environment forKey:@"IVNEnvironment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 重新加载游戏线路信息
    [[HYInGameHelper sharedInstance] queryHomeInGamesStatus];
    
    // 重新获取H5/CDN
    [CNSplashRequest queryCDNH5Domain:^(id responseObj, NSString *errorMsg) {
        NSString *cdnAddr = responseObj[@"csdnAddress"];
        NSString *h5Addr = responseObj[@"h5Address"];
        if ([cdnAddr containsString:@","]) {
            cdnAddr = [cdnAddr componentsSeparatedByString:@","].firstObject;
        }
        [IVHttpManager shareManager].cdn = cdnAddr;
        [IVHttpManager shareManager].domain = h5Addr;
    }];
    
    // 重新加载OCSS
    [(HYTabBarViewController *)[NNControllerHelper currentTabBarController] initOCSSSDKShouldReload:NO];

#endif
}


#pragma mark - GET&SET
- (IVNEnvironment)environment {
    return _environment;
}

- (void)setEnvironment:(IVNEnvironment)environment {
    NSString *envName;
    
    NSMutableDictionary *eventDict = @{}.mutableCopy;
    [eventDict setValue:[IVHttpManager shareManager].gateway forKey:@"from"];
    
    _environment = environment;
    [IVHttpManager shareManager].environment = environment;
    [IVHttpManager shareManager].domain = @"https://m.ag800.com"; //H5
    [IVHttpManager shareManager].cdn = @"https://a03front.58baili.com"; //cdn
    
    switch (environment) {
        case IVNEnvironmentDevelop:
        {
            envName = @"本地环境";
//            [IVHttpManager shareManager].gateway = @"http://10.66.72.156/_glaxy_83e6dy_/";//m.a03musdt.com  10.66.72.123
//            [IVHttpManager shareManager].gateways = @[@"http://10.66.72.156/_glaxy_83e6dy_/"];
//            [IVHttpManager shareManager].gateway = @"http://10.86.64.5:8081/_glaxy_83e6dy_/";      //https://api.a03.app 10.86.64.5:8081 TW本地环境
//            [IVHttpManager shareManager].gateways = @[@"http://10.86.64.5:8081/_glaxy_83e6dy_/"];
            [IVHttpManager shareManager].gateway = @"http://www.pt-gateway.com/_glaxy_1e3c3b_/";
            [IVHttpManager shareManager].gateways = @[@"http://www.pt-gateway.com/_glaxy_1e3c3b_/"];
            break;
        }
        case IVNEnvironmentTest:
        {
            envName = @"运测环境";
            [IVHttpManager shareManager].gateway = @"https://h5.918rr.com/_glaxy_1e3c3b_/";
            [IVHttpManager shareManager].gateways = @[@"https://h5.918rr.com/_glaxy_1e3c3b_/"];
//            [IVHttpManager shareManager].gateways = @[@"https://usdtm.hwx22.com", @"https://usdtw.hwx22.com", @"https://usdtmp.hwx22.com", @"https://usdtwp.hwx22.com"];
            break;
        }
//        case IVNEnvironmentPublishTest:
//        {
//            envName = @"旧运测环境";
//            [IVHttpManager shareManager].gateway = @"http://oldm.hwx22.com";
//            [IVHttpManager shareManager].gateways = @[@"http://oldm.hwx22.com"];
//            break;
//        }
        case IVNEnvironmentPublish:
        {
            envName = @"运营环境";
            [IVHttpManager shareManager].gateway =  @"https://wu7018.com/_glaxy_1e3c3b_/";
            [IVHttpManager shareManager].gateways = @[@"https://wu7021.com/_glaxy_1e3c3b_/", @"https://wu7020.com/_glaxy_1e3c3b_/", @"https://wu7018.com/_glaxy_1e3c3b_/", @"https://www.wang568.com/_glaxy_1e3c3b_/", @"https://www.sheng1568.com/_glaxy_1e3c3b_/", @"https://www.cai1568.com/_glaxy_1e3c3b_/", @"https://179bi.com/_glaxy_1e3c3b_/"];
            
//            [IVHttpManager shareManager].gateway = @"https://179bi.com/_glaxy_1e3c3b_/";
//            [IVHttpManager shareManager].gateways = @[@"https://179bi.com/_glaxy_1e3c3b_/"];

            break;
        }
        default:
            break;
    }
    
    //通知外部
    [eventDict setValue:[IVHttpManager shareManager].gateway forKey:@"to"];
    [[NSNotificationCenter defaultCenter] postNotificationName:IVNGatewaySwitchNotification object:nil userInfo:eventDict.copy];
    
#ifdef DEBUG
    [kKeywindow jk_makeToast:[IVHttpManager shareManager].gateway
                    duration:4
                    position:JKToastPositionCenter
                       title:[NSString stringWithFormat:@"😄当前是%ld --【%@】",(long)environment ,envName]];
#endif
}

- (NSMutableDictionary *)baseParam {
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"productId"] = [IVHttpManager shareManager].productId;
    if (!KIsEmptyString([IVHttpManager shareManager].loginName)) { //非空
        param[@"loginName"] = [IVHttpManager shareManager].loginName;
    }
    return param;
}

@end
