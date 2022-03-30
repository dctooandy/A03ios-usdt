//
//  KYMSubmitButton.m
//  HYNewNest
//
//  Created by Key.L on 2022/2/28.
//  Copyright © 2022 BYGJ. All rights reserved.
//

#import "KYMSubmitButton.h"

@implementation KYMSubmitButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self setTitle:@"立即取款" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:0.3] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor colorWithRed:0xFF / 255.0 green:0xFF / 255.0 blue:0xFF / 255.0 alpha:1] forState:UIControlStateNormal];
    self.enabled = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.height*0.5;
    self.layer.masksToBounds = YES;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        [self setBackgroundImage:[UIImage imageNamed:@"l_btn_select"] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:[UIImage imageNamed:@"l_btn_hh"] forState:UIControlStateDisabled];
    }
}

@end
