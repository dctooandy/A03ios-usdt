//
//  CNMUploadView.h
//  HYNewNest
//
//  Created by cean on 3/21/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNMUploadView : CNBaseXibView
+ (void)showUploadViewTo:(UIViewController *)superVC billId:(NSString *)billId;

@end

NS_ASSUME_NONNULL_END
