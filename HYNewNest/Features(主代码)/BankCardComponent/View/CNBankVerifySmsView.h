//
//  CNBankVerifySmsView.h
//  HYNewNest
//
//  Created by Cean on 2020/8/12.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"
#import "SmsCodeModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface CNBankVerifySmsView : CNBaseXibView
+ (void)showPhone:(NSString *)phone finish:(void(^)(CNBankVerifySmsView *view, SmsCodeModel *smsModel))finishBlock;
@end

NS_ASSUME_NONNULL_END
