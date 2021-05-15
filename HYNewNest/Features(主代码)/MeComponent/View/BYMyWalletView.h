//
//  BYMyWalletView.h
//  HYNewNest
//
//  Created by zaky on 3/12/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYBaseWalletAbsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYMyWalletView : BYBaseWalletAbsView
@property (assign,nonatomic,getter=isExpanded) BOOL expanded; //!<是否展开
@property (copy,nonatomic) void(^expandBlock)(BOOL isExpand);//!<展开操作
@end

NS_ASSUME_NONNULL_END
