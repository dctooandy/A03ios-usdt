//
//  VIPChartDSBCell.h
//  HYNewNest
//
//  Created by zaky on 9/8/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 大神榜
@interface VIPChartDSBCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbUsrName;
@property (weak, nonatomic) IBOutlet UILabel *lbBetAmount;
@property (weak, nonatomic) IBOutlet UILabel *lbDepositAmount;
@property (weak, nonatomic) IBOutlet UILabel *lbLevelName;

@end

NS_ASSUME_NONNULL_END
