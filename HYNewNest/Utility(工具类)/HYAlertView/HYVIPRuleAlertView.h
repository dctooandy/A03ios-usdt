//
//  HYVIPRuleAlertView.h
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "HYBaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RuleAlertKind) {
    RuleAlertKindVIPCumulateIdentity,
    RuleAlertKindSuperCopartner,
};

/// 累计身份/好友分享2.0 规则
@interface HYVIPRuleAlertView : HYBaseAlertView

+ (void)showCumulateIdentityRule;

+ (void)showFriendShareV2Rule;

@end

NS_ASSUME_NONNULL_END
