//
//  DSBProfitFooter.h
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSBProfitFooter : UITableViewHeaderFooterView
@property (assign,nonatomic) BOOL isUsrOnline;
@property (nonatomic, copy) void(^ _Nullable btmBtnClikBlock)(void);
@property (nonatomic, copy) void(^ _Nullable btmBtnClikHistoryBlock)(void);
@end

NS_ASSUME_NONNULL_END
