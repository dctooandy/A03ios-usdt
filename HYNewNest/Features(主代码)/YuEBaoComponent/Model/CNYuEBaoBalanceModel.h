//
//  CNYuEBaoBalanceModel.h
//  HYNewNest
//
//  Created by zaky on 5/21/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNYuEBaoBalanceModel : CNBaseModel
@property (strong,nonatomic) NSNumber *interestDay; //!<昨日收益
@property (strong,nonatomic) NSNumber *interestSeason; //!<季度收益
@end

NS_ASSUME_NONNULL_END
