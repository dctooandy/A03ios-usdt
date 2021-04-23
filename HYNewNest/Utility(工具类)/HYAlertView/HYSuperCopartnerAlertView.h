//
//  HYSuperCopartnerAlertView.h
//  HYNewNest
//
//  Created by zaky on 4/20/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "HYBaseAlertView.h"
#import "SuperCopartnerTbConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYSuperCopartnerAlertView : HYBaseAlertView

// 我的推荐礼金 我的洗码弹窗。回调只针对我的推荐礼金的“一键领取”
+ (void)showAlertViewType:(SuperCopartnerType)type handler:(AlertEasyBlock)handler;
@end

NS_ASSUME_NONNULL_END
