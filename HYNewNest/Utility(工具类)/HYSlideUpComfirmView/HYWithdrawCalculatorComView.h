//
//  HYWithdrawCalculateComView.h
//  HYNewNest
//
//  Created by zaky on 10/19/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYSlideUpComfirmBaseView.h"
#import "WithdrawCalculateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYWithdrawCalculatorComView : HYSlideUpComfirmBaseView

+ (void)showWithCalculatorModel:(WithdrawCalculateModel *)model
       exchangeRatioOfAllAmount:(NSInteger)ratio
                  submitHandler:(SubmitComfirmArgsBlock)handler;

@end

NS_ASSUME_NONNULL_END
