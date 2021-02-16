//
//  CNHUB.h
//  HYNewNest
//
//  Created by Cean on 2020/7/17.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNHUB : CNBaseXibView

+ (void)showError:(NSString *)error;
+ (void)showSuccess:(NSString *)success;
+ (void)showWaiting:(NSString *)wait;
+ (void)showAlert:(NSString *)alert;
@end

NS_ASSUME_NONNULL_END
