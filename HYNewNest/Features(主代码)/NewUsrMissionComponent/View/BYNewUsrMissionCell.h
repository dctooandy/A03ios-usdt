//
//  BYNewUsrMissionCell.h
//  HYNewNest
//
//  Created by zaky on 4/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNTaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYNewUsrMissionCell : UITableViewCell
@property (assign,nonatomic) BOOL isUpgradeTask;
@property (assign,nonatomic) BOOL isTimeout; //!<已失效
@property (assign,nonatomic) BOOL isBeyondClaim; //!<已超过领取时间
@property (strong,nonatomic) Result *resModel;
@end

NS_ASSUME_NONNULL_END
