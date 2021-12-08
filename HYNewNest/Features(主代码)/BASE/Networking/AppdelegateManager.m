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
    });
    return _manager;
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
- (void)setGateways:(NSArray *)gateways
{
    _gateways = gateways;
}
- (NSArray *)gateways
{
    if (!_gateways) {
        switch (_environment) {
            case 0:
                return @[@"http://www.pt-gateway.com/_glaxy_1e3c3b_/"];
                break;
            case 1:
                return @[@"http://h5.918rr.com/_glaxy_1e3c3b_/"];
                break;
            case 2:
                return  @[@"https://wu7021.com/_glaxy_1e3c3b_/", @"https://wu7020.com/_glaxy_1e3c3b_/", @"https://wu7018.com/_glaxy_1e3c3b_/", @"https://www.wang568.com/_glaxy_1e3c3b_/", @"https://www.sheng1568.com/_glaxy_1e3c3b_/", @"https://www.cai1568.com/_glaxy_1e3c3b_/", @"https://179bi.com/_glaxy_1e3c3b_/"];
                break;
            default:
                return @[@"http://www.pt-gateway.com/_glaxy_1e3c3b_/"];
                break;
        }
    }
    return _gateways;
}
- (void)setWebsides:(NSArray *)websides
{
    _websides = websides;
}
- (NSArray *)websides
{
    if (!_websides)
    {
        switch (_environment) {
            case 0:
                return @[@"https://m.ag800.com"];
                break;
            case 1:
                return @[@"https://m.ag800.com"];
                break;
            case 2:
                return @[@"https://m.ag800.com"];
                break;
            default:
                return @[@"https://m.ag800.com"];
                break;
        }
    }
    return _websides;
}
@end
