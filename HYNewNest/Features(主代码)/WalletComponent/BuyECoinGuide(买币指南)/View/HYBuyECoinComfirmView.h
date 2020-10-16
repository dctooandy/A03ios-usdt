//
//  HYBuyECoinComfirmView.h
//  HYNewNest
//
//  Created by zaky on 10/16/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayWayV3Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYBuyECoinComfirmView : UIView


+ (void)showWithDepositModels:(NSArray *)depositModels
                switchHandler:(void(^)(NSInteger idx))switchHandler
                submitHandler:(void(^)(NSString * amount))submitHandler ;

- (instancetype)initWithDepositModels:(NSArray *)depositModels
                        switchHandler:(void(^)(NSInteger idx))switchHandler
                        submitHandler:(void(^)(NSString * amount))submitHandler ;
- (void)show;

@end

NS_ASSUME_NONNULL_END
