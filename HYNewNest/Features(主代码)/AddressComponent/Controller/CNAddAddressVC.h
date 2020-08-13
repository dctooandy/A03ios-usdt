//
//  CNAddAddressVC.h
//  HYNewNest
//
//  Created by Cean on 2020/7/30.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseVC.h"
#import "CNWDAccountRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNAddAddressVC : CNBaseVC
/// 区分当前是小金库地址还是其他地址
@property (nonatomic, assign) HYAddressType addrType;
@end

NS_ASSUME_NONNULL_END
