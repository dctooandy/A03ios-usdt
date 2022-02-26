//
//  CNWAmountListModel.h
//  HYNewNest
//
//  Created by cean on 2/26/22.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNWAmountListModel : JSONModel
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, assign) BOOL isRecommend;
@end

NS_ASSUME_NONNULL_END
