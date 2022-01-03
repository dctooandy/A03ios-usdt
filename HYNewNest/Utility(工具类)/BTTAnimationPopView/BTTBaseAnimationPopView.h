//
//  BTTBaseAnimationPopView.h
//  Hybird_1e3c3b
//
//  Created by Domino on 16/11/2018.
//  Copyright © 2018 BTT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BTTDismissBlock)(void);

typedef void (^BTTCallBackBlock)(NSString * _Nullable phone,NSString * _Nullable captcha,NSString * _Nullable captchaId);

typedef void (^BTTCallBackBtnBlock)(UIButton * _Nullable btn);

NS_ASSUME_NONNULL_BEGIN

@interface BTTBaseAnimationPopView : UIView

+ (instancetype)viewFromXib;

@property (nonatomic, copy) BTTDismissBlock dismissBlock;

@property (nonatomic, copy) BTTCallBackBlock callBackBlock;

@property (nonatomic, copy) BTTCallBackBtnBlock btnBlock;

@end

NS_ASSUME_NONNULL_END
