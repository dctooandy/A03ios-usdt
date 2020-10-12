//
//  VIPIdentityModel.h
//  HYNewNest
//
//  Created by zaky on 9/24/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPIdentityModel : CNBaseModel
@property (nonatomic , copy) NSString              * amount;//价值
@property (nonatomic , assign) NSInteger              clubLevel;
@property (nonatomic , assign) NSInteger              condition;//领取的条件
@property (nonatomic , assign) NSInteger              residueCount;//判断是否可领取
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , copy) NSString              * prizeId;//奖品ID
@property (nonatomic , copy) NSString              * introduce;//简介
@property (nonatomic , copy) NSString              * prizeUrl;//图片
@property (nonatomic , copy) NSString              * tagName;
@property (nonatomic , copy) NSString              * title;//标题

@end

NS_ASSUME_NONNULL_END
