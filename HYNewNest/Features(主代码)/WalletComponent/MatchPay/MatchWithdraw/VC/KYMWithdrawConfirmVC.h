//
//  KYMWithdrawConfirmVC.h
//  HYNewNest
//
//  Created by Key.L on 2022/2/26.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KYMWithdrewCheckModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KYMWithdrawConfirmVC : UIViewController
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, strong) KYMWithdrewCheckModel *checkModel;
@property (nonatomic, strong) void(^submitHandler)(NSString *pwd, NSString *amount,BOOL isMatch);
@property (nonatomic, assign) BOOL isForceNormalWithdraw; //是否为强制普通取款
@end

NS_ASSUME_NONNULL_END
