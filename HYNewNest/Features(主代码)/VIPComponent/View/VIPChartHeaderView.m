//
//  VIPChartHeaderView.m
//  HYNewNest
//
//  Created by zaky on 9/8/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPChartHeaderView.h"

@interface VIPChartHeaderView ()


@end

@implementation VIPChartHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = kHexColor(0x0A1D25);
        view;
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
