//
//  VIPCumulateIdButton.m
//  HYNewNest
//
//  Created by zaky on 9/23/20.
//  Copyright © 2020 emneoma.xyz. All rights reserved.
//

#import "VIPCumulateIdButton.h"

@implementation VIPCumulateIdButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    self.titleEdgeInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
    
    self.titleLabel.font = [UIFont fontPFSB16];
    [self setTitle:@"领取" forState:UIControlStateNormal];
    [self setTitle:@"不可领取" forState:UIControlStateDisabled];
    
    [self setTitleColor:kHexColor(0x6B460C) forState:UIControlStateNormal];
    [self setTitleColor:kHexColor(0x333333) forState:UIControlStateDisabled];

    [self setBackgroundImage:[UIImage imageNamed:@"ljsfbtn"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"ljsfbtn_dis"] forState:UIControlStateDisabled];
    
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (enabled) {
        self.titleLabel.font = [UIFont fontPFSB16];
        
    } else {
        self.titleLabel.font = [UIFont fontPFM14];
        
    }
}

@end
