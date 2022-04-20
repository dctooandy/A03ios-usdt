//
//  KYMWithdrewFaildVC.h
//  Hybird_1e3c3b
//
//  Created by Key.L on 2022/2/21.
//  Copyright © 2022 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNBaseVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface KYMMatchWithdrewSuccessVC : CNBaseVC
@property (nonatomic, copy) NSString *amountStr;
@property (nonatomic, copy) NSString *transactionId;
///  YES 回到上一级页面，NO 回到 rootVC，默认NO
@property (nonatomic, assign) BOOL backToLastVC;
@end

NS_ASSUME_NONNULL_END
