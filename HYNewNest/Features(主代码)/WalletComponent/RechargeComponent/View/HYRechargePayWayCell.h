//
//  HYRechargePayWayCell.h
//  HYNewNest
//
//  Created by Lenhulk on 2020/8/3.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayWayV3Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYRechargePayWayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgvStatus;
@property (nonatomic, strong) DepositsBankModel *deposModel;
@property (nonatomic, strong) PayWayV3PayTypeItem *paywayModel;
@property (nonatomic, strong) BQBankModel *bqBank;
@end

NS_ASSUME_NONNULL_END
