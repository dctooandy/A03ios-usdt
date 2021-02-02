//
//  HYDSBSlideUpViewCell.h
//  HYNewNest
//
//  Created by zaky on 12/28/20.
//  Copyright © 2020 BYGJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPRankGradientTxtLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYDSBSlideUpViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *crownImgv;
@property (weak, nonatomic) IBOutlet UIImageView *headShotImgv;
@property (weak, nonatomic) IBOutlet UILabel *rankLb;
@property (weak, nonatomic) IBOutlet VIPRankGradientTxtLabel *levelLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;


@end

NS_ASSUME_NONNULL_END
