//
//  BYMoreCompleteMission.h
//  HYNewNest
//
//  Created by RM04 on 2021/5/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BYMoreCompleteDelegate <NSObject>

- (void)moreBannerClicked;

@end

@interface BYMoreCompleteMissionView : CNBaseXibView
@property (nonatomic, weak) id<BYMoreCompleteDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
