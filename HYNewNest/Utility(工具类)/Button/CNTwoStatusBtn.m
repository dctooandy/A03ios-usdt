//
//  CNTwoStatusBtn.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/15.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNTwoStatusBtn.h"

@implementation CNTwoStatusBtn

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
    [self setTitleColor:kHexColorAlpha(0xFFFFFF, 0.3) forState:UIControlStateDisabled];
    [self setTitleColor:kHexColorAlpha(0xFFFFFF, 1.0) forState:UIControlStateNormal];
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
