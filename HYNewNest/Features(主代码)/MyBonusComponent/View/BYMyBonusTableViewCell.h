//
//  BYMyBonusTableViewCell.h
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYMyBounsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BYMyBonusTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^tapMoreAction)(void);
@property (nonatomic, copy) void(^goFetchAction)(NSString* requestId);
@property (nonatomic, copy) void(^goDepositAction)(void);
@property (nonatomic, strong) BYMyBounsModel *model;
@end

NS_ASSUME_NONNULL_END
