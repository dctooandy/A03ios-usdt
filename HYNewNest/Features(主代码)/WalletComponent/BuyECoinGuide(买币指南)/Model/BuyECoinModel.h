//
//  BuyECoinModel.h
//  HYNewNest
//
//  Created by zaky on 10/16/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuyECoinModel : CNBaseModel
@property (nonatomic, copy) NSString *imgList;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *recommend;
@property (nonatomic, copy) NSString *registerUrl;
@end

NS_ASSUME_NONNULL_END
