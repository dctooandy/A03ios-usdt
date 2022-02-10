//
//  GiftCardModel.h
//  HYNewNest
//
//  Created by RM03 on 2022/1/19.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GiftCardModel : NSObject
@property (nonatomic, copy) NSString *cardCode;//福卡code
@property (nonatomic, copy) NSString *cardName;//福卡名称
@property (nonatomic, copy) NSString *count;//数量
@end

NS_ASSUME_NONNULL_END
