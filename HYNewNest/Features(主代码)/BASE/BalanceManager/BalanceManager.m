//
//  BalanceManager.m
//  HYNewNest
//
//  Created by zaky on 11/26/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "BalanceManager.h"


@interface BalanceManager()
{
    NSUInteger balancesSec;   // 余额 倒计时
//    NSUInteger promoteSec;  // 本月优惠和洗码 倒计时
    NSUInteger betAmountSec;  // 周有效投注额 + 月优惠和洗码 倒计时
    NSUInteger yebSec;        // 余额宝利息 倒计时
    AccountMoneyDetailModel *_balanceDetailModel;
}
@property (nonatomic, strong) AccountMoneyDetailModel *balanceDetailModel;
//@property (nonatomic, strong) PromoteXimaModel        *promoteXimaModel;
@property (nonatomic, strong) BetAmountModel          *betAmountModel;
@property (strong,nonatomic) CNYuEBaoBalanceModel     *yebModel;
@property (nonatomic, weak) NSTimer *balanceTimer;

@end

@implementation BalanceManager
@dynamic balanceDetailModel;

#pragma mark - setter & getter

- (void)setBalanceDetailModel:(AccountMoneyDetailModel *)balanceDetailModel {
    _balanceDetailModel = balanceDetailModel;
    _balanceDetailModel.primaryKey = [CNUserManager shareManager].userInfo.rfCode;
    [_balanceDetailModel bg_saveOrUpdate];
}

- (AccountMoneyDetailModel *)balanceDetailModel {
    if (_balanceDetailModel) {
        return _balanceDetailModel;
    } else {
        MyLog(@"XXXX 返回余额数据库的数据 XXXX");
        NSString* where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"primaryKey"),[CNUserManager shareManager].userInfo.rfCode];
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
//        _manager->promoteSec = 3;
        _manager->betAmountSec = 3;
        _manager->yebSec = 3;
        [_manager setupTimers];
        [[NSNotificationCenter defaultCenter] addObserver:_manager selector:@selector(didLoginUser) name:HYLoginSuccessNotification object:nil];
    });
    return _manager;
}

- (void)didLoginUser {
    balancesSec = 0;
//    promoteSec = 0;
    betAmountSec = 0;
    yebSec = 0;
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
    MyLog(@"@@@@@@ 余额管理者 @@@@@@ - 倒计时恢复60，余额定时器开始");
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
//    if (promoteSec > 0) {
//        promoteSec --;
//    }
    if (betAmountSec > 0) {
        betAmountSec --;
    }
    if (yebSec > 0) {
        yebSec --;
    }
    if (balancesSec <= 0 && betAmountSec <= 0 && yebSec <= 0) {
        MyLog(@"@@@@@@ 余额管理者 @@@@@@ - 倒计时全为0，余额定时器停止");
        [self pauseTimer];
    }
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

- (void)getWeeklyBetAmountHandler:(void(^)(BetAmountModel * _Nonnull))handler {
    if (_betAmountModel && betAmountSec > 0) {
        handler(_betAmountModel);
    } else {
        [self requestBetAmountHandler:^(BetAmountModel *model) {
            handler(model);
        }];
    }
}

- (void)getYuEBaoYesterdaySumHandler:(void (^)(CNYuEBaoBalanceModel * _Nonnull))handler {
    if (_yebModel && yebSec > 0) {
        handler(_yebModel);
    } else {
        [self requestYuEBaoYesterdaySumHandler:^(CNYuEBaoBalanceModel * model) {
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
                    eachSuccess(self.balanceDetailModel);
                }
                [successBlocks removeAllObjects];
            }
        }];
        
    }

}

/// 周有效投注额 + 月优惠和洗码
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

/// 余额宝昨日收益 + 季度收益
- (void)requestYuEBaoYesterdaySumHandler:(nullable void(^)(CNYuEBaoBalanceModel *))handler {
    [CNYuEBaoRequest checkYuEBaoInterestLogsSumHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            CNYuEBaoBalanceModel *yebModel = [CNYuEBaoBalanceModel cn_parse:responseObj];
            if ([yebModel isKindOfClass:[NSArray class]]) {
                yebModel = [[CNYuEBaoBalanceModel alloc] init];
                yebModel.interestDay = @0;
                yebModel.interestSeason = @0;
            }
            self.yebModel = yebModel;
            self->yebSec = 120;
            [self resumeTimer];
            if (handler) {
                handler(yebModel);
            }
        } else {
            if (handler) {
                handler(nil);
            }
        }
    }];
}



#pragma mark - Raw Request

+ (void)requestBetAmountHandler:(HandlerBlock)handler {
    NSMutableDictionary *param = [kNetworkMgr baseParam];
    param[@"currency"] = [CNUserManager shareManager].isUsdtMode?@"USDT":@"CNY";
    param[@"inclPromoAmount"] = @1;
    param[@"inclRebateAmount"] = @1;
    param[@"thisMonth"] = @1;
    
    [CNBaseNetworking POST:kGatewayExtraPath(config_betAmountLevel) parameters:param completionHandler:handler];
}

+ (void)requestAccountBalanceHandler:(HandlerBlock)handler {

    NSMutableDictionary *param = @{}.mutableCopy;
    
//    if ([CNUserManager shareManager].userDetail.newWalletFlag) {
        param[@"flag"] = @9; //1 缓存15秒 9不缓存 不传默认缓存2分钟
        param[@"walletCreditForPlatformFlag"] = @1; //需要游戏平台数据 ，如不需要则传0
        param[@"realtimeFlag"] = @"false"; // 新钱包模拟结算 [默认模拟，true：模拟，false：不模拟]
//    } else {
//        [param setObject:@"9" forKey:@"flag"];
//        [param setObject:[CNUserManager shareManager].isUsdtMode?@1:@0 forKey:@"defineFlag"];//1usdt账户余额  0人民币账户余额
//    }
    
    [CNBaseNetworking POST:(config_getBalanceInfo) parameters:param completionHandler:handler];

}

+ (void)requestWithdrawAbleBalanceHandler:(nullable  AccountBalancesBlock)handler {
    
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"flag"] = @9;
    param[@"walletCreditForPlatformFlag"] = @0;
    param[@"realtimeFlag"] = @"true";
    
    [CNBaseNetworking POST:(config_getBalanceInfo) parameters:param completionHandler:^(id responseObj, NSString *errorMsg) {
        if (!errorMsg) {
            AccountMoneyDetailModel *model = [AccountMoneyDetailModel cn_parse:responseObj];
            handler(model);
        }
    }];
    
}


@end
