//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"
static const NSInteger loadingTag = 10101;

@implementation MBProgressHUD (Add)

//只显示一个loading
+ (void)showLoadingSingleInView:(UIView *)view animated:(BOOL)animated {
    for (MBProgressHUD *subview in view.subviews) {
        if (subview.tag == loadingTag) {
            return;
        }
    }
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    
    hud.removeFromSuperViewOnHide = YES;
    hud.tag = loadingTag;
    [view addSubview:hud];
    [hud showAnimated:animated];
}


#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    
    [view bringSubviewToFront:hud];
    if (text.length > 10) {
        hud.detailsLabel.text = text;
    }else{
       hud.label.text = text;
    }
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    hud.customView = iconImage;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0];
}

+ (void)showWithTime:(NSString *)text icon:(NSString *)icon view:(UIView *)view duration:(NSTimeInterval)duration {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    
    [view bringSubviewToFront:hud];
    if (text.length > 10) {
        hud.detailsLabel.text = text;
    }else{
       hud.label.text = text;
    }
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    hud.customView = iconImage;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:duration];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"app_sad" view:view];
}

+ (void)showErrorWithTime:(NSString *)error toView:(UIView *)view duration:(NSTimeInterval)duration{
    [self showWithTime:error icon:@"app_sad" view:view duration:duration];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"app_smile" view:view];
}

+ (void)showSuccessWithTime:(NSString *)success toView:(UIView *)view duration:(NSTimeInterval)duration{
    [self showWithTime:success icon:@"app_smile" view:view duration:duration];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    
    [view bringSubviewToFront:hud];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //hud.dimBackground = NO;
    
    return hud;
}
+ (MBProgressHUD *)showMessagNoActivity:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    
    [view bringSubviewToFront:hud];
    hud.label.numberOfLines = 0;
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //hud.dimBackground = NO;
    [hud hideAnimated:YES afterDelay:2.0f];
    
    return hud;
}

+ (MBProgressHUD *)showMessageWithActivity:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:.8f];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = [UIColor whiteColor];
    
    [view bringSubviewToFront:hud];
    hud.label.numberOfLines = 0;
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //hud.dimBackground = NO;
    
    return hud;
}

+ (MBProgressHUD *)showCustomView:(NSString *)message toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo : (view == nil ? [UIApplication sharedApplication].keyWindow : view) animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.minSize = CGSizeMake(80,80);//定义弹窗的大小
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.bezelView.color = [UIColor blackColor];
    
    UIImage *image = [[UIImage imageNamed:@"dropdown_loading_01"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImageView* mainImageView= [[UIImageView alloc] initWithImage:image];
    mainImageView.animationImages = [NSArray arrayWithObjects:
                                     [UIImage imageNamed:@"dropdown_loading_01"],
                                     [UIImage imageNamed:@"dropdown_loading_02"],
                                     [UIImage imageNamed:@"dropdown_loading_03"],nil];
    [mainImageView setAnimationDuration:0.4f];
    [mainImageView setAnimationRepeatCount:0];
    [mainImageView startAnimating];
    hud.customView = mainImageView;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [view bringSubviewToFront:hud];
    return hud;
}

@end
