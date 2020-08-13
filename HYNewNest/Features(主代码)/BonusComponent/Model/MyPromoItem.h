//
//  MyPromoItem.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/7/23.
//  Copyright © 2020 emneoma. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyPromoItem : CNBaseModel
@property (nonatomic , copy) NSString              * abstractText;
@property (nonatomic , copy) NSString              * beginDate;
@property (nonatomic , assign) NSInteger              configId;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , copy) NSString              * endDate;
@property (nonatomic , assign) NSInteger              flag;
@property (nonatomic , copy) NSString              * imgTip;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , assign) NSInteger              isTop;
@property (nonatomic , copy) NSString              * linkUrl;
@property (nonatomic , copy) NSString              * promoCode;
@property (nonatomic , assign) NSInteger              promoFlag;
@property (nonatomic , assign) NSInteger              promoKind;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , assign) NSInteger              versionId;
@end

NS_ASSUME_NONNULL_END
