//
//  CNRecordTypeSelectorView.h
//  HYNewNest
//
//  Created by Cean on 2020/7/29.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseXibView.h"
#import "CreditQueryResultModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface CNElectionTypeSelectorView : CNBaseXibView
+ (void)showSelectorWithDefaultHall:(NSArray * _Nullable)halls defaultType:(NSArray * _Nullable)types defaultLine:(NSArray * _Nullable)lines callBack:(void (^)(NSArray *halls, NSArray *types, NSArray *lines))callBack;
@end

NS_ASSUME_NONNULL_END
