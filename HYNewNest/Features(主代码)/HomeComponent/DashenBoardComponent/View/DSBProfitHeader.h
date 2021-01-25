//
//  DSBProfitHeader.h
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPRankGradientTxtLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSBProfitHeader : UITableViewHeaderFooterView
// user
@property (weak, nonatomic) IBOutlet UILabel *tableCodeLbl;
@property (weak, nonatomic) IBOutlet VIPRankGradientTxtLabel *rankLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *profitCucLbl;
@end

NS_ASSUME_NONNULL_END
