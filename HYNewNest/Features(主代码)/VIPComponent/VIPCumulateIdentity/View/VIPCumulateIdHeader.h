//
//  VIPCumulateIdHeader.h
//  HYNewNest
//
//  Created by zaky on 9/22/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VIPCumulateIdHeader : UITableViewHeaderFooterView
@property (nonatomic, copy) void(^didTapBtnBlock)(NSString *rankName);
@end

NS_ASSUME_NONNULL_END
