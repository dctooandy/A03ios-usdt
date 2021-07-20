//
//  BYGloryTimelineTableViewCell.h
//  HYNewNest
//
//  Created by RM04 on 2021/7/19.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYGloryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYGloryTimelineTableViewCell : UITableViewCell
- (void)setupCell:(BYGloryModel *)model;
- (void)setToDefault;
- (void)hideDottedline:(BOOL)hidedn;
- (void)setMaskAlpha:(CGFloat)percent;
@end

NS_ASSUME_NONNULL_END
