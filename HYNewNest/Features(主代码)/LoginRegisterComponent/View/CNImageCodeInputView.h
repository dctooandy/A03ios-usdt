//
//  CNImageCodeInputView.h
//  HYNewNest
//
//  Created by cean.q on 2020/7/15.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@class CNImageCodeInputView;
@protocol CNImageCodeInputViewDelegate
- (void)imageCodeViewTextChange:(CNImageCodeInputView *)view;
@end

@interface CNImageCodeInputView : CNBaseXibView
@property (nonatomic, readonly) NSString *imageCode;
@property (nonatomic, readonly) NSString *imageCodeId;
/// 图形验证码是否有值
@property (nonatomic, assign) BOOL correct;
@property (nonatomic, weak) id delegate;
/// 获取验证码
- (void)getImageCode;
@end

NS_ASSUME_NONNULL_END
