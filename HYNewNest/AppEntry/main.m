//
//  main.m
//  HYNewNest
//
//  Created by zaky on 02/07/2020.
//  Copyright © 2020 james. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "tingyunApp/NBSAppAgent.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
#ifndef DEBUG
        [NBSAppAgent setRedirectURL:@"app.tingyunfenxi.com"];
        [NBSAppAgent startWithAppID:@"8c0c339fa2644e58881219d5b6a0d042"];
#endif
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
