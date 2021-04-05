//
//  HYNetworkConfigManager.m
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/20.
//  Copyright © 2020 james. All rights reserved.
//

#import "HYNetworkConfigManager.h"
#import "CNUserManager.h"
#import "CNHUB.h"
#import "CNSplashRequest.h"
#import "HYInGameHelper.h"

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
        [IVHttpManager shareManager].appId = @"ffb53e87cc3b433e91ad9e71qsi45d12";//A03DS02
        [IVHttpManager shareManager].productId = @"bb1f67de91gf74e54b31c96e8h5ft0c3";//A03
        [IVHttpManager shareManager].parentId = @"";//???: 渠道号
        [IVHttpManager shareManager].globalHeaders = @{@"pid": @"bb1f67de91gf74e54b31c96e8h5ft0c3",
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
            [IVHttpManager shareManager].gateway = @"http://10.66.72.156";//m.a03musdt.com    http://10.66.72.156
            [IVHttpManager shareManager].gateways = @[@"http://10.66.72.156"];
            break;
        }
        case IVNEnvironmentTest:
        {
            envName = @"运测环境";
            [IVHttpManager shareManager].gateway = @"https://usdtm.hwx22.com";
            [IVHttpManager shareManager].gateways = @[@"https://usdtm.hwx22.com"];
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
            [IVHttpManager shareManager].gateway = @"https://www.wang568.com";
            [IVHttpManager shareManager].gateways = @[@"https://www.wang568.com", @"https://www.sheng1568.com", @"https://www.cai1568.com"];
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
                       title:[NSString stringWithFormat:@"😄当前是%ld --【%@】",environment ,envName]];
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
