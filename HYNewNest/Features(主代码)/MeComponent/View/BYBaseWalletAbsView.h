//
//  BYBaseWalletAbsView.h
//  HYNewNest
//
//  Created by zaky on 3/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYBaseWalletAbsView : CNBaseXibView
- (instancetype)init;
- (void)requestAccountBalances:(BOOL)isRefreshing;
@end

NS_ASSUME_NONNULL_END
