//
//  VIPNewVersionView.h
//  HYNewNest
//
//  Created by zaky on 9/6/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "CNBaseXibView.h"
#import "VIPGuideModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPNewVersionView : CNBaseXibView
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, strong) VIPGuideModel *model;
@property (nonatomic, copy) void(^tapBlock)(NSInteger curIdx);
@end

NS_ASSUME_NONNULL_END
