//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+ (void)showLoadingSingleInView:(UIView *)view animated:(BOOL)animated;

+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showErrorWithTime:(NSString *)error toView:(UIView *)view duration:(NSTimeInterval)duration;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showSuccessWithTime:(NSString *)success toView:(UIView *)view duration:(NSTimeInterval)duration;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessagNoActivity:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showCustomView:(NSString *)message toView:(UIView *)view;
@end
