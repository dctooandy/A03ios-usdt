//
//  BYNewbieModel.h
//  HYNewNest
//
//  Created by RM04 on 2021/5/24.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYNewbieTaskModel : CNBaseModel
@property (nonatomic , copy) NSString              * begin_date;
@property (nonatomic , copy) NSString              * end_date;
@property (assign,nonatomic) NSInteger               beginFlag; //!<1进行中 0未开始 2已结束

@property (assign,nonatomic) BOOL isBeyondClaimTime; //!<所有奖品超过领取时间
@end

NS_ASSUME_NONNULL_END
