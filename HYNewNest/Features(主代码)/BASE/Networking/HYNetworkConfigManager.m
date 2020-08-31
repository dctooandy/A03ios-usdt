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
        [IVHttpManager shareManager].appId = @"A03DS02";
        [IVHttpManager shareManager].productId = @"A03";
        [IVHttpManager shareManager].parentId = @"";//TODO: 渠道号
        [IVHttpManager shareManager].globalHeaders = @{@"pid": @"A03",
                                                       @"Authorization": @"Bearer"};
        [IVHttpManager shareManager].userToken = [CNUserManager shareManager].userInfo.token;
        [IVHttpManager shareManager].loginName = [CNUserManager shareManager].userInfo.loginName;
        
    });
    return _configManager;
}

//Debug才会进入
- (void)switchEnvirnment {
#ifdef DEBUG
    self.environment += 1;
    if (self.environment > IVNEnvironmentPublish) {
        self.environment = IVNEnvironmentDevelop;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:self.environment forKey:@"IVNEnvironment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
            [IVHttpManager shareManager].gateway = @"http://www.pt-gateway-dev.com";
            [IVHttpManager shareManager].gateways = @[@"http://www.pt-gateway-dev.com"];
            break;
        }
        case IVNEnvironmentTest:
        {
            envName = @"开发环境"; //同运测
            [IVHttpManager shareManager].gateway = @"https://usdtm.hwx22.com";
            [IVHttpManager shareManager].gateways = @[@"https://usdtm.hwx22.com"];
//            [IVHttpManager shareManager].gateways = @[@"https://usdtm.hwx22.com", @"https://usdtw.hwx22.com", @"https://usdtmp.hwx22.com", @"https://usdtwp.hwx22.com"];
            break;
        }
        case IVNEnvironmentPublishTest:
        {
            envName = @"运测环境"; //稳定的运测环境
            [IVHttpManager shareManager].gateway = @"http://oldm.hwx22.com";
            [IVHttpManager shareManager].gateways = @[@"http://oldm.hwx22.com"];
            break;
        }
        case IVNEnvironmentPublish:
        {
            envName = @"运营环境";
            [IVHttpManager shareManager].gateway = @"http://115bi.com";
            [IVHttpManager shareManager].gateways = @[@"http://115bi.com"];
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
                    duration:3
                    position:JKToastPositionCenter
                       title:[NSString stringWithFormat:@"😄已切换到【%@】",envName]];
#endif
}

- (NSMutableDictionary *)baseParam {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@"A03" forKey:@"productId"];
    if (!KIsEmptyString([IVHttpManager shareManager].loginName)) { //非空
        [param setObject:[IVHttpManager shareManager].loginName forKey:@"loginName"];
    }
    return param;
}

@end
