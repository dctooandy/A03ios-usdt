//
//  PayWayV3Model.h
//  HYGEntire
//
//  Created by zaky on 17/01/2020.
//  Copyright © 2020 kunlun. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 支付渠道
static NSString *FastPayType = @"FastPay";

/// 人民币支付渠道模型
@interface PayWayV3PayTypeItem : CNBaseModel

@property (nonatomic,copy) NSString *payType;
@property (nonatomic,copy) NSString *payTypeIcon;
@property (nonatomic,copy) NSString *payTypeName;
@property (nonatomic,copy) NSString *payTypeTip;
@property (nonatomic,assign) NSInteger minAmount;
@property (nonatomic,assign) NSInteger maxAmount;
/// 支付渠道
@property (nonatomic,copy) NSArray *protocolList;
@property (nonatomic,copy) NSString *showName;
@property (nonatomic,copy) NSString *typeNameEx;
@end


/// 人民币支付渠道父模型
@interface PayWayV3Model : CNBaseModel

@property (nonatomic, copy) NSString *lastPayType; //!<上次充值成功的类型
@property (strong, nonatomic) NSArray<PayWayV3PayTypeItem *> *payTypeList;

@end


#pragma mark - USDT支付渠道

///USDT支付渠道模型
@interface DepositsBankModel : CNBaseModel

@property (nonatomic , copy) NSString * bankIcon;
@property (nonatomic , copy) NSString * bankcode;
@property (nonatomic , copy) NSString * bankname;
@property (nonatomic , copy) NSString * bqpaytype;
@property (nonatomic , copy) NSString * currency;
@property (nonatomic , copy) NSString * cuslevel;
@property (nonatomic , copy) NSString * depositamount;
@property (nonatomic , copy) NSString * flag;
@property (nonatomic , copy) NSString * grade;
@property (nonatomic , copy) NSString * ID;
@property (nonatomic , assign) NSInteger isRecommendWallet;
@property (nonatomic , copy) NSString * isshow;
@property (nonatomic , copy) NSString * limitamount;
@property (nonatomic , assign) NSInteger maxAmount;
@property (nonatomic , assign) NSInteger minAmount;
@property (nonatomic , copy) NSString * payCategory;
@property (nonatomic , copy) NSString * payType;
@property (nonatomic , copy) NSString * product;
@property (nonatomic , assign) NSInteger pxh;
@property (nonatomic , copy) NSString * rate;
@property (nonatomic , copy) NSString * retelling;
@property (nonatomic , copy) NSString * timestamp;
@property (nonatomic , copy) NSString * token;
@property (nonatomic , copy) NSString * usdtProtocol;
@property (nonatomic , copy) NSString * bankaccountno;
/// 支付渠道
@property (nonatomic , copy) NSArray * protocolList;
@end


#pragma mark - 在线支付类支付

@interface OnlineBankAmountType : CNBaseModel

@property(nonatomic,copy) NSString *fix;
@property(nonatomic,strong) NSArray<NSNumber *> *amounts;

@end


@interface OnlineBankListItem : CNBaseModel

@property(nonatomic,copy) NSString *bankCode;
@property(nonatomic,copy) NSString *bankName;
@property(nonatomic,copy) NSString *bankIcon;
@property(nonatomic,copy) NSString *bankNo;

@end

///在线支付类 父模型
@interface OnlineBanksModel : CNBaseModel

@property(nonatomic,strong) OnlineBankAmountType *amountType;
@property(nonatomic,copy) NSString *maxAmount;
@property(nonatomic,copy) NSString *minAmount;
@property(nonatomic,copy) NSString *payid;
@property(nonatomic,copy) NSString *handleAmount;
@property(nonatomic,copy) NSString *netEarn;
@property(nonatomic,copy) NSArray<OnlineBankListItem *> *bankList;

@end


#pragma mark - 转账类支付

@interface AmountListModel : CNBaseModel

@property(nonatomic,copy) NSString *fix;
@property(nonatomic,strong) NSArray<NSNumber *> *amounts;
@property(nonatomic,strong) NSArray<NSDictionary *> *depositorList; //id,depositor 付款人
@property(nonatomic,assign) NSInteger maxAmount;
@property(nonatomic,assign) NSInteger minAmount;
@property(nonatomic,copy) NSString *handleAmount;

@end


@interface BQBankModel : CNBaseModel

@property (copy, nonatomic) NSString *bankIcon;
@property (copy, nonatomic) NSString *bankCode;
@property (copy, nonatomic) NSString *bankName;

@end




NS_ASSUME_NONNULL_END
