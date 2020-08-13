//
//  LoadingView.h
//  INTEDSGame
//
//  Created by Robert on 13/04/2018.
//  Copyright © 2018 INTECH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (void)show;
+ (void)showSuccess;
+ (void)hide;

+ (void)showLoadingViewWithToView:(nullable UIView *)toView needMask:(BOOL)needMask;
+ (void)hideLoadingViewForView:(nullable UIView *)view;

@end
