//
//  CNTaskModel.h
//  HYNewNest
//
//  Created by zaky on 4/13/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Result :CNBaseModel
@property (nonatomic , copy) NSString              * amount; //!< 金额
@property (nonatomic , assign) NSInteger             fetchResultFlag; //!< 任务状态：-1未完成（去完成）；0已完成（可领取）；1已领取
@property (nonatomic , copy) NSString              * prizeCode; //!< 任务code 领取时要传
@property (nonatomic , copy) NSString              * subtitle;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * ID; //!< 奖品ID 领取时要传
@end


@interface LimiteTask :CNBaseModel
@property (nonatomic , assign) NSInteger              endTime; //!< 时间结束 下面任务全失效
@property (nonatomic , strong) NSArray<Result*>     * result;

@end


@interface LoginTask :CNBaseModel
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , strong) NSArray<Result*>     * result;

@end


@interface UpgradeTask :CNBaseModel
@property (nonatomic , assign) NSInteger              endTime;
@property (nonatomic , strong) NSArray<Result*>     * result;

@end


@interface CNTaskModel :CNBaseModel
@property (nonatomic , copy) NSString              * begin_date;
@property (nonatomic , copy) NSString              * end_date;
@property (nonatomic , strong) LimiteTask              * limiteTask;
@property (nonatomic , strong) LoginTask              * loginTask;
@property (nonatomic , strong) UpgradeTask              * upgradeTask;

@end

NS_ASSUME_NONNULL_END
