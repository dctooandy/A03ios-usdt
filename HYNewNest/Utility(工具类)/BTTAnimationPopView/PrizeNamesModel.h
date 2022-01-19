//
//  PrizeNamesModel.h
//  HYNewNest
//
//  Created by RM03 on 2022/1/19.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrizeNamesModel : NSObject
@property (nonatomic, copy) NSString *prizeName;//奖品名
@property (nonatomic, copy) NSArray *users;//用户名
@end

NS_ASSUME_NONNULL_END
