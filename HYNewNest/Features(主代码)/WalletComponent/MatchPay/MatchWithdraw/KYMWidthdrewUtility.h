//
//  KYMWidthdrewUtility.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/20.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KYMWithdrewCheckModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KYMWithdrewStep) {
    KYMWithdrewStepOne = 1, //第一步，已提交订单
    KYMWithdrewStepTwo = 2, //第二步，等待付款
    KYMWithdrewStepThree = 3, //第三步，待确认到账
    KYMWithdrewStepFour = 4, //第三步，未确认到账，订单异常
    KYMWithdrewStepFive = 5, //第四步，超时
    KYMWithdrewStepSix = 6, //第四步，取款完成
};

@interface KYMWidthdrewUtility : NSObject
/** 转换货币字符串 */
+ (NSString *)getMoneyString:(double)money;

+ (void)checkWithdraw:(UIViewController *)viewController totalAmount:(NSString *)totalAmount callBack:(void(^)(BOOL isMatch,KYMWithdrewCheckModel  * checkModel))callback;
@end

NS_ASSUME_NONNULL_END
