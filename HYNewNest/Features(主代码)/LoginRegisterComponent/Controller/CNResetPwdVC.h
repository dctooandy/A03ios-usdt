//
//  CNResetPwdVC.h
//  HYNewNest
//
//  Created by Cean on 2020/7/20.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNResetPwdVC : CNBaseVC

@property (nonatomic, copy) NSString *smsCode; //从忘记密码进来需要
@property (nonatomic, strong) SamePhoneLoginNameModel *fpwdModel; //从忘记密码进来需要
@end

NS_ASSUME_NONNULL_END
