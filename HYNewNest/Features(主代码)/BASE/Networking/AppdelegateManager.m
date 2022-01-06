//
//  AppdelegateManager.m
//  HYNewNest
//
//  Created by RM03 on 2021/12/8.
//  Copyright © 2021 BYGJ. All rights reserved.
//


#import "AppdelegateManager.h"
#import "HYHttpPathConst.h"
#import "A03CheckDomainModel.h"
#import "AppSettingRequest.h"
#import "IVCheckNetworkWrapper.h"
#import "IVCacheWrapper.h"

@implementation AppdelegateManager
@synthesize gateways = _gateways;
@synthesize websides = _websides;
@synthesize environment = _environment;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static AppdelegateManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[AppdelegateManager alloc] init];
#ifdef DEBUG
        IVNEnvironment environment = [[NSUserDefaults standardUserDefaults] integerForKey:@"IVNEnvironment"];
        _manager.environment = environment;
#else
        _manager.environment = IVNEnvironmentPublish;
#endif
    });
    return _manager;
}
- (void)setGateways:(NSArray *)gateways
{
    _gateways = gateways;
    [IVCacheWrapper setObject: gateways ? gateways:@[] forKey:IVCacheAllGatewayKey];
}
- (NSArray *)gateways
{
    if (!_gateways) {
        _gateways = [IVCacheWrapper objectForKey:IVCacheAllGatewayKey];
        if (_gateways.count > 0)
        {
            return _gateways;
        }else
        {
            switch (_environment) {
                case IVNEnvironmentDevelop://本地
                    _gateways = @[@"http://www.pt-gateway.com/_glaxy_1e3c3b_/"];
                    break;
                case IVNEnvironmentTest://运测
                    _gateways = @[@"https://h5.918rr.com/_glaxy_1e3c3b_/"];
                    break;
                case IVNEnvironmentPublish:
                    _gateways = @[@"https://wrd.58baili.com/pro/_glaxy_1e3c3b_/", @"https://m.pkyorjhn.com:9188/_glaxy_1e3c3b_/"];
                    break;
                default:
                    _gateways = @[@"http://www.pt-gateway.com/_glaxy_1e3c3b_/"];
                    break;
            }
        }
    }
    return _gateways;
}
- (void)setWebsides:(NSArray *)websides
{
    _websides = websides;
    [IVCacheWrapper setObject:_websides ? _websides : @[] forKey:IVCacheAllH5DomainsKey];
}
- (NSArray *)websides
{
    if (!_websides)
    {
        _websides = [IVCacheWrapper objectForKey:IVCacheAllH5DomainsKey];
        if (_websides.count > 0)
        {
            return _websides;
        }else
        {
            switch (_environment) {
                case IVNEnvironmentDevelop:
                    _websides = @[@"https://m.ag800.com"];
                    break;
                case IVNEnvironmentTest:
                    _websides = @[@"https://m.ag800.com"];
                    break;
                case IVNEnvironmentPublish:
                    _websides = @[@"https://m.ag800.com"];
                    break;
                default:
                    _websides = @[@"https://m.ag800.com"];
                    break;
            }
        }
    }
    return _websides;
}
- (IVNEnvironment)environment
{
    IVNEnvironment environment = [[NSUserDefaults standardUserDefaults] integerForKey:@"IVNEnvironment"];
    return environment;
}
- (void)checkDomainHandler:(void (^)(void))handler  {
    
    [self recheckDomain:handler];
}
- (void)recheckDomain:(void (^)(void))handler  {
 
    [AppSettingRequest getAppSettingTask:^(id responseObj, NSString *errorMsg) {
//        IVJResponseObject *result = responseObj;
        if (!errorMsg) {
            A03CheckDomainModel *model = [A03CheckDomainModel cn_parse:responseObj];
            NSMutableArray * tempGetArr = [NSMutableArray new];
            NSMutableArray * tempWebArr = [NSMutableArray new];
            for (NSString *getway in model.getways) {
                if ([[getway substringFromIndex:getway.length-1] isEqualToString:@"/"]) {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@_glaxy_1e3c3b_/", getway]];
                } else {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@/_glaxy_1e3c3b_/", getway]];
                }
            }
           
            for (NSString *websit in model.websides) {
                if ([[websit substringFromIndex:websit.length-1] isEqualToString:@"/"]) {
                    [tempWebArr addObject:websit];
                } else {
                    [tempWebArr addObject:[NSString stringWithFormat:@"%@/", websit]];
                }
            }
            [[AppdelegateManager shareManager] setGateways:tempGetArr];
            [[AppdelegateManager shareManager] setWebsides:tempWebArr];
        }else
        {
            [[AppdelegateManager shareManager] setGateways:nil];
            [[AppdelegateManager shareManager] setWebsides:nil];
        }
        [IVHttpManager shareManager].gateways = [[AppdelegateManager shareManager] gateways];  // 网关列表
        [IVHttpManager shareManager].domains = [[AppdelegateManager shareManager] websides];
        handler();
    }];
 
}

- (void)recheckDomainWithTestSpeed
{
    [AppSettingRequest getAppSettingTask:^(id responseObj, NSString *errorMsg) {
//        IVJResponseObject *result = responseObj;
        if (!errorMsg) {
            A03CheckDomainModel *model = [A03CheckDomainModel cn_parse:responseObj];
            NSMutableArray * tempGetArr = [NSMutableArray new];
            NSMutableArray * tempWebArr = [NSMutableArray new];
            for (NSString *getway in model.getways) {
                if ([[getway substringFromIndex:getway.length-1] isEqualToString:@"/"]) {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@_glaxy_1e3c3b_/", getway]];
                } else {
                    [tempGetArr addObject:[NSString stringWithFormat:@"%@/_glaxy_1e3c3b_/", getway]];
                }
            }
           
            for (NSString *websit in model.websides) {
                if ([[websit substringFromIndex:websit.length-1] isEqualToString:@"/"]) {
                    [tempWebArr addObject:websit];
                } else {
                    [tempWebArr addObject:[NSString stringWithFormat:@"%@/", websit]];
                }
            }
            [[AppdelegateManager shareManager] setGateways:tempGetArr];
            [[AppdelegateManager shareManager] setWebsides:tempWebArr];
        }else
        {
            [[AppdelegateManager shareManager] setGateways:nil];
            [[AppdelegateManager shareManager] setWebsides:nil];
        }
        [IVHttpManager shareManager].gateways = [[AppdelegateManager shareManager] gateways];  // 网关列表
        [IVHttpManager shareManager].domains = [[AppdelegateManager shareManager] websides];
        
        [IVCheckNetworkWrapper getOptimizeUrlWithArray:[IVHttpManager shareManager].gateways
                                                isAuto:YES
                                                  type:IVKCheckNetworkTypeGateway
                                              progress:nil completion:nil];
    }];

}
@end
