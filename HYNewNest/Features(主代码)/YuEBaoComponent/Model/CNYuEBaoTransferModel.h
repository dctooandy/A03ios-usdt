//
//  CNYuEBaoTransferModel.h
//  HYNewNest
//
//  Created by zaky on 5/29/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNYuEBaoTransferModel : CNBaseModel
@property (nonatomic , strong) NSNumber            * amount; //转入/转出金额
@property (nonatomic , copy) NSString              * billno;  //计息单号
@property (nonatomic , copy) NSString              * lastProfitAmount; //上次计息金额
@property (nonatomic , assign) NSInteger              flag; //状态 [0=等待，1=通过，1=拒绝，9=确认失败]
@property (nonatomic , strong) NSString            * action; //转账类型 [IN=转入，OUT=转出]
@property (strong,nonatomic) NSString              * createdTime;
@end

NS_ASSUME_NONNULL_END
