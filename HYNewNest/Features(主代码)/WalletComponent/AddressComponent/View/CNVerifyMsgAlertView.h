//
//  CNVerifyMsgAlertView.h
//  HYNewNest
//
//  Created by Cean on 2020/8/6.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN
@interface CNVerifyMsgAlertView : CNBaseXibView
+ (CNVerifyMsgAlertView *)showPhone:(NSString *)phone reSendCode:(dispatch_block_t)sendCodeBlock finish:(void(^)(NSString *smsCode))finishBlock;
- (void)resetCodeView;
+ (void)removeAlertView;
@end

NS_ASSUME_NONNULL_END
