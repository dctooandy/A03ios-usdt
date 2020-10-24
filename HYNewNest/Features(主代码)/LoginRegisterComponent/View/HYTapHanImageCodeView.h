//
//  HYTapHanImageCodeView.h
//  HYNewNest
//
//  Created by zaky on 10/23/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HYTapHanImgCodeViewDelegate <NSObject>

- (void)validationDidSuccess;

@end

@interface HYTapHanImageCodeView : CNBaseXibView
@property (nonatomic, readonly) NSString *imageCodeId;
@property (nonatomic, readonly) NSString *ticket;
@property (nonatomic, assign) BOOL correct;
@property (nonatomic, weak) id<HYTapHanImgCodeViewDelegate> delegate;

/// 获取验证码
- (void)getImageCode;
- (void)showSuccess;
@end

NS_ASSUME_NONNULL_END
