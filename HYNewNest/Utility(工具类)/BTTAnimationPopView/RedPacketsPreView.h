//
//  RedPacketsPreView.h
//  Hybird_1e3c3b
//
//  Created by RM03 on 2022/1/7.
//  Copyright © 2022 BTT. All rights reserved.
//

#import "BTTBaseAnimationPopView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^GetRedPacketsBlock)(void);
@interface RedPacketsPreView : BTTBaseAnimationPopView
@property (nonatomic, copy) GetRedPacketsBlock getRedBlock;
- (void)configForRedPocketsViewWithDuration:(int)duration;
@end

NS_ASSUME_NONNULL_END
