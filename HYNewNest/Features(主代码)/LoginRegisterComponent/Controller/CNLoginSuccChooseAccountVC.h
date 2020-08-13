//
//  CNLoginSuccChooseAccountVC.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/25.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseVC.h"
#import "SmsCodeModel.h"
#import "CNLoginRequest.h"
#import "CNUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNLoginSuccChooseAccountVC : CNBaseVC
@property (nonatomic, strong) SamePhoneLoginNameModel *samePhoneLogNameModel;
@end

NS_ASSUME_NONNULL_END
