//
//  DSBHeaderSelectionView.h
//  HYNewNest
//
//  Created by zaky on 12/8/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSBHeaderSelectionView : CNBaseXibView
@property (nonatomic, copy) void(^didTapBtnBlock)(NSString *rankName);
@end

NS_ASSUME_NONNULL_END
