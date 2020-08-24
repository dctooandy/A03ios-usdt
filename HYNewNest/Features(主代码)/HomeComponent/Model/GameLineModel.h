//
//  GameLineModel.h
//  HYNewNest
//
//  Created by zaky on 8/24/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameLineModel : CNBaseModel
@property (nonatomic , copy)   NSString              * currency;
@property (nonatomic , assign) NSInteger              flag;
@property (nonatomic , copy)   NSString              * gameCode;
@property (nonatomic , copy)   NSString              * maintainBeginDate;
@property (nonatomic , copy)   NSString              * maintainEndDate;
@property (nonatomic , copy)   NSString              * platformCurrency;
@property (nonatomic , assign) NSInteger              transferFlag;
@end

NS_ASSUME_NONNULL_END
