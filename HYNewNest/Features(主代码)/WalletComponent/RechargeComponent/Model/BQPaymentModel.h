//
//  BQPaymentModel.h
//  INTEDSGame
//
//  Created by bux on 2018/4/9.
//  Copyright © 2018年 INTECH. All rights reserved.
//

#import "CNBaseModel.h"


/// 提交BQ订单后 获取到的payment模型
@interface BQPaymentModel : CNBaseModel


@property(nonatomic,copy) NSString *accountName;
@property(nonatomic,copy) NSString *accountNo;
@property(nonatomic,copy) NSString *bankBranchName;
@property(nonatomic,copy) NSString *bankCity;
@property(nonatomic,copy) NSString *bankCode;
@property(nonatomic,copy) NSString *bankIcon;
@property(nonatomic,copy) NSString *bankName;
@property(nonatomic,copy) NSString *billNo;
@property(nonatomic,copy) NSString *postscript;
@property(nonatomic,copy) NSString *payLimitTime;
@property(nonatomic,copy) NSString *qrCode;
//@property(nonatomic,copy) NSString *realName;
@property(nonatomic,strong) NSNumber *amount;


// 以下参数已废弃
/**
 PayWayV3PayTypeItem.payTypeName
 */
@property(nonatomic,copy) NSString *payWay;
/**
 PayWayV3PayTypeItem.payType == 92 支付宝转账：0
 PayWayV3PayTypeItem.payType == 91 微信转账：1
 PayWayV3PayTypeItem.payType == 90 银行转账(不是手动转账）：2
 银行卡手动转账：3
 */
@property(nonatomic,strong) NSNumber *payWayType;



@end
