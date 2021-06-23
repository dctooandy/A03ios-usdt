//
//  CNTaskModel.h
//  HYNewNest
//
//  Created by zaky on 4/13/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNTaskDetail :CNBaseModel
@property (nonatomic, assign) NSInteger             totalBetAmount;
@property (nonatomic, assign) NSInteger             totalRechargeAmount;
@end

@interface Result :CNBaseModel
@property (nonatomic , copy) NSString              * amount; //!< 金额
@property (nonatomic , assign) NSInteger             fetchResultFlag; //!< 任务状态：-1未完成（去完成）；0已完成（可领取）；1已领取
@property (nonatomic , copy) NSString              * prizeCode; //!< 任务code 领取时要传
@property (nonatomic , copy) NSString              * subtitle;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * ID; //!< 奖品ID 领取时要传
@property (nonatomic , copy) NSString              * createDate;
@property (nonatomic, assign) NSInteger             prizeAmount;
@property (nonatomic, assign) NSInteger             prizeLevel;
@end


@interface LimiteTask :CNBaseModel
@property (nonatomic , assign) NSInteger              endTime; //!< 限时任务时间结束 下面任务全失效
@property (nonatomic , strong) NSArray<Result*>     * result;
@property (nonatomic , assign) NSInteger              totalFlag;
@property (nonatomic , assign) NSInteger              totalAmount;

@end


@interface LoginTask :CNBaseModel
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , strong) NSArray<Result*>     * result;
@property (nonatomic , assign) BOOL                   isSignIn;

@end


@interface UpgradeTask :CNBaseModel
@property (nonatomic , assign) NSInteger              endTime; //!<进阶任务结束时间
@property (nonatomic , strong) NSArray<Result*>     * result;

@end


@interface CNTaskModel :CNBaseModel
@property (nonatomic , copy) NSString              * begin_date;
@property (nonatomic , copy) NSString              * end_date;
@property (nonatomic , strong) LimiteTask              * limiteTask;
@property (nonatomic , strong) LoginTask              * loginTask;
@property (nonatomic , strong) UpgradeTask              * upgradeTask;
@property (assign,nonatomic) NSInteger               beginFlag; //!<1进行中 0未开始 2已结束

@property (assign,nonatomic) BOOL isBeyondClaimTime; //!<所有奖品超过领取时间

@end

@interface CNTaskReceived : NSObject
@property (nonatomic, strong) NSString *receivedID;
@property (nonatomic, strong) NSString *receivedCode;
@property (nonatomic, assign) NSInteger receivedAmount;

- (instancetype)initWithID:(NSString *)rId andCode:(NSString *)code andAmount:(NSInteger)amount;

@end

@interface CNTaskReceivedReward : CNBaseModel
@property (nonatomic, assign) NSInteger sucAmount;
@end

NS_ASSUME_NONNULL_END
