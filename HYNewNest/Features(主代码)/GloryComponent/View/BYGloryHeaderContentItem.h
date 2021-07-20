//
//  BYGloryHeaderContentView.h
//  HYNewNest
//
//  Created by RM04 on 2021/7/16.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"
#import <JXCategoryView/JXCategoryView.h>
#import "BYGloryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYGloryHeaderContentItem : CNBaseXibView <JXCategoryListContentViewDelegate>
- (void)setupGloryBanner:(GloryBannerModel *)model;

@end

NS_ASSUME_NONNULL_END
