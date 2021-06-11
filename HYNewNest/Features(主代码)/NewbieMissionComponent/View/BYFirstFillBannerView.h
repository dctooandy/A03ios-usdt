//
//  BYFirstFillBannerView.h
//  HYNewNest
//
//  Created by RM04 on 2021/5/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"
#import "BYMissionBannerDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface BYFirstFillBannerView : CNBaseXibView
@property (nonatomic, weak) id<BYMissionBannerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
