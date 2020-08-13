//
//  CardBinTypeModel.h
//  INTEDSGame
//
//  Created by bux on 2018/4/5.
//  Copyright © 2018年 INTECH. All rights reserved.
//

#import "CNBaseModel.h"

@interface CardBinTypeModel : CNBaseModel


@property(nonatomic,copy) NSString *bankCode;
@property(nonatomic,copy) NSString *bankIcon;
@property(nonatomic,copy) NSString *bankName;
@property(nonatomic,copy) NSString *bankNo;
@property(nonatomic,copy) NSString *cardBin;
@property(nonatomic,copy) NSString *cardName;
@property(nonatomic,copy) NSString *cardNoLength;
@property(nonatomic,copy) NSString *cardType;
@property(nonatomic,copy) NSString *cardTypeDesc;


@end
