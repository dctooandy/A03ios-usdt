//
//  AppDelegate.h
//  HYNewNest
//
//  Created by zaky on 02/07/2020.
//  Copyright © 2020 james. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (copy, nonatomic) NSString *token;

- (void)changeRootViewController:(UIViewController*)viewController;
- (void)initSDKNetWork;
@end

