//
//  PrizeRecordModel.h
//  HYNewNest
//
//  Created by RM03 on 2022/1/19.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrizeRecordModel : NSObject
@property (nonatomic, copy) NSString *prizeName;//奖品名
@property (nonatomic, copy) NSString *loginName;//用户名
@property (nonatomic, copy) NSString *winningAt;//中奖时间
@end

NS_ASSUME_NONNULL_END
