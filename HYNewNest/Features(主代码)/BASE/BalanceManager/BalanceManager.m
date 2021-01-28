//
//  BalanceManager.m
//  HYNewNest
//
//  Created by zaky on 11/26/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "BalanceManager.h"
#import "CNBaseNetworking.h"

@interface BalanceManager()
{
    NSUInteger balancesSec;
    NSUInteger promoteSec;
    NSUInteger betAmountSec;
    AccountMoneyDetailModel *_balanceDetailModel;
}
@property (nonatomic, strong) AccountMoneyDetailModel *balanceDetailModel;
@property (nonatomic, strong) PromoteXimaModel        *promoteXimaModel;
@property (nonatomic, strong) BetAmountModel          *betAmountModel;
@property (nonatomic, weak) NSTimer *balanceTimer;

@end

@implementation BalanceManager
@dynamic balanceDetailModel;

#pragma mark - setter & getter

- (void)setBalanceDetailModel:(AccountMoneyDetailModel *)balanceDetailModel {
    _balanceDetailModel = balanceDetailModel;
    _balanceDetailModel.primaryKey = [CNUserManager shareManager].userInfo.customerId;
    [_balanceDetailModel bg_saveOrUpdate];
}

- (AccountMoneyDetailModel *)balanceDetailModel {
    if (_balanceDetailModel) {
        return _balanceDetailModel;
    } else {
        MyLog(@"XXXX 返回余额数据库的数据 XXXX");
        NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"primaryKey"),[CNUserManager shareManager].userInfo.customerId];
        NSArray* arr = [AccountMoneyDetailModel bg_find:DBName_AccountBalance where:where];
        if (arr.count > 0) {
            return arr.firstObject;
        }
        
    }
    return nil;
}

#pragma mark - View Life Cycle

+ (instancetype)shareManager {
    static BalanceManager * _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[BalanceManager alloc] init];
        _manager->balancesSec = 3; //刚启动三秒内不请求 接口太慢
        _manager->promoteSec = 0;
        _manager->betAmountSec = 0;
        [_manager setupTimers];
    });
    return _manager;
}

- (void)setupTimers
{
    [self invalidateTimers]; // 创建定时器前先停止定时器，不然会出现僵尸定时器
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(automaticCounter) userInfo:nil repeats:YES];
    _balanceTimer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)pauseTimer {
    [_balanceTimer setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
//    MyLog(@"@@@@@@@@@@@@ 倒计时恢复60，余额定时器开始");
    [_balanceTimer setFireDate:[NSDate distantPast]];
}

- (void)invalidateTimers
{
    [_balanceTimer invalidate];
    _balanceTimer = nil;
}

- (void)automaticCounter {
    if (balancesSec > 0) {
        balancesSec --;
    }
    if (promoteSec > 0) {
        promoteSec --;
    }
    if (betAmountSec > 0) {
        betAmountSec --;
    }
    if (balancesSec <= 0 && promoteSec <= 0 && betAmountSec <= 0) {
        MyLog(@"@@@@@@@@@@@@ 倒计时全为0，余额定时器停止");
        [self pauseTimer];
    }
//    MyLog(@"@@@@@@@@@@@@@ balancesSec = %lu, promoteSec = %lu, betAmount = %lu",balancesSec, promoteSec, betAmountSec);
}

- (void)getBalanceDetailHandler:(void(^)(AccountMoneyDetailModel * _Nonnull))handler {
    if (self.balanceDetailModel && balancesSec > 0) {
        handler(self.balanceDetailModel);
    } else {
        [self requestBalaceHandler:^(AccountMoneyDetailModel *model) {
            handler(model);
        }];
    }
}

- (void)getPromoteXimaHandler:(void(^)(PromoteXimaModel * _Nonnull))handler {
    if (_promoteXimaModel && promoteSec > 0) {
        handler(_promoteXimaModel);
    } else {
        [self requestMonthPromoteAndXimaHandler:^(PromoteXimaModel *model) {
            handler(model);
        }];
    }
}

- (void)getWeeklyBetAmountHandler:(void(^)(BetAmountModel * _Nonnull))handler {
    if (_betAmountModel && betAmountSec > 0) {
        handler(_betAmountModel);
    } else {
        [self requestBetAmountHandler:^(BetAmountModel *model) {
            handler(model);
        }];
    }
}


#pragma mark - REQUEST

/// 详细余额数据
- (void)requestBalaceHandler:(nullable void(^)(AccountMoneyDetailModel *))handler {
    
//    [CNUserCenterRequest requestAccountBalanceHandler:^(id responseObj, NSString *errorMsg) {
//        AccountMoneyDetailModel *model = [AccountMoneyDetailModel cn_parse:responseObj];
//        self.balanceDetailModel = model;
//        self->balancesSec = 60;
//        [self resumeTimer];
//        if (handler) {
//            handler(model);
//        }
//    }];
    
    // 当多个重复请求的时候 保存回调，只等待一个网络请求返回
    @synchronized (self) {
        MyLog(@"XXXX 加锁，避免数组重复创建添加等问题, %@ XXXX", [NSThread currentThread]);
        static NSMutableArray * successBlocks;//用数组保存回调
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{//仅创建一次数组
            successBlocks = [NSMutableArray new];
        });
        if (handler) {
            [successBlocks addObject:handler];
            MyLog(@"XXXX 每调用一次此函数，就把回调加进数组中:%@\n 添加回调block 已存在%lu个 XXXX",successBlocks, (unsigned long)successBlocks.count);
        }

        static BOOL isProcessing = NO;
        if (isProcessing == YES) {
            MyLog(@"XXXX 如果已经在请求了，就不再发出新的请求 XXXX");
            return;
        }
        isProcessing = YES;
        
        
        [BalanceManager requestAccountBalanceHandler:^(id responseObj, NSString *errorMsg) {
            isProcessing = NO;
            
            if (errorMsg) {
                self->balancesSec = 0;
                @synchronized (self) {
                    MyLog(@"XXXX 网络请求失败!!! XXXX");
                    for (AccountBalancesBlock eachSuccess in successBlocks) {//遍历回调数组，把结果发给每个调用者
                        eachSuccess(self.balanceDetailModel);
                    }
                    [successBlocks removeAllObjects];
                    
                }
                return;
            }
            
            AccountMoneyDetailModel *model = [AccountMoneyDetailModel cn_parse:responseObj];
            self.balanceDetailModel = model;
            self->balancesSec = 120;
            [self resumeTimer];

            @synchronized (self) {
                MyLog(@"XXXX 网络请求的回调也要加锁，可能是另一个线程%@ XXXX, SucBlock:%@ XXXX", [NSThread currentThread], successBlocks);
                for (AccountBalancesBlock eachSuccess in successBlocks) {//遍历回调数组，把结果发给每个调用者
                    eachSuccess(model);
                }
                [successBlocks removeAllObjects];
            }
        }];
        
    }

}

/// 月优惠和洗码
- (void)requestMonthPromoteAndXimaHandler:(nullable void(^)(PromoteXimaModel *))handler {
    [BalanceManager requestMonthPromoteAndXimaHandler:^(id responseObj, NSString *errorMsg) {
        PromoteXimaModel *pxModel = [PromoteXimaModel cn_parse:responseObj];
        self.promoteXimaModel = pxModel;
        self->promoteSec = 120;
        [self resumeTimer];
        if (handler) {
            handler(pxModel);
        }
    }];
}

/// 周有效投注额
- (void)requestBetAmountHandler:(nullable void(^)(BetAmountModel *))handler {
    [BalanceManager requestBetAmountHandler:^(id responseObj, NSString *errorMsg) {
        BetAmountModel *betModel = [BetAmountModel cn_parse:responseObj];
        self.betAmountModel = betModel;
        self->betAmountSec = 120;
        [self resumeTimer];
        if (handler) {
            handler(betModel);
        }
    }];
}


#pragma mark - Raw Request

+ (void)requestBetAmountHandler:(HandlerBlock)handler {
    
    [CNBaseNetworking POST:kGatewayExtraPath(config_betAmountLevel) parameters:[kNetworkMgr baseParam] completionHandler:handler];
}

+ (void)requestAccountBalanceHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:@"1" forKey:@"flag"];  //1 缓存15秒 9不缓存 不传默认缓存2分钟
    [param setObject:[CNUserManager shareManager].isUsdtMode?@1:@0 forKey:@"defineFlag"]; //1usdt账户余额  0人民币账户余额
    
    [CNBaseNetworking POST:kGatewayPath(config_getBalanceInfo) parameters:param completionHandler:handler];
}

+ (void)requestMonthPromoteAndXimaHandler:(HandlerBlock)handler {
    
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    [param setObject:@(1) forKey:@"inclPromoAmountByMonth"];
    [param setObject:@(1) forKey:@"inclRebatedAmountByMonth"];
    
    [CNBaseNetworking POST:kGatewayPath(config_getByLoginNameEx) parameters:param completionHandler:handler];
}

@end
