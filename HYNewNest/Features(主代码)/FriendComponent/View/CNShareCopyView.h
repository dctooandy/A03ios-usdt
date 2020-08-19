//
//  CNShareCopyView.h
//  HYNewNest
//
//  Created by cean.q on 2020/8/7.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CNShareTypeWechat,
    CNShareTypeSMS,
    CNShareTypeSina,
    CNShareTypeQQ,
    CNShareTypeCopy,
    CNShareTypeWechatFriend,
} CNShareType;


@interface CNShareCopyView : CNBaseXibView
+ (void)showWithShareTpye:(CNShareType)type  url:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
