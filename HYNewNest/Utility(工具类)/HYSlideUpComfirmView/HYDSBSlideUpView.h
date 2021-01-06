//
//  HYDSBSlideUpView.h
//  HYNewNest
//
//  Created by zaky on 12/28/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "HYSlideUpComfirmBaseView.h"
#import "DSBRecharWithdrwUsrModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYDSBSlideUpView : HYSlideUpComfirmBaseView
+ (void)showSlideupView:(NSArray <DSBRecharWithdrwUsrModel*> *)rankList title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
