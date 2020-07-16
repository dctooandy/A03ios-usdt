//
//  CNOneStatusBtn.m
//  HYNewNest
//
//  Created by cean.q on 2020/7/16.
//  Copyright © 2020 james. All rights reserved.
//

#import "CNOneStatusBtn.h"

@implementation CNOneStatusBtn

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
//    self.layer.cornerRadius = self.height/2.0;
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self setTitleColor:kHexColorAlpha(0x138585, 1.0) forState:UIControlStateNormal];
     [self setBackgroundImage:[UIImage imageNamed:@"l_btn_line"] forState:UIControlStateNormal];
}

@end
