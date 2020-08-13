//
//  PayOnlineOrderModel.h
//  INTEDSGame
//
//  Created by bux on 2018/4/10.
//  Copyright © 2018年 INTECH. All rights reserved.
//

#import "CNBaseModel.h"


/// 提交在线订单 后获取到的模型
@interface PayOnlinePaymentModel : CNBaseModel

@property(nonatomic,copy) NSString *amount;
@property(nonatomic,copy) NSString *billDate;
@property(nonatomic,copy) NSString *billNo;
@property(nonatomic,copy) NSString *paycode;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *payUrl;


@end
