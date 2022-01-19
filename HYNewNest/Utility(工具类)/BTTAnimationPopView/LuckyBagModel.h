//
//  LuckyBagModel.h
//  HYNewNest
//
//  Created by RM03 on 2022/1/19.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <YYModel/YYModel.h>
@class LuckyBagDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface LuckyBagModel : NSObject
@property (nonatomic, copy) NSString *code;//状态码（用来区分加入失败的原因，200 成功，其它值 失败）
@property (nonatomic, copy) NSString *message;//信息描述
@property (nonatomic, copy) NSArray<LuckyBagDetailModel*> *data;//抽中的红包记录

@property (nonatomic, copy) NSArray *amountData;//需要的红包记录

@end


@interface LuckyBagDetailModel : NSObject

@property (nonatomic, copy) NSString *prizeCode;//奖品编码

@property (nonatomic, copy) NSString *prizeName;//奖品名称

@property (nonatomic, copy) NSString *count;

@property (nonatomic, copy) NSString *amount;//金额（只有现金红包有值，福卡时为0

@property (nonatomic, copy) NSString *currency;//币种(只对现金红包有效)

@end
NS_ASSUME_NONNULL_END
