//
//  VIPChartDSBHeaderView.m
//  HYNewNest
//
//  Created by zaky on 9/8/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPChartDSBHeaderView.h"

@implementation VIPChartDSBHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = kHexColor(0x0A1D25);
        view;
    });
}

@end
