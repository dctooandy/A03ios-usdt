//
//  BalanceManager.m
//  HYNewNest
//
//  Created by zaky on 11/26/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "BalanceManager.h"
#import "CNUserCenterRequest.h"

@interface BalanceManager()
{
    NSUInteger balancesSec;
    NSUInteger promoteSec;
    NSUInteger betAmountSec;
}
@property (nonatomic, strong) AccountMoneyDetailModel *balanceDetailModel;
@property (nonatomic, strong) PromoteXimaModel        *promoteXimaModel;
@property (nonatomic, strong) BetAmountModel          *betAmountModel;
@property (nonatomic, weak) NSTimer *balanceTimer;

@end

@implementation BalanceManager

+ (instancetype)shareManager {
    static BalanceManager * _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[BalanceManager alloc] init];
        _manager->balancesSec = 60;
        _manager->promoteSec = 60;
        _manager->betAmountSec = 60;
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
    MyLog(@"@@@@@@@@@@@@ 倒计时恢复60，余额定时器开始");
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
    if (balancesSec == 0 && promoteSec == 0 && betAmountSec == 0) {
        MyLog(@"@@@@@@@@@@@@ 倒计时全为0，余额定时器停止");
        [self pauseTimer];
    }
//    MyLog(@"@@@@@@@@@@@@@ balancesSec = %lu, promoteSec = %lu, betAmount = %lu",balancesSec, promoteSec, betAmountSec);
}

- (void)getBalanceDetailHandler:(void(^)(AccountMoneyDetailModel * _Nonnull))handler {
    if (_balanceDetailModel && balancesSec > 0) {
        handler(_balanceDetailModel);
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
    [CNUserCenterRequest requestAccountBalanceHandler:^(id responseObj, NSString *errorMsg) {
        AccountMoneyDetailModel *model = [AccountMoneyDetailModel cn_parse:responseObj];
        self.balanceDetailModel = model;
        self->balancesSec = 60;
        [self resumeTimer];
        if (handler) {
            handler(model);
        }
    }];
}

/// 月优惠和洗码
- (void)requestMonthPromoteAndXimaHandler:(nullable void(^)(PromoteXimaModel *))handler {
    [CNUserCenterRequest requestMonthPromoteAndXimaHandler:^(id responseObj, NSString *errorMsg) {
        PromoteXimaModel *pxModel = [PromoteXimaModel cn_parse:responseObj];
        self.promoteXimaModel = pxModel;
        self->promoteSec = 60;
        [self resumeTimer];
        if (handler) {
            handler(pxModel);
        }
    }];
}

/// 周有效投注额
- (void)requestBetAmountHandler:(nullable void(^)(BetAmountModel *))handler {
    [CNUserCenterRequest requestBetAmountHandler:^(id responseObj, NSString *errorMsg) {
        BetAmountModel *betModel = [BetAmountModel cn_parse:responseObj];
        self.betAmountModel = betModel;
        self->betAmountSec = 60;
        [self resumeTimer];
        if (handler) {
            handler(betModel);
        }
    }];
}

@end
