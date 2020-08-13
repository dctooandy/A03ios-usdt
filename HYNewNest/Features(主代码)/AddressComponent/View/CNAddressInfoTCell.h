//
//  CNAddressInfoTCell.h
//  HYNewNest
//
//  Created by Cean on 2020/7/31.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNAddressInfoTCell : UITableViewCell
@property (nonatomic, strong) AccountModel *model;
@property (nonatomic, copy) dispatch_block_t deleteBlock;
@end

NS_ASSUME_NONNULL_END
