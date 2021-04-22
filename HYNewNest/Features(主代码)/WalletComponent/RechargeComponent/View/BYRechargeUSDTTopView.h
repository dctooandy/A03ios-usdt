//
//  BYRechargeUSDTTopView.h
//  HYNewNest
//
//  Created by zaky on 3/30/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "CNBaseXibView.h"
#import "PayWayV3Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface BYRechargeUSDTTopView : UITableViewCell
@property (strong,nonatomic) DepositsBankModel * model; 
@property (assign,nonatomic) NSInteger lineIdx; // 行数 必须赋值
@property (copy,nonatomic) void(^didTapTopBgActionBlock)(NSInteger lineIdx);
@end

NS_ASSUME_NONNULL_END
