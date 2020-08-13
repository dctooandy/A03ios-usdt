//
//  CNShareView.h
//  HYNewNest
//
//  Created by Cean on 2020/8/7.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"
#import "CNShareCopyView.h"
#import "AdBannerGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNShareView : CNBaseXibView
@property (nonatomic, assign) CNShareType shareType;
+ (void)showShareViewWithModel:(FriendShareGroupModel *)model;
@end

NS_ASSUME_NONNULL_END
