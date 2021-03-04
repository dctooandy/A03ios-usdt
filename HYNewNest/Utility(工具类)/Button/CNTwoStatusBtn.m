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

- (void)setIsThirdStatusEnable:(BOOL)isThirdStatusEnable {
    if (isThirdStatusEnable) {
        self.enabled = YES;
        [self setTitleColor:kHexColor(0x19CECE) forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        UIColor *gradColor = [UIColor gradientFromColor:kHexColor(0x10B4DD) toColor:kHexColor(0x19CECE) withWidth:90];
        self.layer.borderColor = gradColor.CGColor;
        self.layer.borderWidth = 1.0;
    } else {
        [self setTitleColor:kHexColorAlpha(0xFFFFFF, 1.0) forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"l_btn_select"] forState:UIControlStateNormal];
//        self.layer.borderColor = kHexColor(0x19CECE).CGColor;
        self.layer.borderWidth = 0.0;
        self.enabled = NO;
    }
}

- (void)setTxtSize:(CGFloat)txtSize {
    self.titleLabel.font = [UIFont systemFontOfSize:txtSize weight:UIFontWeightMedium];
}

@end
