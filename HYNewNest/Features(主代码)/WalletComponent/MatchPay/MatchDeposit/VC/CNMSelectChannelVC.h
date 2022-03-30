//
//  CNMSelectChannelVC.h
//  Hybird_1e3c3b
//
//  Created by cean on 2/15/22.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "CNMDepositBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNMSelectChannelVC : CNMDepositBaseVC
@property (nonatomic, strong) NSArray *payments;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, copy) void(^finish)(NSInteger currentSelectedIndex);
@end

NS_ASSUME_NONNULL_END
