//
//  VIPGuideModel.h
//  HYNewNest
//
//  Created by zaky on 9/8/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPGuideModel : CNBaseModel
@property (nonatomic , assign) NSInteger              applyTimes;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , assign) NSInteger              maxRhlj;
@property (nonatomic , assign) NSInteger              maxYdfh;
@property (nonatomic , assign) NSInteger              maxZpTimes;
@property (nonatomic , assign) NSInteger              prizeCount;
@property (nonatomic , copy) NSString              * welfareMonth;

@end

NS_ASSUME_NONNULL_END
