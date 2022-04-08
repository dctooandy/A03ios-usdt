//
//  BYMyBounsModel.h
//  HYNewNest
//
//  Created by Andy on 2022/3/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYMyBounsModel : CNBaseModel
@property (nonatomic , copy) NSString              * abstractText;
@property (nonatomic , copy) NSString              * beginDate;
@property (nonatomic , assign) NSInteger              configId;

@property (nonatomic , copy) NSString              * endDate;

@property (nonatomic , copy) NSString              * imgTip;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , assign) NSInteger              isTop;
@property (nonatomic , copy) NSString              * linkUrl;
@property (nonatomic , copy) NSString              * promoCode;
@property (nonatomic , assign) NSInteger              promoFlag;
@property (nonatomic , assign) NSInteger              promoKind;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , assign) NSInteger              versionId;

// 我的优惠
@property (nonatomic , copy) NSString              * amount;
@property (nonatomic , copy) NSString              * betAmount;
@property (nonatomic , copy) NSString              * betMultiple;
@property (nonatomic , copy) NSString              * configurationId;
@property (nonatomic , copy) NSString              * createdDate;
@property (nonatomic , copy) NSString              * currency;
@property (nonatomic , copy) NSString              * customerLevel;
@property (nonatomic , assign) NSInteger           flag;
@property (nonatomic , copy) NSString              * loginName;
@property (nonatomic , copy) NSString              * maturityDate;
@property (nonatomic , copy) NSString              * pickUpTime;
@property (nonatomic , copy) NSString              * promotionName;
@property (nonatomic , copy) NSString              * promotionType;//优惠类型(HBYH用户优惠，XYLJ 幸运礼金，YHQLJ 优惠券礼金，YHQCS 优惠券存送)
@property (nonatomic , copy) NSString              * refAmount;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * requestId;
@property (nonatomic , copy) NSString              * sourceAmount;
@property (nonatomic , copy) NSString              * status; // 可领1 已领2 过期3 未存款4
@property (nonatomic , copy) NSString              * shortCreatedDate;
@property (nonatomic , copy) NSString              * shortMaturityDate;
@end

NS_ASSUME_NONNULL_END
