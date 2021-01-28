//
//  DSBProfitHeader.h
//  HYNewNest
//
//  Created by zaky on 12/24/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPRankGradientTxtLabel.h"
#import "DSBGameRoundResModel.h"

#define kDewBall_WH ((kScreenWidth-30)/11.0)

NS_ASSUME_NONNULL_BEGIN

@interface DSBProfitHeader : UITableViewHeaderFooterView
// user
@property (weak, nonatomic) IBOutlet UILabel *tableCodeLbl;
@property (weak, nonatomic) IBOutlet VIPRankGradientTxtLabel *rankLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *profitCucLbl;

- (void)setupDrewsWith:(NSDictionary<NSString *,RoundResItem *> *)allDicts;

@end

NS_ASSUME_NONNULL_END
