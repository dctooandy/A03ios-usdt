//
//  BYRechargeUSDTTopView.m
//  HYNewNest
//
//  Created by zaky on 3/30/21.
//  Copyright © 2021 BYGJ. All rights reserved.
//

#import "BYRechargeUSDTTopView.h"

@interface BYRechargeUSDTTopView()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation BYRechargeUSDTTopView

- (void)loadViewFromXib {
    [super loadViewFromXib];
    
    [self.contentView addCornerAndShadow];
    
}

- (IBAction)didTapMe:(id)sender {
    [NNPageRouter openExchangeElecCurrencyPage];
}

@end
