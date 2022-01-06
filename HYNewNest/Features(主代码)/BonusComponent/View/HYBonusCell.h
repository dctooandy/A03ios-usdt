//
//  HYBonusCell.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/28.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPromoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYBonusCell : UITableViewCell
@property (nonatomic, copy) void(^tapMoreAction)(void);
@property (nonatomic, strong) MyPromoItem *model;
@end

NS_ASSUME_NONNULL_END
