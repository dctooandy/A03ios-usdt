//
//  BYTradeEntryModel.h
//  HYNewNest
//
//  Created by RM04 on 2021/6/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeEntrySetTypeItem : CNBaseModel
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *type;
@end



@interface TradeBannerItem : CNBaseModel
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *url;
@end

@interface BYTradeEntryModel : CNBaseModel
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *banner;
@property (nonatomic, copy) NSString *setType;
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *h5_root;
@end

NS_ASSUME_NONNULL_END
