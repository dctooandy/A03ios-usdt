//
//  VIPCumulateIdCell.h
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNVIPRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPCumulateIdCell : UITableViewCell
@property (nonatomic, strong) VIPIdentityModel *model;
@property (nonatomic, copy) void(^receivedBlcok)(void);
@property (nonatomic, copy) void(^expandBlcok)(void);
@end

NS_ASSUME_NONNULL_END
