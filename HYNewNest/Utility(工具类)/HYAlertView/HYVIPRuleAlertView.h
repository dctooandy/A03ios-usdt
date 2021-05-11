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
    RuleAlertKindYuEBao
};

/// 全文字规则弹窗
@interface HYVIPRuleAlertView : HYBaseAlertView

// 累计身份
+ (void)showCumulateIdentityRule;
// 超级合伙人
+ (void)showFriendShareV2Rule;
// 余额宝
+ (void)showYuEBaoRule;

@end

NS_ASSUME_NONNULL_END
