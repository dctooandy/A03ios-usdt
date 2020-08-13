//
//  HYArticalCell.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/27.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticalModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 图文cell
@interface HYArticalCell : UITableViewCell
@property (nonatomic, strong) ArticalModel *model;
@end

NS_ASSUME_NONNULL_END
