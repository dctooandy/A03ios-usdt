//
//  LoadingView.h
//  INTEDSGame
//
//  Created by Robert on 13/04/2018.
//  Copyright © 2018 INTECH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+ (void)showLoadingViewWithToView:(UIView *)toView;


+ (void)hideLoadingViewForView:(UIView *)view;
@end
