//
//  NNPageRouter.h
//  HYNewNest
//
//  Created by zaky on 03/07/2020.
//  Copyright © 2020 james. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kCurNavVC [self currentTabbarSelectedNavigationController]

NS_ASSUME_NONNULL_BEGIN

@interface NNPageRouter : NSObject

+ (void)jump2MainPage;


// OTHER
+(void)deallocLastVcAfterPush:(UIViewController *)vc;
+(UITabBarController *)currentTabBarController;
+(UINavigationController *)currentTabbarSelectedNavigationController;
+(UIViewController*)currentViewController;

@end

NS_ASSUME_NONNULL_END
