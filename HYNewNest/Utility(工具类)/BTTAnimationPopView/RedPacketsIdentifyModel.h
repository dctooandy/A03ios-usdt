//
//  RedPacketsIdentifyModel.h
//  HYNewNest
//
//  Created by RM03 on 2022/1/18.
//  Copyright © 2022 BYGJ. All rights reserved.
//


#import <YYModel/YYModel.h>
NS_ASSUME_NONNULL_BEGIN


@interface RedPacketsIdentifyModel : NSObject
@property (nonatomic, copy) NSString *code;//状态码（用来区分加入失败的原因，200 成功，其它值 失败
@property (nonatomic, copy) NSString *message;//信息描述
@property (nonatomic, copy) NSString *identify;//福袋唯一标识（打开福袋要用到此标识）


@end
NS_ASSUME_NONNULL_END
