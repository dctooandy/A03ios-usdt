//
//  XmCalcAmountModel.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XmTypesItem :CNBaseModel
@property (nonatomic , assign) CGFloat              betAmount;
@property (nonatomic , assign) CGFloat              reduceBetAmount;//x
@property (nonatomic , assign) CGFloat              totalBetAmount;
@property (nonatomic , assign) CGFloat              xmAmount;
@property (nonatomic , assign) CGFloat              xmRate;
@property (nonatomic , copy) NSString              * xmType;

@property (nonatomic , copy) NSString              * xmName;
@end


@interface XmListItem :CNBaseModel
@property (nonatomic , assign) CGFloat              betAmount;
@property (nonatomic , assign) CGFloat              totalBetAmont;
@property (nonatomic , assign) CGFloat              xmAmount;
@property (nonatomic , assign) CGFloat              xmRate;
@property (nonatomic , strong) NSArray <XmTypesItem *>              * xmTypes;

@end


@interface XmCalcAmountModel :CNBaseModel
@property (nonatomic , assign) NSInteger              minXmAmount;//洗码金额最小值
@property (nonatomic , assign) NSInteger              totalBetAmount;
@property (nonatomic , assign) NSInteger              totalRemBetAmount;
@property (nonatomic , assign) NSInteger              totalXmAmount;//所有可洗码金额
@property (nonatomic , copy) NSString              * xmBeginDate;
@property (nonatomic , copy) NSString              * xmEndDate;
@property (nonatomic , strong) NSArray <XmListItem *>              * xmList;

@end

NS_ASSUME_NONNULL_END
