//
//  NewVIPCumulateIdCell.h
//  HYNewNest
//
//  Created by RM03 on 2021/12/17.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNVIPRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewVIPCumulateIdCell : UITableViewCell
@property (nonatomic, strong) VIPIdentityModel *model;
@property (nonatomic, copy) void(^receivedBlcok)(void);
@property (nonatomic, copy) void(^expandBlcok)(NewVIPCumulateIdCell *cell, UIImageView *imgv);
@end

NS_ASSUME_NONNULL_END
