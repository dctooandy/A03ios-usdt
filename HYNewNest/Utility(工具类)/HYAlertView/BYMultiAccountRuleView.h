//
//  BYMultiAccountRuleView.h
//  HYNewNest
//
//  Created by zaky on 7/9/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYMultiAccountRuleView : HYBaseAlertView
+ (void)showRuleWithLocatedY:(CGFloat)y;

+ (void)showRuleWithLocatedPoint:(CGPoint)p;

@end

NS_ASSUME_NONNULL_END
