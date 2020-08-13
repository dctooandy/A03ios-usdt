//
//  UserSubscribItem.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/24.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserSubscribItem : CNBaseModel

@property (copy,nonatomic) NSString *name;
@property (nonatomic,strong) NSNumber *subscribed;
@property (copy,nonatomic) NSString *code;

@end

NS_ASSUME_NONNULL_END
