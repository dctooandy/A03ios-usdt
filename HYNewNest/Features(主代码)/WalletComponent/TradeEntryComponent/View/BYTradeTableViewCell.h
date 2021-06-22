//
//  BYWithdrawYuEBaoTableViewCell.h
//  HYNewNest
//
//  Created by RM04 on 2021/6/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYTradeEntryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYTradeTableViewCell : UITableViewCell
- (void)setCellWithItem:(TradeEntrySetTypeItem *)item row:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
