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
+ (void)showUploadViewTo:(UIViewController *)superVC
                  billId:(NSString *)billId
                   promo:(BOOL)promo
                  upload:(BOOL)upload
           commitDeposit:(nullable void(^)(NSArray *receiptImages, NSArray *recordImages))commitBlock;
@end

NS_ASSUME_NONNULL_END
